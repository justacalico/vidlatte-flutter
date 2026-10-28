import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/bloc/autogen/autogen_bloc.dart';
import 'package:vidlatte/bloc/gallery/gallery_bloc.dart';
import 'package:vidlatte/bloc/generation/generation_bloc.dart';
import 'package:vidlatte/bloc/llm/llm_bloc.dart';
import 'package:vidlatte/bloc/prompt_history/prompt_history_bloc.dart';
import 'package:vidlatte/bloc/servers/servers_bloc.dart';
import 'package:vidlatte/bloc/settings/settings_bloc.dart';
import 'package:vidlatte/bloc/studio/studio_bloc.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/collection.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/config/theme.dart';
import 'package:vidlatte/l10n/app_strings.dart';

import 'package:dio/dio.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';
import 'package:vidlatte/data/models/llm_model.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/services/storage_service.dart';
import 'package:vidlatte/services/update_checker.dart';

class MockStorage extends Mock implements StorageService {}

void registerFallbacks() {
  registerFallbackValue(const AppSettings());
  registerFallbackValue(ComfyServer(id: '', name: '', url: '', createdAt: DateTime(2024)));
  registerFallbackValue(GeneratedImage(id: '', prompt: '', model: '', createdAt: DateTime(2024)));
  registerFallbackValue(StudioSession(id: '', title: '', createdAt: DateTime(2024), updatedAt: DateTime(2024)));
  registerFallbackValue(Collection(id: '', name: '', createdAt: DateTime(2024), updatedAt: DateTime(2024)));
  registerFallbackValue(PromptHistoryEntry(id: '', prompt: '', createdAt: DateTime(2024)));
  registerFallbackValue(LlmServer(id: '', name: '', url: '', createdAt: DateTime(2024)));
  registerFallbackValue(LoraMetadata(serverId: '', loraName: '', updatedAt: DateTime(2024)));
  registerFallbackValue(Uint8List(0));
}

MockStorage mockStorage({AppSettings settings = const AppSettings()}) {
  final s = MockStorage();
  when(() => s.getSettings()).thenReturn(settings);
  when(() => s.getServers()).thenReturn([]);
  when(() => s.getDefaultServer()).thenReturn(null);
  when(() => s.getImages()).thenReturn([]);
  when(() => s.getFavoriteImages()).thenReturn([]);
  when(() => s.getImagesByCollection(any())).thenReturn([]);
  when(() => s.getAllLoraMetadata(any())).thenReturn([]);
  when(() => s.getCollections()).thenReturn([]);
  when(() => s.getSessions()).thenReturn([]);
  when(() => s.getPromptHistory()).thenReturn([]);
  when(() => s.getLlmServers()).thenReturn([]);
  when(() => s.getLoraMetadata(any(), any())).thenReturn(null);
  when(() => s.saveSettings(any())).thenAnswer((_) async {});
  when(() => s.saveServer(any())).thenAnswer((_) async {});
  when(() => s.saveImage(any())).thenAnswer((_) async {});
  when(() => s.saveSession(any())).thenAnswer((_) async {});
  when(() => s.saveCollection(any())).thenAnswer((_) async {});
  when(() => s.savePromptHistoryEntry(any())).thenAnswer((_) async {});
  when(() => s.saveLlmServer(any())).thenAnswer((_) async {});
  when(() => s.saveImageFile(any(), any())).thenAnswer((_) async => 'img.png');
  when(() => s.deleteSession(any())).thenAnswer((_) async {});
  when(() => s.deleteImage(any())).thenAnswer((_) async {});
  when(() => s.deleteServer(any())).thenAnswer((_) async {});
  when(() => s.deleteCollection(any())).thenAnswer((_) async {});
  when(() => s.deleteLlmServer(any())).thenAnswer((_) async {});
  when(() => s.deletePromptHistoryEntry(any())).thenAnswer((_) async {});
  when(() => s.deleteLoraMetadata(any(), any())).thenAnswer((_) async {});
  when(() => s.deleteAllLoraMetadata(any())).thenAnswer((_) async {});
  when(() => s.toggleFavorite(any())).thenAnswer((_) async {});
  when(() => s.toggleHidden(any())).thenAnswer((_) async {});
  when(() => s.setImageCollection(any(), any())).thenAnswer((_) async {});
  when(() => s.setDefaultServer(any())).thenAnswer((_) async {});
  when(() => s.saveLoraMetadata(any())).thenAnswer((_) async {});
  when(() => s.saveLoraMetadataBatch(any(), any())).thenAnswer((_) async {});
  when(() => s.clearPromptHistory()).thenAnswer((_) async {});
  when(() => s.clearAll()).thenAnswer((_) async {});
  return s;
}

Widget testApp({
  required Widget child,
  required StorageService storage,
  UpdateChecker? updateChecker,
  Locale? locale,
  ComfyService? comfy,
  LlmService? llm,
}) {
  comfy ??= FakeComfyService();
  llm ??= FakeLlmService();
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<StorageService>.value(value: storage),
      ChangeNotifierProvider<UpdateChecker>.value(
        value: updateChecker ?? NoNetworkUpdateChecker(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsBloc(storage: storage)..add(SettingsLoadRequested())),
        BlocProvider(create: (_) => ServersBloc(storage: storage, comfy: comfy)..add(ServersLoadRequested())),
        BlocProvider(create: (_) => GenerationBloc(storage: storage, comfy: comfy)),
        BlocProvider(create: (_) => GalleryBloc(storage: storage)..add(GalleryLoadRequested())),
        BlocProvider(create: (_) => StudioBloc(storage: storage)..add(StudioLoadRequested())),
        BlocProvider(create: (_) => LlmBloc(storage: storage, llm: llm)..add(const LlmLoadRequested())),
        BlocProvider(create: (_) => AutoGenBloc(storage: storage, llm: llm, comfy: comfy)),
        BlocProvider(create: (_) => PromptHistoryBloc(storage: storage)..add(PromptHistoryLoadRequested())),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        locale: locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: AppStrings.localizationsDelegates,
        home: child,
      ),
    ),
  );
}

Future<void> pumpPage(
  WidgetTester tester,
  Widget page, {
  Size size = const Size(1280, 800),
  Locale? locale,
  MockStorage? storage,
  UpdateChecker? updateChecker,
  bool settle = true,
  ComfyService? comfy,
  LlmService? llm,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(testApp(
    child: page,
    storage: storage ?? mockStorage(),
    updateChecker: updateChecker,
    locale: locale,
    comfy: comfy,
    llm: llm,
  ));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class FakeComfyService extends ComfyService {
  @override
  Future<ServerHealth> checkHealth(ComfyServer server) async =>
      ServerHealth(serverId: server.id, healthy: false, error: 'offline', checkedAt: DateTime(2024));
  @override
  Future<ModelCatalog> getModels(ComfyServer server) async => ModelCatalog(
      serverId: server.id, models: const [], loras: const [], controlnets: const [],
      upscaleModels: const [], maxLoras: 5, fetchedAt: DateTime(2024));
  @override
  Future<Map<String, dynamic>?> getLoraMetadata(ComfyServer server, String loraName) async => null;
  @override
  Future<String> submitWorkflow(ComfyServer server, Map<String, dynamic> workflow) async =>
      throw ComfyApiException('offline');
  @override
  Future<ComfyJobResult> pollForResult(ComfyServer server, String promptId, {void Function(PreviewMessage)? onPreview, int? maxAttempts}) async =>
      const ComfyJobResult(success: false, error: 'offline');
  @override
  Future<ComfyJobResult> generateImage(ComfyServer server, {required String prompt, required String model, String negativePrompt = '', List<String> loras = const [], Map<String, double> loraWeights = const {}, Creativity creativity = Creativity.normal, double? cfg, int? steps, bool? hiresFix, int width = 768, int height = 768, int? seed, String? refImageFilename, String? refImageSubfolder, String? refImageType, double denoise = 0.5, String? controlnetModel, String? controlImageFilename, String? controlImageSubfolder, String? controlImageType, double controlnetStrength = 1.0, void Function(PreviewMessage)? onPreview}) async =>
      const ComfyJobResult(success: false, error: 'offline');
  @override
  Future<ComfyJobResult> faceRestore(ComfyServer server, {required String filename, String subfolder = '', String type = 'output', double strength = 0.7, bool useCodeFormer = false, void Function(PreviewMessage)? onPreview}) async =>
      const ComfyJobResult(success: false, error: 'offline');
  @override
  Future<ComfyJobResult> upscale(ComfyServer server, {required String filename, String subfolder = '', String type = 'output', String model = 'm.pth', double scale = 2.0, void Function(PreviewMessage)? onPreview}) async =>
      const ComfyJobResult(success: false, error: 'offline');
  @override
  Future<ComfyJobResult> inpaint(ComfyServer server, {required String imageFilename, String imageSubfolder = '', String imageType = 'input', required String maskFilename, String maskSubfolder = '', String maskType = 'input', required String prompt, String negativePrompt = '', required String model, List<String> loras = const [], Map<String, double> loraWeights = const {}, int? seed, int steps = 20, double cfg = 7.0, double denoise = 0.75, void Function(PreviewMessage)? onPreview}) async =>
      const ComfyJobResult(success: false, error: 'offline');
  @override
  Future<Uint8List> getImage(ComfyServer server, String filename, String subfolder, String type) async =>
      Uint8List(0);
  @override
  Future<({String filename, String subfolder, String type})> uploadImage(ComfyServer server, Uint8List bytes, String filename) async =>
      throw ComfyApiException('offline');
}

class FakeLlmService extends LlmService {
  FakeLlmService() : super(dio: Dio());
  @override
  Future<bool> testConnection(LlmServer server) async => false;
  @override
  Future<List<LlmModel>> getModels(LlmServer server) async => const [];
  @override
  Future<LlmChatResult> chatCompletion({required LlmServer server, required String model, required List<LlmChatMessage> messages, double? temperature, int? maxTokens}) async =>
      const LlmChatResult(success: false, content: '', error: 'offline');
}
