import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vidlatte/bloc/autogen/autogen_bloc.dart';
import 'package:vidlatte/bloc/autogen/autogen_event.dart';
import 'package:vidlatte/bloc/autogen/autogen_state.dart';
import 'package:vidlatte/bloc/gallery/gallery_bloc.dart';
import 'package:vidlatte/bloc/gallery/gallery_event.dart';
import 'package:vidlatte/bloc/gallery/gallery_state.dart';
import 'package:vidlatte/bloc/generation/generation_bloc.dart';
import 'package:vidlatte/bloc/generation/generation_event.dart';
import 'package:vidlatte/bloc/llm/llm_bloc.dart';
import 'package:vidlatte/bloc/llm/llm_event.dart';
import 'package:vidlatte/bloc/llm/llm_state.dart';
import 'package:vidlatte/bloc/servers/servers_bloc.dart';
import 'package:vidlatte/bloc/servers/servers_event.dart';
import 'package:vidlatte/bloc/studio/studio_bloc.dart';
import 'package:vidlatte/bloc/studio/studio_event.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/collection.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/generation_job.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/model_catalog.dart';
import 'package:vidlatte/data/models/studio_session.dart';
import 'package:vidlatte/services/comfyui_service.dart';
import 'package:vidlatte/services/llm_service.dart';

import '../helpers.dart';

class MockComfy extends Mock implements ComfyService {}
class MockLlm extends Mock implements LlmService {}

final _d = DateTime(2024);
final _img = GeneratedImage(id: 'i1', prompt: 'cat', model: 'm', status: ImageStatus.completed, createdAt: _d);
final _img2 = GeneratedImage(id: 'i2', prompt: 'dog', model: 'm', isHidden: true, isFavorite: true, collectionId: 'c1', createdAt: _d);
final _srv = ComfyServer(id: 's1', name: 'srv', url: 'http://x', createdAt: _d);
final _job = GenerationJob(id: 'j1', prompt: 'p', model: 'm', serverId: 's1', createdAt: _d);
final _sess = StudioSession(id: 'ss1', title: 'T', images: [_img], createdAt: _d, updatedAt: _d);
final _lsrv = LlmServer(id: 'l1', name: 'L', url: 'u', createdAt: _d);

Future<void> settle() => Future.delayed(const Duration(milliseconds: 30));

void main() {
  setUpAll(() {
    registerFallbacks();
    registerFallbackValue(_job);
  });

  MockStorage listStorage() {
    final s = mockStorage();
    when(() => s.getImages()).thenReturn([_img, _img2]);
    when(() => s.getServers()).thenReturn([_srv]);
    when(() => s.getDefaultServer()).thenReturn(_srv);
    when(() => s.getSessions()).thenReturn([_sess]);
    when(() => s.getLlmServers()).thenReturn([_lsrv]);
    when(() => s.getCollections()).thenReturn([
      Collection(id: 'c1', name: 'C', createdAt: _d, updatedAt: _d),
    ]);
    return s;
  }

  test('gallery bloc full sweep', () async {
    final s = mockStorage(settings: const AppSettings(galleryPassword: 'pw'));
    final images = <GeneratedImage>[_img, _img2];
    when(() => s.getImages()).thenAnswer((_) => List.of(images));
    when(() => s.getCollections()).thenReturn([Collection(id: 'c1', name: 'C', createdAt: _d, updatedAt: _d)]);
    final b = GalleryBloc(storage: s);
    b.add(GalleryLoadRequested());
    b.add(const GallerySearchChanged('cat'));
    b.add(const GalleryFilterChanged(GalleryFilter.favorites));
    b.add(const GalleryFilterChanged(GalleryFilter.hidden));
    b.add(const GalleryFilterChanged(GalleryFilter.all));
    b.add(const GalleryCollectionSelected('c1'));
    b.add(const GalleryUnlockAttempted('bad'));
    b.add(const GalleryUnlockAttempted('pw'));
    b.add(GalleryLockRequested());
    b.add(GallerySelectModeToggled());
    b.add(const GalleryImageSelectionToggled('i1'));
    b.add(const GalleryImageSelectionToggled('i1'));
    b.add(GallerySelectAllToggled());
    b.add(GallerySelectAllToggled());
    b.add(const GalleryImageFavoriteToggled('i1'));
    b.add(const GalleryImageDeleted('i2'));
    b.add(const GalleryImageHiddenToggled('i1'));
    b.add(const GalleryImageCollectionChanged('i1', 'c1'));
    b.add(const GalleryCollectionCreated('New'));
    b.add(const GalleryCollectionRenamed('c1', 'Renamed'));
    b.add(const GalleryCollectionDeleted('c1'));
    b.add(GalleryBulkDeleteRequested());
    b.add(GalleryBulkFavoriteRequested());
    b.add(const GalleryBulkCollectionRequested('c1'));
    await settle();
    expect(b.state, isA<GalleryState>());
    await b.close();
  });

  test('generation bloc sweep', () async {
    final s = listStorage();
    final comfy = MockComfy();
    when(() => comfy.submitWorkflow(any(), any())).thenAnswer((_) async => 'pid');
    final b = GenerationBloc(storage: s, comfy: comfy);
    b.add(GenerationCancelled('j1'));
    b.add(GenerationCleared());
    b.add(GenerationReordered([_job]));
    b.add(GenerationRetried('j1'));
    b.add(const GenerationImageDeleted('i1'));
    b.add(const GenerationImageFavoriteToggled('i1'));
    b.add(GenerationImagesSynced([_img]));
    await settle();
    await b.close();
  });

  test('autogen bloc sweep', () async {
    final s = listStorage();
    final b = AutoGenBloc(storage: s, llm: MockLlm(), comfy: MockComfy());
    b.add(AutoGenConfigChanged(
      mode: AutoGenMode.auto, topic: 't', basePrompt: 'b', mustIncludeTags: 'x',
      maxImages: 5, infiniteImages: false, selectedLoras: const ['l'],
      imageModel: 'm', width: 512, height: 512,
    ));
    b.add(const AutoGenPromptGenerated('new prompt'));
    b.add(AutoGenImageStarted(AutoGenImage(id: 'a', prompt: 'p', createdAt: _d)));
    b.add(const AutoGenImageUpdated('a', ImageStatus.completed, localPath: '/p'));
    b.add(const AutoGenErrorOccurred('err'));
    b.add(const AutoGenCompleted());
    b.add(const AutoGenStopped());
    b.add(const AutoGenReset());
    await settle();
    expect(b.state.mode, AutoGenMode.auto);
    await b.close();
  });

  test('llm bloc sweep', () async {
    final s = listStorage();
    final llm = MockLlm();
    when(() => llm.testConnection(any())).thenAnswer((_) async => true);
    when(() => llm.getModels(any())).thenAnswer((_) async => []);
    final b = LlmBloc(storage: s, llm: llm);
    b.add(const LlmLoadRequested());
    b.add(const LlmServerAddRequested(name: 'n', url: 'u'));
    b.add(LlmServerUpdateRequested(_lsrv));
    b.add(const LlmServerToggleRequested('l1'));
    b.add(const LlmModelsFetchRequested('l1'));
    b.add(const LlmHealthCheckRequested('l1'));
    b.add(const LlmModelSelected('l1', 'model'));
    b.add(const LlmServerDeleteRequested('l1'));
    await settle();
    await b.close();
  });

  test('servers bloc sweep', () async {
    final s = listStorage();
    final comfy = MockComfy();
    when(() => comfy.checkHealth(any())).thenAnswer((_) async => ServerHealth(serverId: 's1', healthy: true, checkedAt: _d));
    when(() => comfy.getModels(any())).thenAnswer((_) async => ModelCatalog(serverId: 's1', models: ['m'], loras: ['l'], controlnets: [], upscaleModels: [], maxLoras: 5, fetchedAt: _d));
    when(() => comfy.getLoraMetadata(any(), any())).thenAnswer((_) async => {'a': 1});
    final b = ServersBloc(storage: s, comfy: comfy);
    b.add(ServersLoadRequested());
    b.add(const ServerAddRequested(name: 'n', url: 'u'));
    b.add(ServerUpdateRequested(_srv));
    b.add(const ServerSetDefaultRequested('s1'));
    b.add(const ServerHealthCheckRequested('s1'));
    b.add(const ServerModelsFetchRequested('s1'));
    b.add(const LoraMetadataLoadRequested('s1'));
    b.add(LoraMetadataSaveRequested('s1', [LoraMetadata(serverId: 's1', loraName: 'l', updatedAt: _d)]));
    b.add(const LoraTriggerWordsSaveRequested('s1', {'l': 'w'}));
    b.add(const LoraVisibilitySaveRequested('s1', {'l'}));
    b.add(const LoraTriggerWordsFetchRequested('s1', ['l']));
    b.add(const ServerDeleteRequested('s1'));
    await settle();
    await b.close();
  });

  test('studio bloc sweep', () async {
    final s = listStorage();
    final sessions = <StudioSession>[_sess];
    when(() => s.getSessions()).thenAnswer((_) => List.of(sessions));
    when(() => s.saveSession(any())).thenAnswer((i) async {
      final sess = i.positionalArguments[0] as StudioSession;
      sessions.removeWhere((x) => x.id == sess.id);
      sessions.add(sess);
    });
    final b = StudioBloc(storage: s);
    b.add(StudioLoadRequested());
    b.add(const StudioSessionSelected('ss1'));
    b.add(const StudioSessionCreated('New'));
    b.add(StudioSessionUpdated(_sess));
    b.add(StudioImageAdded('ss1', _img));
    b.add(const StudioSessionPromptChanged('ss1', 'p'));
    b.add(const StudioSessionModelChanged('ss1', 'm'));
    b.add(const StudioSessionLorasChanged('ss1', ['l']));
    b.add(const StudioImageRemoved('ss1', 'i1'));
    b.add(const StudioSessionDeleted('ss1'));
    await settle();
    await b.close();
  });
}
