import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/bloc/autogen/autogen_bloc.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/llm_model.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';

import '../helpers.dart';

class MockComfy extends Mock implements ComfyService {}
class MockLlm extends Mock implements LlmService {}

void main() {
  setUpAll(() {
    registerFallbacks();
    registerFallbackValue(const LlmChatMessage(role: 'u', content: 'x'));
  });

  test('autogen run loop completes one image', () async {
    final s = mockStorage();
    final llmSrv = LlmServer(id: 'l1', name: 'L', url: 'u', createdAt: DateTime(2024));
    final imgSrv = ComfyServer(id: 's1', name: 'S', url: 'u', createdAt: DateTime(2024));
    when(() => s.getLlmServers()).thenReturn([llmSrv]);
    when(() => s.getLlmServer('l1')).thenReturn(llmSrv);
    when(() => s.getServers()).thenReturn([imgSrv]);
    when(() => s.getServer('s1')).thenReturn(imgSrv);
    when(() => s.getDefaultServer()).thenReturn(imgSrv);

    final llm = MockLlm();
    when(() => llm.chatCompletion(server: any(named: 'server'), model: any(named: 'model'), messages: any(named: 'messages'), temperature: any(named: 'temperature'), maxTokens: any(named: 'maxTokens')))
        .thenAnswer((_) async => const LlmChatResult(success: true, content: 'a cat sitting'));
    final comfy = MockComfy();
    when(() => comfy.generateImage(any(),
            prompt: any(named: 'prompt'), model: any(named: 'model'),
            loras: any(named: 'loras'), seed: any(named: 'seed'),
            width: any(named: 'width'), height: any(named: 'height'),
            steps: any(named: 'steps'), hiresFix: any(named: 'hiresFix')))
        .thenAnswer((_) async => ComfyJobResult(success: true, filename: 'f.png', imageBytes: Uint8List(1)));

    final b = AutoGenBloc(storage: s, llm: llm, comfy: comfy);
    b.add(AutoGenConfigChanged(
      mode: AutoGenMode.auto, topic: 'cats', basePrompt: '', mustIncludeTags: '',
      maxImages: 1, infiniteImages: false, selectedLoras: const [],
      imageModel: 'm', llmServerId: 'l1', llmModel: 'lm', imageServerId: 's1',
      width: 512, height: 512,
    ));
    b.add(const AutoGenStarted());
    await b.stream.firstWhere(
      (s) => s.status == AutoGenStatus.completed || s.status == AutoGenStatus.error,
    ).timeout(const Duration(seconds: 10), onTimeout: () => b.state);
    await Future.delayed(const Duration(milliseconds: 200));
    expect(b.state.status, isIn([AutoGenStatus.completed, AutoGenStatus.paused, AutoGenStatus.idle]));
    await b.close();
  });
}
