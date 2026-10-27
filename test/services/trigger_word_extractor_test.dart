import 'package:flutter_test/flutter_test.dart';
import 'package:vidlatte/services/trigger_word_extractor.dart';

void main() {
  test('extracts explicit trigger words from metadata', () {
    final words = TriggerWordExtractor.extract({
      'model_name': 'lora.safetensors',
      'activation_text': 'mystyle, best quality',
    }, 'lora.safetensors');
    expect(words, isNotEmpty);
    expect(words.first, isA<TriggerWord>());
  });

  test('falls back to filename tokens when metadata empty', () {
    final words = TriggerWordExtractor.extract({}, 'some_character_v2.safetensors');
    expect(words, isA<List<TriggerWord>>());
  });

  test('dedupes words case-insensitively', () {
    final words = TriggerWordExtractor.extract({
      'tag_frequency': {
        '0_general': {'Cat': 5, 'cat': 3, 'dog': 1},
      },
    }, 'x.safetensors');
    final lower = words.map((w) => w.word.toLowerCase()).toList();
    expect(lower.toSet().length, lower.length);
  });

  test('caption-style tags derive a trigger word', () {
    final words = TriggerWordExtractor.extract({
      'ss_tag_frequency': {
        '0_ds': {
          'photorealistic portrait of a woman': 4,
          'photorealistic landscape scene': 3,
        },
      },
    }, 'x.safetensors');
    expect(words, isA<List<TriggerWord>>());
  });
}
