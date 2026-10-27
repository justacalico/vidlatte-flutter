import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/bloc/prompt_history/prompt_history_bloc.dart';
import 'package:vidlatte/bloc/prompt_history/prompt_history_event.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';

import '../helpers.dart';

void main() {
  setUpAll(registerFallbacks);
  late MockStorage storage;
  final history = <PromptHistoryEntry>[];
  setUp(() {
    history.clear();
    storage = mockStorage();
    when(() => storage.getPromptHistory()).thenAnswer((_) => List.of(history));
    when(() => storage.savePromptHistoryEntry(any()))
        .thenAnswer((i) async => history.add(i.positionalArguments[0] as PromptHistoryEntry));
    when(() => storage.deletePromptHistoryEntry(any()))
        .thenAnswer((i) async => history.removeWhere((e) => e.id == i.positionalArguments[0]));
    when(() => storage.clearPromptHistory()).thenAnswer((_) async => history.clear());
  });

  test('loads entries', () async {
    final e = PromptHistoryEntry(id: 'p', prompt: 'x', createdAt: DateTime(2024));
    history.add(e);
    final b = PromptHistoryBloc(storage: storage);
    b.add(PromptHistoryLoadRequested());
    await Future.delayed(Duration.zero);
    expect(b.state.entries, [e]);
    expect(b.state.isLoading, isFalse);
  });

  test('adds entry', () async {
    final b = PromptHistoryBloc(storage: storage);
    b.add(PromptHistoryLoadRequested());
    await Future.delayed(Duration.zero);
    b.add(const PromptHistoryEntryAdded(prompt: 'hello', model: 'm'));
    await Future.delayed(const Duration(milliseconds: 10));
    expect(b.state.entries.first.prompt, 'hello');
    verify(() => storage.savePromptHistoryEntry(any())).called(1);
  });

  test('deletes and clears', () async {
    final b = PromptHistoryBloc(storage: storage);
    b.add(PromptHistoryLoadRequested());
    await Future.delayed(Duration.zero);
    b.add(const PromptHistoryEntryAdded(prompt: 'del', model: 'm'));
    await Future.delayed(Duration.zero);
    b.add(PromptHistoryEntryDeleted(history.first.id));
    await Future.delayed(Duration.zero);
    b.add(PromptHistoryCleared());
    await Future.delayed(Duration.zero);
    verify(() => storage.deletePromptHistoryEntry(any())).called(1);
    verify(() => storage.clearPromptHistory()).called(1);
    expect(b.state.entries, isEmpty);
  });

  test('state equality', () {
    expect(const PromptHistoryState(), const PromptHistoryState());
  });
}
