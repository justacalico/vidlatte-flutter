import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/collection.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory dir;
  late StorageService storage;

  setUpAll(() async {
    dir = await Directory.systemTemp.createTemp('hive-test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => dir.path,
    );
  });

  setUp(() async {
    storage = StorageService();
    await storage.init();
    await storage.clearAll();
  });

  test('servers round trip and default', () async {
    expect(storage.getServers(), isEmpty);
    final s1 = ComfyServer(id: 'a', name: 'A', url: 'u', createdAt: DateTime(2024));
    final s2 = ComfyServer(id: 'b', name: 'B', url: 'u', isDefault: true, createdAt: DateTime(2025));
    await storage.saveServer(s1);
    await storage.saveServer(s2);
    expect(storage.getServers().length, 2);
    expect(storage.getDefaultServer()!.id, 'b');
    expect(storage.getServer('a')!.name, 'A');
    await storage.setDefaultServer('a');
    expect(storage.getDefaultServer()!.id, 'a');
    await storage.deleteServer('b');
    expect(storage.getServers().length, 1);
  });

  test('images round trip, favorite, hidden, collection', () async {
    final img = GeneratedImage(id: 'i1', prompt: 'p', model: 'm', createdAt: DateTime(2024));
    await storage.saveImage(img);
    expect(storage.getImages().length, 1);
    expect(storage.getImage('i1')!.prompt, 'p');
    await storage.toggleFavorite('i1');
    expect(storage.getFavoriteImages().length, 1);
    await storage.toggleHidden('i1');
    await storage.setImageCollection('i1', 'c1');
    expect(storage.getImagesByCollection('c1').length, 1);
    final f = await storage.saveImageFile(Uint8List.fromList([1, 2, 3]), 'i1.png');
    expect(await storage.readImageFile(f), [1, 2, 3]);
    await storage.deleteImage('i1');
    expect(storage.getImages(), isEmpty);
  });

  test('collections round trip', () async {
    final c = Collection(id: 'c1', name: 'C', createdAt: DateTime(2024), updatedAt: DateTime(2024));
    await storage.saveCollection(c);
    expect(storage.getCollections().length, 1);
    final img = GeneratedImage(id: 'i2', prompt: 'p', model: 'm', collectionId: 'c1', createdAt: DateTime(2024));
    await storage.saveImage(img);
    await storage.deleteCollection('c1');
    expect(storage.getCollections(), isEmpty);
  });

  test('settings round trip', () async {
    expect(storage.getSettings().themeMode, 'system');
    await storage.saveSettings(const AppSettings(themeMode: 'dark', locale: 'ga'));
    expect(storage.getSettings().themeMode, 'dark');
  });

  test('sessions round trip', () async {
    final s = StudioSession(id: 's1', title: 'T', createdAt: DateTime(2024), updatedAt: DateTime(2024));
    await storage.saveSession(s);
    expect(storage.getSessions().length, 1);
    expect(storage.getSession('s1')!.title, 'T');
    await storage.deleteSession('s1');
    expect(storage.getSessions(), isEmpty);
  });

  test('prompt history round trip and clear', () async {
    await storage.savePromptHistoryEntry(PromptHistoryEntry(id: 'p1', prompt: 'x', createdAt: DateTime(2024)));
    expect(storage.getPromptHistory().length, 1);
    await storage.deletePromptHistoryEntry('p1');
    await storage.savePromptHistoryEntry(PromptHistoryEntry(id: 'p2', prompt: 'y', createdAt: DateTime(2024)));
    await storage.clearPromptHistory();
    expect(storage.getPromptHistory(), isEmpty);
  });

  test('llm servers round trip', () async {
    await storage.saveLlmServer(LlmServer(id: 'l1', name: 'L', url: 'u', createdAt: DateTime(2024)));
    expect(storage.getLlmServers().length, 1);
    expect(storage.getLlmServer('l1')!.name, 'L');
    await storage.deleteLlmServer('l1');
    expect(storage.getLlmServers(), isEmpty);
  });

  test('lora metadata round trip', () async {
    final m = LoraMetadata(serverId: 's', loraName: 'l', triggerWords: 'a', updatedAt: DateTime(2024));
    await storage.saveLoraMetadata(m);
    expect(storage.getLoraMetadata('s', 'l')!.triggerWords, 'a');
    expect(storage.getAllLoraMetadata('s').length, 1);
    await storage.deleteLoraMetadata('s', 'l');
    expect(storage.getAllLoraMetadata('s'), isEmpty);
  });
}
