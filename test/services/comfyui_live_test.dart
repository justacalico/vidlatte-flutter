import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generation_job.dart';
import 'package:vidlatte/services/comfyui_service.dart';

class _RealHttp extends HttpOverrides {}

void main() {
  late HttpServer server;
  late ComfyServer comfy;
  late ComfyService svc;
  String? lastWsPath;

  setUpAll(() async {
    HttpOverrides.global = _RealHttp();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((req) async {
      if (req.uri.path == '/ws') {
        final ws = await WebSocketTransformer.upgrade(req);
        lastWsPath = req.uri.path;
        ws.add(jsonEncode({'type': 'executing', 'data': {'node': '5', 'prompt_id': 'p'}}));
        ws.add(jsonEncode({'type': 'progress', 'data': {'value': 2, 'max': 10}}));
        ws.add(jsonEncode({'type': 'executed', 'data': {'node': '5'}}));
        ws.add(jsonEncode({'type': 'status', 'data': {'status': {'exec_info': {'nodes_executed': 3, 'nodes_remaining': 1}}}}));
        ws.add(jsonEncode({'type': 'execution_start', 'data': {'prompt_id': 'p'}}));
        ws.add(jsonEncode({'type': 'executing', 'data': {'node': null, 'prompt_id': 'p'}}));
        ws.add(jsonEncode({'type': 'unknown_type'}));
        ws.add(Uint8List.fromList([1, 2])); // non-string branch
        ws.add('not json');
        return;
      }
      if (req.uri.path.startsWith('/history/')) {
        req.response
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({
            'p': {'outputs': {'9': {'images': [{'filename': 'out.png', 'subfolder': '', 'type': 'output'}]}}}
          }))
          ..close();
        return;
      }
      if (req.uri.path == '/view') {
        req.response.write(utf8.encode('PNGDATA'));
        req.response.close();
        return;
      }
      if (req.uri.path == '/prompt') {
        req.response
          ..headers.contentType = ContentType.json
          ..write('{"prompt_id":"p"}')
          ..close();
        return;
      }
      if (req.uri.path == '/upload/image') {
        req.response
          ..headers.contentType = ContentType.json
          ..write('{"name":"up.png","subfolder":"","type":"input"}')
          ..close();
        return;
      }
      req.response.statusCode = 404;
      await req.response.close();
    });
    comfy = ComfyServer(id: 's', name: 't', url: 'http://127.0.0.1:${server.port}', createdAt: DateTime(2024));
    svc = ComfyService();
  });

  tearDownAll(() async {
    svc.dispose();
    await server.close();
  });

  test('pollForResult success with ws previews', () async {
    final previews = <PreviewMessage>[];
    final r = await svc.pollForResult(comfy, 'p', onPreview: previews.add, maxAttempts: 5);
    expect(r.success, isTrue);
    expect(r.filename, 'out.png');
    expect(previews.any((m) => m.type == 'complete'), isTrue);
    await Future.delayed(const Duration(milliseconds: 300));
  });

  test('pollForResult timeout', () async {
    final bad = ComfyServer(id: 's2', name: 't', url: 'http://127.0.0.1:1', createdAt: DateTime(2024));
    final r = await svc.pollForResult(bad, 'p', maxAttempts: 1);
    expect(r.success, isFalse);
  });

  test('generateImage full flow', () async {
    final r = await svc.generateImage(comfy, prompt: 'p', model: 'm', hiresFix: true, onPreview: (_) {});
    expect(r.success, isTrue);
  });

  test('generateImage with img2img and controlnet', () async {
    final r = await svc.generateImage(comfy, prompt: 'p', model: 'm',
        refImageFilename: 'in.png', refImageSubfolder: '', refImageType: 'input',
        controlnetModel: 'cn', controlImageFilename: 'c.png');
    expect(r.success, isTrue);
  });

  test('faceRestore flow', () async {
    final r = await svc.faceRestore(comfy, filename: 'f.png', type: 'input');
    expect(r.success, isTrue);
  });

  test('upscale flow', () async {
    final r = await svc.upscale(comfy, filename: 'f.png', type: 'input', model: 'm.pth', scale: 2);
    expect(r.success, isTrue);
  });

  test('inpaint flow', () async {
    final r = await svc.inpaint(comfy, imageFilename: 'i.png', maskFilename: 'm.png',
        prompt: 'p', model: 'm', denoise: 0.6);
    expect(r.success, isTrue);
  });

  test('submitWorkflow failure path', () async {
    final bad = ComfyServer(id: 's3', name: 't', url: 'http://127.0.0.1:1', createdAt: DateTime(2024));
    expect(svc.submitWorkflow(bad, {}), throwsA(isA<ComfyApiException>()));
  });
}
