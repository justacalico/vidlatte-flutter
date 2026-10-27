import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/services/comfyui_service.dart';

import 'dio_fake.dart';

void main() {
  final server = ComfyServer(id: 's1', name: 'c', url: 'http://c.local/', createdAt: DateTime(2024));

  ComfyService svc(Map<String, dynamic> r, [Map<Pattern, int> codes = const {}]) =>
      ComfyService(dio: Dio()..httpClientAdapter = FakeAdapter(r, statusCodes: codes));

  test('checkHealth healthy', () async {
    final h = await svc({'/system_stats': {'system': {'os': 'linux', 'python_version': '3.12', 'ram_total': 8, 'ram_free': 4}, 'devices': ['cuda']}}).checkHealth(server);
    expect(h.healthy, isTrue);
    expect(h.devices, ['cuda']);
    expect(h.os, 'linux');
  });

  test('checkHealth http error', () async {
    final h = await svc({}, {'/system_stats': 500}).checkHealth(server);
    expect(h.healthy, isFalse);
  });

  test('checkHealth invalid response', () async {
    final h = await svc({'/system_stats': {}}).checkHealth(server);
    expect(h.healthy, isFalse);
    expect(h.error, 'Invalid ComfyUI response');
  });

  test('getModels returns catalog', () async {
    final c = await svc({
      'CheckpointLoaderSimple': {'CheckpointLoaderSimple': {'input': {'required': {'ckpt_name': [['m.ckpt']]}}}},
      'LoraLoader': {'LoraLoader': {'input': {'required': {'lora_name': [['l.safetensors']]}}}},
      'ControlNetLoader': {'ControlNetLoader': {'input': {'required': {'control_net_name': [['cn.pt']]}}}},
      'UpscaleModelLoader': {'UpscaleModelLoader': {'input': {'required': {'model_name': [['up.pth']]}}}},
    }).getModels(server);
    expect(c.models, contains('m.ckpt'));
    expect(c.loras, contains('l.safetensors'));
    expect(c.controlnets, contains('cn.pt'));
    expect(c.upscaleModels, contains('up.pth'));
  });

  test('getModels throws on error', () {
    expect(svc({}, {'object_info': 500}).getModels(server), throwsA(isA<ComfyApiException>()));
  });

  test('getLoraMetadata returns map or null', () async {
    expect(await svc({'/loras': {'a': {'x': 1}}}).getLoraMetadata(server, 'l'), isNotNull);
    expect(await svc({}, {'/loras': 404}).getLoraMetadata(server, 'l'), isNull);
  });

  test('submitWorkflow returns prompt id', () async {
    final id = await svc({'/prompt': {'prompt_id': 'p1'}}).submitWorkflow(server, {});
    expect(id, 'p1');
  });

  test('submitWorkflow throws on error', () {
    expect(svc({}, {'/prompt': 500}).submitWorkflow(server, {}), throwsA(isA<ComfyApiException>()));
  });

  test('getImage returns bytes', () async {
    final b = await svc({'/view': [1, 2, 3]}).getImage(server, 'f.png', '', 'output');
    expect(b, [1, 2, 3]);
  });

  test('uploadImage posts file', () async {
    final s = svc({'/upload/image': {'name': 'a.png', 'subfolder': '', 'type': 'input'}});
    final r = await s.uploadImage(server, Uint8List.fromList([1, 2]), 'a.png');
    expect(r.filename, 'a.png');
  });

  test('dispose closes dio', () => svc({}).dispose());
}
