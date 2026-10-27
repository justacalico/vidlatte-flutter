import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/bloc/autogen/autogen_event.dart';
import 'package:vidlatte/bloc/gallery/gallery_event.dart';
import 'package:vidlatte/bloc/generation/generation_event.dart';
import 'package:vidlatte/bloc/llm/llm_event.dart';
import 'package:vidlatte/bloc/prompt_history/prompt_history_event.dart';
import 'package:vidlatte/bloc/servers/servers_event.dart';
import 'package:vidlatte/bloc/settings/settings_event.dart';
import 'package:vidlatte/bloc/studio/studio_event.dart';
import 'package:vidlatte/data/models/app_settings.dart';
import 'package:vidlatte/data/models/comfy_server.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/generation_job.dart';
import 'package:vidlatte/data/models/llm_server.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/studio_session.dart';

final _d = DateTime(2024);
final aimg = AutoGenImage(id: 'a', prompt: 'p', createdAt: _d);
final img = GeneratedImage(id: 'i', prompt: 'p', model: 'm', createdAt: _d);
final srv = ComfyServer(id: 's', name: 'n', url: 'u', createdAt: _d);
final lm = LoraMetadata(serverId: 's', loraName: 'l', updatedAt: _d);
final sess = StudioSession(id: 's', title: 't', createdAt: _d, updatedAt: _d);
const settings = AppSettings();
final lsrv = LlmServer(id: 'l', name: 'n', url: 'u', createdAt: _d);

void main() {
  test('event equality covers props', () {
    final events = <Object>[
      const AutoGenStarted(),
      const AutoGenStopped(),
      const AutoGenReset(),
      AutoGenConfigChanged(mode: AutoGenMode.auto, topic: 'x', basePrompt: 'x', mustIncludeTags: 'x', maxImages: 1, infiniteImages: true, selectedLoras: const <String>[], imageModel: 'x', width: 1, height: 1),
      const AutoGenImageUpdated('x', ImageStatus.pending),
      const AutoGenPromptGenerated('x'),
      AutoGenImageStarted(aimg),
      const AutoGenErrorOccurred('x'),
      const AutoGenCompleted(),
      GalleryLoadRequested(),
      const GallerySearchChanged('x'),
      GalleryFilterChanged(GalleryFilter.all),
      const GalleryImageFavoriteToggled('x'),
      const GalleryImageDeleted('x'),
      const GalleryImageCollectionChanged('x', 'x'),
      const GalleryCollectionCreated('x'),
      const GalleryCollectionRenamed('x', 'x'),
      const GalleryCollectionDeleted('x'),
      const GalleryCollectionSelected('x'),
      const GalleryImageHiddenToggled('x'),
      const GalleryUnlockAttempted('x'),
      GalleryLockRequested(),
      GallerySelectModeToggled(),
      const GalleryImageSelectionToggled('x'),
      GallerySelectAllToggled(),
      GalleryBulkDeleteRequested(),
      GalleryBulkFavoriteRequested(),
      const GalleryBulkCollectionRequested('x'),
      GenerationSubmitted(server: srv, prompt: 'x', model: 'x'),
      const GenerationCancelled('x'),
      GenerationCleared(),
      const GenerationImageDeleted('x'),
      const GenerationImageFavoriteToggled('x'),
      const GenerationReordered(<GenerationJob>[]),
      const GenerationRetried('x'),
      const GenerationImagesSynced(<GeneratedImage>[]),
      const LlmLoadRequested(),
      const LlmServerAddRequested(name: 'x', url: 'x'),
      LlmServerUpdateRequested(lsrv),
      const LlmServerDeleteRequested('x'),
      const LlmServerToggleRequested('x'),
      const LlmModelsFetchRequested('x'),
      const LlmHealthCheckRequested('x'),
      const LlmModelSelected('x', 'x'),
      PromptHistoryLoadRequested(),
      const PromptHistoryEntryAdded(prompt: 'x'),
      const PromptHistoryEntryDeleted('x'),
      PromptHistoryCleared(),
      ServersLoadRequested(),
      const ServerAddRequested(name: 'x', url: 'x'),
      ServerUpdateRequested(srv),
      const ServerDeleteRequested('x'),
      const ServerSetDefaultRequested('x'),
      const ServerHealthCheckRequested('x'),
      const ServerModelsFetchRequested('x'),
      const LoraMetadataLoadRequested('x'),
      LoraMetadataSaveRequested('x', [lm]),
      const LoraTriggerWordsSaveRequested('x', {'a': 'b'}),
      const LoraVisibilitySaveRequested('x', <String>{}),
      const LoraTriggerWordsFetchRequested('x', <String>[]),
      SettingsLoadRequested(),
      SettingsUpdated(settings),
      const ThemeModeChanged('x'),
      const DefaultServerChanged('x'),
      const LastModelChanged('x'),
      const LastLorasChanged(<String>[]),
      const LastCreativityChanged('x'),
      const LocaleChanged('x'),
      StudioLoadRequested(),
      const StudioSessionCreated('x'),
      StudioSessionUpdated(sess),
      const StudioSessionDeleted('x'),
      const StudioSessionSelected('x'),
      StudioImageAdded('x', img),
      const StudioSessionPromptChanged('x', 'x'),
      const StudioSessionModelChanged('x', 'x'),
      const StudioSessionLorasChanged('x', <String>[]),
      const StudioImageRemoved('x', 'x'),
    ];
    for (final e in events) {
      expect(e, equals(e));
      expect(e.hashCode, equals(e.hashCode));
    }
  });
}
