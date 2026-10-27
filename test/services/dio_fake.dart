import 'dart:convert';

import 'package:dio/dio.dart';

class FakeAdapter implements HttpClientAdapter {
  final Map<String, dynamic> responses;
  final Map<Pattern, int> statusCodes;
  int calls = 0;

  FakeAdapter(this.responses, {this.statusCodes = const {}});

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
    calls++;
    final path = options.path;
    var status = 200;
    for (final e in statusCodes.entries) {
      if (e.key.allMatches(path).isNotEmpty) status = e.value;
    }
    dynamic body;
    for (final e in responses.entries) {
      if (path.contains(e.key)) { body = e.value; break; }
    }
    body ??= <String, dynamic>{};
    final bytes = body is List<int> ? body : utf8.encode(jsonEncode(body));
    return ResponseBody.fromBytes(
      bytes,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
      statusMessage: 'OK',
    );
  }

  @override
  void close({bool force = false}) {}
}
