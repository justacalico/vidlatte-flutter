import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/data/models/generated_image.dart';
import 'package:vidlatte/data/models/lora_metadata.dart';
import 'package:vidlatte/data/models/prompt_history_entry.dart';
import 'package:vidlatte/presentation/widgets/common/image_detail_modal.dart';
import 'package:vidlatte/presentation/widgets/create/auto_image_content.dart';
import 'package:vidlatte/presentation/widgets/create/lora_picker_dialog.dart';
import 'package:vidlatte/presentation/widgets/create/mask_editor.dart';
import 'package:vidlatte/presentation/widgets/create/prompt_history_sheet.dart';
import 'package:vidlatte/presentation/widgets/settings/lora_edit_dialog.dart';

import '../helpers.dart';

final _img = GeneratedImage(id: 'i', prompt: 'a cat', model: 'm', createdAt: DateTime(2024));
final _imgDone = GeneratedImage(id: 'i2', prompt: 'done', model: 'm', status: ImageStatus.completed, localPath: '/tmp/x.png', serverUrl: 'http://s', comfyFilename: 'f.png', createdAt: DateTime(2024));

Future<void> pump(WidgetTester t, Widget w, {bool settle = true}) =>
    pumpPage(t, Scaffold(body: w), size: const Size(1000, 800), settle: settle);

void main() {
  setUpAll(registerFallbacks);

  testWidgets('ImageDetailModal renders and navigates', (t) async {
    await pump(t, ImageDetailModal(images: [_img, _imgDone]));
    expect(find.byType(ImageDetailModal), findsOneWidget);
  });

  testWidgets('AutoImageContent renders', (t) async {
    await pump(t, AutoImageContent(controller: AutoImageController()), settle: false);
    expect(find.byType(AutoImageContent), findsOneWidget);
  });

  testWidgets('LoraPickerDialog renders and filters', (t) async {
    await pump(t, LoraPickerDialog(
      loras: const ['l1', 'l2'], triggerWords: const {'l1': 'w'},
      selectedLoras: const [], maxLoras: 3,
    ));
    expect(find.byType(LoraPickerDialog), findsOneWidget);
  });

  testWidgets('LoraEditDialog renders and saves', (t) async {
    await pump(t, LoraEditDialog(
      serverId: 's', loraName: 'l',
      existing: LoraMetadata(serverId: 's', loraName: 'l', triggerWords: 'w', updatedAt: DateTime(2024)),
    ));
    expect(find.byType(LoraEditDialog), findsOneWidget);
  });

  testWidgets('PromptHistorySheet renders entries', (t) async {
    await pump(t, PromptHistorySheet(), settle: false);
    expect(find.byType(PromptHistorySheet), findsOneWidget);
  });

  testWidgets('MaskEditor renders canvas', (t) async {
    await t.runAsync(() async {
      await pump(t, MaskEditor(
        imageBytes: File('assets/icon-1024.png').readAsBytesSync(),
        exportKey: GlobalKey<MaskEditorState>(),
      ), settle: false);
      await Future.delayed(const Duration(milliseconds: 500));
    });
    await t.pump();
    expect(find.byType(MaskEditor), findsOneWidget);
  });
}
