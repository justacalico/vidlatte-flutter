import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/llm_model.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/services/llm_service.dart';

import 'dio_fake.dart';

void main() {
  final server = LlmServer(id: '1', name: 'lm', url: 'http://x', createdAt: DateTime(2024));

  LlmService svc(Map<String, dynamic> responses, [Map<Pattern, int> codes = const {}]) =>
      LlmService(dio: Dio()..httpClientAdapter = FakeAdapter(responses, statusCodes: codes));

  test('testConnection true on 200', () async {
    expect(await svc({'/models': {'data': []}}).testConnection(server), isTrue);
  });

  test('testConnection false on error', () async {
    expect(await svc({}, {'/models': 500}).testConnection(server), isFalse);
  });

  test('getModels returns models', () async {
    final l = await svc({'/models': {'data': [{'id': 'm1'}, {'id': 'm2'}]}}).getModels(server);
    expect(l.map((m) => m.identifier), ['m1', 'm2']);
  });

  test('chatCompletion returns content', () async {
    final r = await svc({'/chat/completions': {'choices': [{'message': {'content': 'hi'}}]}})
        .chatCompletion(server: server, model: 'm', messages: [const LlmChatMessage(role: 'user', content: 'x')]);
    expect(r.success, isTrue);
    expect(r.content, 'hi');
  });

  test('chatCompletion empty choices', () async {
    final r = await svc({'/chat/completions': {'choices': []}})
        .chatCompletion(server: server, model: 'm', messages: const []);
    expect(r.success, isFalse);
  });

  test('chatCompletion 4xx tries LM Studio load then succeeds', () async {
    var chatCalls = 0;
    final adapter = _RetryAdapter(() => chatCalls++);
    final s = LlmService(dio: Dio()..httpClientAdapter = adapter);
    final r = await s.chatCompletion(server: server, model: 'm', messages: const []);
    expect(r.success, isTrue);
    expect(chatCalls, 2);
  });
}

class _RetryAdapter implements HttpClientAdapter {
  final void Function() onChat;
  _RetryAdapter(this.onChat);
  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<List<int>>? s, Future<void>? c) async {
    if (o.path.contains('chat/completions')) {
      onChat();
      if (_first) { _first = false; return ResponseBody.fromString('{}', 400, headers: {Headers.contentTypeHeader: ['application/json']}); }
    }
    if (o.path.contains('models/load')) return ResponseBody.fromString('{}', 200, headers: {Headers.contentTypeHeader: ['application/json']});
    return ResponseBody.fromString('{"choices":[{"message":{"content":"ok"}}]}', 200, headers: {Headers.contentTypeHeader: ['application/json']});
  }
  var _first = true;
  @override
  void close({bool force = false}) {}
}
