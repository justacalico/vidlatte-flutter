import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_strings_en.dart';
import 'app_strings_ga.dart';
import 'app_strings_ru.dart';
import 'app_strings_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppStrings
/// returned by `AppStrings.of(context)`.
///
/// Applications need to include `AppStrings.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_strings.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppStrings.localizationsDelegates,
///   supportedLocales: AppStrings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppStrings.supportedLocales
/// property.
abstract class AppStrings {
  AppStrings(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'GB'),
    Locale('ga'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Vidlatte'**
  String get appName;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @studio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get studio;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @required_.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required_;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @new_.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @default_.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @unhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get unhealthy;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @models.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get models;

  /// No description provided for @os.
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get os;

  /// No description provided for @python.
  ///
  /// In en, this message translates to:
  /// **'Python'**
  String get python;

  /// No description provided for @ram.
  ///
  /// In en, this message translates to:
  /// **'RAM'**
  String get ram;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @fetchModels.
  ///
  /// In en, this message translates to:
  /// **'Fetch Models'**
  String get fetchModels;

  /// No description provided for @setDefault.
  ///
  /// In en, this message translates to:
  /// **'Set Default'**
  String get setDefault;

  /// No description provided for @healthCheck.
  ///
  /// In en, this message translates to:
  /// **'Health Check'**
  String get healthCheck;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalidUrl;

  /// No description provided for @authType.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authType;

  /// No description provided for @authNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get authNone;

  /// No description provided for @authBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic Auth'**
  String get authBasic;

  /// No description provided for @authBearer.
  ///
  /// In en, this message translates to:
  /// **'Bearer Token'**
  String get authBearer;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authToken.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get authToken;

  /// No description provided for @negativePrompt.
  ///
  /// In en, this message translates to:
  /// **'Negative Prompt'**
  String get negativePrompt;

  /// No description provided for @negativePromptHint.
  ///
  /// In en, this message translates to:
  /// **'What to avoid in the image'**
  String get negativePromptHint;

  /// No description provided for @loraWeight.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get loraWeight;

  /// No description provided for @img2img.
  ///
  /// In en, this message translates to:
  /// **'Image to Image'**
  String get img2img;

  /// No description provided for @txt2img.
  ///
  /// In en, this message translates to:
  /// **'Text to Image'**
  String get txt2img;

  /// No description provided for @selectRefImage.
  ///
  /// In en, this message translates to:
  /// **'Select Reference Image'**
  String get selectRefImage;

  /// No description provided for @refImageHint.
  ///
  /// In en, this message translates to:
  /// **'Upload or pick an image to transform'**
  String get refImageHint;

  /// No description provided for @denoiseStrength.
  ///
  /// In en, this message translates to:
  /// **'Denoise Strength'**
  String get denoiseStrength;

  /// No description provided for @denoiseHint.
  ///
  /// In en, this message translates to:
  /// **'Higher = more change, lower = more similar to original'**
  String get denoiseHint;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get pickFromGallery;

  /// No description provided for @noRefImage.
  ///
  /// In en, this message translates to:
  /// **'No reference image selected'**
  String get noRefImage;

  /// No description provided for @removeRefImage.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeRefImage;

  /// No description provided for @faceRestore.
  ///
  /// In en, this message translates to:
  /// **'Face Restore'**
  String get faceRestore;

  /// No description provided for @faceRestoreStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get faceRestoreStrength;

  /// No description provided for @useCodeFormer.
  ///
  /// In en, this message translates to:
  /// **'Use CodeFormer'**
  String get useCodeFormer;

  /// No description provided for @upscaleImage.
  ///
  /// In en, this message translates to:
  /// **'Upscale'**
  String get upscaleImage;

  /// No description provided for @upscaleModel.
  ///
  /// In en, this message translates to:
  /// **'Upscale Model'**
  String get upscaleModel;

  /// No description provided for @upscaleScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get upscaleScale;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @processingMsg.
  ///
  /// In en, this message translates to:
  /// **'This may take a moment'**
  String get processingMsg;

  /// No description provided for @faceRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Face restoration complete'**
  String get faceRestoreDone;

  /// No description provided for @faceRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Face restoration failed'**
  String get faceRestoreFailed;

  /// No description provided for @upscaleDone.
  ///
  /// In en, this message translates to:
  /// **'Upscaling complete'**
  String get upscaleDone;

  /// No description provided for @upscaleFailed.
  ///
  /// In en, this message translates to:
  /// **'Upscaling failed'**
  String get upscaleFailed;

  /// No description provided for @noUpscaleModels.
  ///
  /// In en, this message translates to:
  /// **'No upscale models found on server'**
  String get noUpscaleModels;

  /// No description provided for @inpaint.
  ///
  /// In en, this message translates to:
  /// **'Inpaint'**
  String get inpaint;

  /// No description provided for @inpaintHint.
  ///
  /// In en, this message translates to:
  /// **'Paint over areas to regenerate'**
  String get inpaintHint;

  /// No description provided for @brushSize.
  ///
  /// In en, this message translates to:
  /// **'Brush Size'**
  String get brushSize;

  /// No description provided for @clearMask.
  ///
  /// In en, this message translates to:
  /// **'Clear Mask'**
  String get clearMask;

  /// No description provided for @maskEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get maskEraser;

  /// No description provided for @inpaintDenoise.
  ///
  /// In en, this message translates to:
  /// **'Inpaint Strength'**
  String get inpaintDenoise;

  /// No description provided for @inpaintDenoiseHint.
  ///
  /// In en, this message translates to:
  /// **'How much to change the masked area'**
  String get inpaintDenoiseHint;

  /// No description provided for @noInpaintImage.
  ///
  /// In en, this message translates to:
  /// **'Select an image to start inpainting'**
  String get noInpaintImage;

  /// No description provided for @selectInpaintImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectInpaintImage;

  /// No description provided for @controlnet.
  ///
  /// In en, this message translates to:
  /// **'ControlNet'**
  String get controlnet;

  /// No description provided for @controlnetHint.
  ///
  /// In en, this message translates to:
  /// **'Guide generation with a reference image'**
  String get controlnetHint;

  /// No description provided for @controlnetModel.
  ///
  /// In en, this message translates to:
  /// **'ControlNet Model'**
  String get controlnetModel;

  /// No description provided for @controlnetStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get controlnetStrength;

  /// No description provided for @controlImage.
  ///
  /// In en, this message translates to:
  /// **'Control Image'**
  String get controlImage;

  /// No description provided for @noControlnetModels.
  ///
  /// In en, this message translates to:
  /// **'No ControlNet models found on server'**
  String get noControlnetModels;

  /// No description provided for @selectControlImage.
  ///
  /// In en, this message translates to:
  /// **'Select Control Image'**
  String get selectControlImage;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createTitle;

  /// No description provided for @autoImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Image'**
  String get autoImageTitle;

  /// No description provided for @browseModelsLoras.
  ///
  /// In en, this message translates to:
  /// **'Browse Models & LoRAs'**
  String get browseModelsLoras;

  /// No description provided for @autoImageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Auto Image'**
  String get autoImageTooltip;

  /// No description provided for @backToCreate.
  ///
  /// In en, this message translates to:
  /// **'Back to Create'**
  String get backToCreate;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @addToQueue.
  ///
  /// In en, this message translates to:
  /// **'Add to Queue'**
  String get addToQueue;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @noImagesYet.
  ///
  /// In en, this message translates to:
  /// **'No Images Yet'**
  String get noImagesYet;

  /// No description provided for @noImagesYetMsg.
  ///
  /// In en, this message translates to:
  /// **'Write a prompt and hit Generate to create your first image.'**
  String get noImagesYetMsg;

  /// No description provided for @noComfyServer.
  ///
  /// In en, this message translates to:
  /// **'No ComfyUI Server'**
  String get noComfyServer;

  /// No description provided for @noComfyServerMsg.
  ///
  /// In en, this message translates to:
  /// **'Add a ComfyUI server in Settings to start generating images.'**
  String get noComfyServerMsg;

  /// No description provided for @enterPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter a prompt first.'**
  String get enterPrompt;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select a model first.'**
  String get selectModel;

  /// No description provided for @modelNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'\"{model}\" is not available on {server}. Select a model from the list.'**
  String modelNotAvailable(Object model, Object server);

  /// No description provided for @modelNotAvailableRaw.
  ///
  /// In en, this message translates to:
  /// **'\"{model}\" is not available on {server}. Select a model from the list.'**
  String modelNotAvailableRaw(String model, String server);

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @describeImage.
  ///
  /// In en, this message translates to:
  /// **'Describe the image you want to generate...'**
  String get describeImage;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @selectServer.
  ///
  /// In en, this message translates to:
  /// **'Select server'**
  String get selectServer;

  /// No description provided for @selectModelHint.
  ///
  /// In en, this message translates to:
  /// **'Select a model'**
  String get selectModelHint;

  /// No description provided for @loadingModels.
  ///
  /// In en, this message translates to:
  /// **'Loading models...'**
  String get loadingModels;

  /// No description provided for @loras.
  ///
  /// In en, this message translates to:
  /// **'LoRAs'**
  String get loras;

  /// No description provided for @noLorasSelected.
  ///
  /// In en, this message translates to:
  /// **'No LoRAs selected'**
  String get noLorasSelected;

  /// No description provided for @creativityCfg.
  ///
  /// In en, this message translates to:
  /// **'Creativity (CFG)'**
  String get creativityCfg;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @customCfg.
  ///
  /// In en, this message translates to:
  /// **'Custom CFG'**
  String get customCfg;

  /// No description provided for @customCfgSubtitleOn.
  ///
  /// In en, this message translates to:
  /// **'Override creativity slider with a custom value'**
  String get customCfgSubtitleOn;

  /// No description provided for @customCfgSubtitleOff.
  ///
  /// In en, this message translates to:
  /// **'Use creativity slider value'**
  String get customCfgSubtitleOff;

  /// No description provided for @cfgScale.
  ///
  /// In en, this message translates to:
  /// **'CFG Scale'**
  String get cfgScale;

  /// No description provided for @hiresFix.
  ///
  /// In en, this message translates to:
  /// **'Hires Fix'**
  String get hiresFix;

  /// No description provided for @hiresFixSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upscale by 1.5x after generation'**
  String get hiresFixSubtitle;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @stepsWithDefault.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsWithDefault;

  /// No description provided for @autoImageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered automated image generation'**
  String get autoImageSubtitle;

  /// No description provided for @generationMode.
  ///
  /// In en, this message translates to:
  /// **'Generation Mode'**
  String get generationMode;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @variation.
  ///
  /// In en, this message translates to:
  /// **'Variation'**
  String get variation;

  /// No description provided for @topicOptional.
  ///
  /// In en, this message translates to:
  /// **'Topic / Idea (optional)'**
  String get topicOptional;

  /// No description provided for @topicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., cyberpunk city, fantasy portrait...'**
  String get topicHint;

  /// No description provided for @leaveEmptyRandom.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for completely random prompts'**
  String get leaveEmptyRandom;

  /// No description provided for @basePrompt.
  ///
  /// In en, this message translates to:
  /// **'Base Prompt'**
  String get basePrompt;

  /// No description provided for @basePromptHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your prompt here. The AI will create variations...'**
  String get basePromptHint;

  /// No description provided for @variationDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI will vary style, lighting, and details while preserving your core content'**
  String get variationDesc;

  /// No description provided for @mustIncludeTags.
  ///
  /// In en, this message translates to:
  /// **'Must Include Tags'**
  String get mustIncludeTags;

  /// No description provided for @mustIncludeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., red hair, specific pose...'**
  String get mustIncludeHint;

  /// No description provided for @maxImages.
  ///
  /// In en, this message translates to:
  /// **'Max Images'**
  String get maxImages;

  /// No description provided for @infiniteImages.
  ///
  /// In en, this message translates to:
  /// **'Generate infinite images'**
  String get infiniteImages;

  /// No description provided for @llmServer.
  ///
  /// In en, this message translates to:
  /// **'LLM Server'**
  String get llmServer;

  /// No description provided for @llmModel.
  ///
  /// In en, this message translates to:
  /// **'LLM Model'**
  String get llmModel;

  /// No description provided for @imageServer.
  ///
  /// In en, this message translates to:
  /// **'Image Server'**
  String get imageServer;

  /// No description provided for @imageModel.
  ///
  /// In en, this message translates to:
  /// **'Image Model'**
  String get imageModel;

  /// No description provided for @noLlmServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No LLM servers configured. Add one in Settings.'**
  String get noLlmServersConfigured;

  /// No description provided for @noComfyServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No ComfyUI servers configured. Add one in Settings.'**
  String get noComfyServersConfigured;

  /// No description provided for @startGeneration.
  ///
  /// In en, this message translates to:
  /// **'Start Generation'**
  String get startGeneration;

  /// No description provided for @autoImageEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Configure settings and press Start to begin automated generation.'**
  String get autoImageEmptyMsg;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @generatingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Generating prompt...'**
  String get generatingPrompt;

  /// No description provided for @generatingImage.
  ///
  /// In en, this message translates to:
  /// **'Generating image...'**
  String get generatingImage;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @currentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Current Prompt'**
  String get currentPrompt;

  /// No description provided for @modelNotOnServer.
  ///
  /// In en, this message translates to:
  /// **'\"{model}\" is not available on the selected server.'**
  String modelNotOnServer(Object model);

  /// No description provided for @modelNotOnServerRaw.
  ///
  /// In en, this message translates to:
  /// **'\"{model}\" is not available on the selected server.'**
  String modelNotOnServerRaw(String model);

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryTitle;

  /// No description provided for @galleryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Gallery is Empty'**
  String get galleryEmpty;

  /// No description provided for @galleryEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Generated images will appear here automatically.'**
  String get galleryEmptyMsg;

  /// No description provided for @searchPromptModelLora.
  ///
  /// In en, this message translates to:
  /// **'Search by prompt, model, or LoRA...'**
  String get searchPromptModelLora;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get noResults;

  /// No description provided for @noResultsMsg.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get noResultsMsg;

  /// No description provided for @noHiddenImages.
  ///
  /// In en, this message translates to:
  /// **'No Hidden Images'**
  String get noHiddenImages;

  /// No description provided for @noHiddenImagesMsg.
  ///
  /// In en, this message translates to:
  /// **'Hide images from the card menu to see them here.'**
  String get noHiddenImagesMsg;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No Playlists'**
  String get noPlaylists;

  /// No description provided for @noPlaylistsMsg.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist to organize your images.'**
  String get noPlaylistsMsg;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New Playlist'**
  String get newPlaylist;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistName;

  /// No description provided for @playlistNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Portraits, Landscapes...'**
  String get playlistNameHint;

  /// No description provided for @renamePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get renamePlaylist;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @deletePlaylistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Images will remain in your gallery.'**
  String deletePlaylistConfirm(Object name);

  /// No description provided for @deletePlaylistConfirmRaw.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Images will remain in your gallery.'**
  String deletePlaylistConfirmRaw(String name);

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @deleteImageMsg.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the image from your device.'**
  String get deleteImageMsg;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @galleryLocked.
  ///
  /// In en, this message translates to:
  /// **'Gallery Locked'**
  String get galleryLocked;

  /// No description provided for @galleryLockedMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to view hidden images.'**
  String get galleryLockedMsg;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @noHiddenImagesPlural.
  ///
  /// In en, this message translates to:
  /// **'No Hidden Images'**
  String get noHiddenImagesPlural;

  /// No description provided for @hiddenImagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hidden image{count, plural, =1{} other{s}}'**
  String hiddenImagesCount(int count);

  /// No description provided for @imagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} image{count, plural, =1{} other{s}}'**
  String imagesCount(int count);

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @noPlaylistsYet.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet. Tap \"New playlist\" below to create one.'**
  String get noPlaylistsYet;

  /// No description provided for @noPlaylistsYetNew.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet. Tap \"New\" to create one.'**
  String get noPlaylistsYetNew;

  /// No description provided for @backToPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Back to playlists'**
  String get backToPlaylists;

  /// No description provided for @deletePlaylistTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get deletePlaylistTooltip;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectMode;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @bulkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get bulkDelete;

  /// No description provided for @bulkFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite Selected'**
  String get bulkFavorite;

  /// No description provided for @bulkMoveToCollection.
  ///
  /// In en, this message translates to:
  /// **'Move to Collection'**
  String get bulkMoveToCollection;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selectedCount;

  /// No description provided for @confirmBulkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} images?'**
  String confirmBulkDelete(int count);

  /// No description provided for @studioTitle.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get studioTitle;

  /// No description provided for @noStudioSessions.
  ///
  /// In en, this message translates to:
  /// **'No Studio Sessions'**
  String get noStudioSessions;

  /// No description provided for @noStudioSessionsMsg.
  ///
  /// In en, this message translates to:
  /// **'Create a session to organize your generations by project.'**
  String get noStudioSessionsMsg;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @sessionName.
  ///
  /// In en, this message translates to:
  /// **'Session name'**
  String get sessionName;

  /// No description provided for @selectSession.
  ///
  /// In en, this message translates to:
  /// **'Select a Session'**
  String get selectSession;

  /// No description provided for @selectSessionMsg.
  ///
  /// In en, this message translates to:
  /// **'Choose a session from the list to view its images.'**
  String get selectSessionMsg;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This will remove the session and its images.'**
  String get deleteSessionMsg;

  /// No description provided for @sessionImages.
  ///
  /// In en, this message translates to:
  /// **'Session Images'**
  String get sessionImages;

  /// No description provided for @imagesLabel.
  ///
  /// In en, this message translates to:
  /// **'images'**
  String get imagesLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how Vidlatte looks.'**
  String get appearanceSubtitle;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @oled.
  ///
  /// In en, this message translates to:
  /// **'OLED'**
  String get oled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language.'**
  String get languageSubtitle;

  /// No description provided for @comfyuiServers.
  ///
  /// In en, this message translates to:
  /// **'ComfyUI Servers'**
  String get comfyuiServers;

  /// No description provided for @noServers.
  ///
  /// In en, this message translates to:
  /// **'No Servers'**
  String get noServers;

  /// No description provided for @noServersMsg.
  ///
  /// In en, this message translates to:
  /// **'Add a ComfyUI server to start generating images.'**
  String get noServersMsg;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get addServer;

  /// No description provided for @editServer.
  ///
  /// In en, this message translates to:
  /// **'Edit Server'**
  String get editServer;

  /// No description provided for @llmServers.
  ///
  /// In en, this message translates to:
  /// **'LLM Servers'**
  String get llmServers;

  /// No description provided for @llmServersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to LM Studio or any OpenAI-compatible server for prompt generation.'**
  String get llmServersSubtitle;

  /// No description provided for @noLlmServers.
  ///
  /// In en, this message translates to:
  /// **'No LLM Servers'**
  String get noLlmServers;

  /// No description provided for @noLlmServersMsg.
  ///
  /// In en, this message translates to:
  /// **'Add an LLM server to enable Auto Image generation.'**
  String get noLlmServersMsg;

  /// No description provided for @addLlmServer.
  ///
  /// In en, this message translates to:
  /// **'Add LLM Server'**
  String get addLlmServer;

  /// No description provided for @editLlmServer.
  ///
  /// In en, this message translates to:
  /// **'Edit LLM Server'**
  String get editLlmServer;

  /// No description provided for @apiKeyOptional.
  ///
  /// In en, this message translates to:
  /// **'API Key (optional)'**
  String get apiKeyOptional;

  /// No description provided for @apiKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for local servers'**
  String get apiKeyHint;

  /// No description provided for @defaultModelOptional.
  ///
  /// In en, this message translates to:
  /// **'Default Model (optional)'**
  String get defaultModelOptional;

  /// No description provided for @defaultModelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., llama-3-8b-instruct'**
  String get defaultModelHint;

  /// No description provided for @deleteServer.
  ///
  /// In en, this message translates to:
  /// **'Delete Server'**
  String get deleteServer;

  /// No description provided for @deleteServerMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this server?'**
  String get deleteServerMsg;

  /// No description provided for @deleteLlmServer.
  ///
  /// In en, this message translates to:
  /// **'Delete LLM Server'**
  String get deleteLlmServer;

  /// No description provided for @deleteLlmServerMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this server?'**
  String get deleteLlmServerMsg;

  /// No description provided for @galleryPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Gallery Privacy'**
  String get galleryPrivacy;

  /// No description provided for @galleryPrivacyEnabled.
  ///
  /// In en, this message translates to:
  /// **'Password protection enabled'**
  String get galleryPrivacyEnabled;

  /// No description provided for @galleryPrivacyDisabled.
  ///
  /// In en, this message translates to:
  /// **'Set a password to hide images'**
  String get galleryPrivacyDisabled;

  /// No description provided for @galleryProtectedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your gallery is protected. Hidden images require a password to view.'**
  String get galleryProtectedMsg;

  /// No description provided for @galleryNoPasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Set a password to lock hidden images. Without a password, hidden images are still visible.'**
  String get galleryNoPasswordMsg;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @setPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordSet.
  ///
  /// In en, this message translates to:
  /// **'Password set'**
  String get passwordSet;

  /// No description provided for @removePassword.
  ///
  /// In en, this message translates to:
  /// **'Remove Password'**
  String get removePassword;

  /// No description provided for @removePasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password to remove password protection.'**
  String get removePasswordMsg;

  /// No description provided for @incorrectPasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPasswordMsg;

  /// No description provided for @browseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browseTitle;

  /// No description provided for @modelsTab.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get modelsTab;

  /// No description provided for @lorasTab.
  ///
  /// In en, this message translates to:
  /// **'LoRAs'**
  String get lorasTab;

  /// No description provided for @noServerConnected.
  ///
  /// In en, this message translates to:
  /// **'No Server Connected'**
  String get noServerConnected;

  /// No description provided for @noServerConnectedMsg.
  ///
  /// In en, this message translates to:
  /// **'Add a ComfyUI server in Settings to browse available models.'**
  String get noServerConnectedMsg;

  /// No description provided for @noModelsFound.
  ///
  /// In en, this message translates to:
  /// **'No Models Found'**
  String get noModelsFound;

  /// No description provided for @noModelsFoundMsg.
  ///
  /// In en, this message translates to:
  /// **'Make sure your ComfyUI server has checkpoints loaded.'**
  String get noModelsFoundMsg;

  /// No description provided for @noLorasFound.
  ///
  /// In en, this message translates to:
  /// **'No LoRAs Found'**
  String get noLorasFound;

  /// No description provided for @noLorasFoundMsg.
  ///
  /// In en, this message translates to:
  /// **'Make sure your ComfyUI server has LoRA models loaded.'**
  String get noLorasFoundMsg;

  /// No description provided for @fetchAllTriggerWords.
  ///
  /// In en, this message translates to:
  /// **'Fetch All Trigger Words'**
  String get fetchAllTriggerWords;

  /// No description provided for @fetchingTriggerWords.
  ///
  /// In en, this message translates to:
  /// **'Fetching trigger words for {count} LoRAs...'**
  String fetchingTriggerWords(int count);

  /// No description provided for @fetchingTriggerWordsFor.
  ///
  /// In en, this message translates to:
  /// **'Fetching trigger words for {name}...'**
  String fetchingTriggerWordsFor(String name);

  /// No description provided for @fetchTriggerWords.
  ///
  /// In en, this message translates to:
  /// **'Fetch trigger words'**
  String get fetchTriggerWords;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @editLora.
  ///
  /// In en, this message translates to:
  /// **'Edit LoRA'**
  String get editLora;

  /// No description provided for @copyName.
  ///
  /// In en, this message translates to:
  /// **'Copy name'**
  String get copyName;

  /// No description provided for @copiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Copied: {label}'**
  String copiedLabel(String label);

  /// No description provided for @fromServer.
  ///
  /// In en, this message translates to:
  /// **'From: {serverName}'**
  String fromServer(String serverName);

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @selectLoras.
  ///
  /// In en, this message translates to:
  /// **'Select LoRAs'**
  String get selectLoras;

  /// No description provided for @searchByNameOrTriggers.
  ///
  /// In en, this message translates to:
  /// **'Search by name or trigger words...'**
  String get searchByNameOrTriggers;

  /// No description provided for @noLorasAvailable.
  ///
  /// In en, this message translates to:
  /// **'No LoRAs available'**
  String get noLorasAvailable;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @maxLorasSelected.
  ///
  /// In en, this message translates to:
  /// **'Max {max} LoRAs selected'**
  String maxLorasSelected(int max);

  /// No description provided for @triggerWords.
  ///
  /// In en, this message translates to:
  /// **'Trigger words'**
  String get triggerWords;

  /// No description provided for @triggerWordsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated, e.g. cat girl, anime style'**
  String get triggerWordsHint;

  /// No description provided for @savedLoraName.
  ///
  /// In en, this message translates to:
  /// **'Saved: {name}'**
  String savedLoraName(String name);

  /// No description provided for @cancelTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelTooltip;

  /// No description provided for @retryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryTooltip;

  /// No description provided for @generationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get generationFailed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusLabel(String status);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No connection. Please check your network and try again.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get notFound;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get timeoutError;

  /// No description provided for @comfyConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to ComfyUI server. Check the URL and make sure it is running.'**
  String get comfyConnectionError;

  /// No description provided for @comfyNoServerError.
  ///
  /// In en, this message translates to:
  /// **'No ComfyUI server configured. Add one in Settings.'**
  String get comfyNoServerError;

  /// No description provided for @lorasCount.
  ///
  /// In en, this message translates to:
  /// **'LoRAs'**
  String get lorasCount;

  /// No description provided for @imageMeta.
  ///
  /// In en, this message translates to:
  /// **'{model} · {width}x{height} · seed: {seed}'**
  String imageMeta(String model, int width, int height, int seed);

  /// No description provided for @promptHistory.
  ///
  /// In en, this message translates to:
  /// **'Prompt History'**
  String get promptHistory;

  /// No description provided for @noPromptHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get noPromptHistory;

  /// No description provided for @noPromptHistoryMsg.
  ///
  /// In en, this message translates to:
  /// **'Your generated prompts will appear here'**
  String get noPromptHistoryMsg;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearHistory;

  /// No description provided for @searchPrompts.
  ///
  /// In en, this message translates to:
  /// **'Search prompts...'**
  String get searchPrompts;

  /// No description provided for @promptHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Prompt History'**
  String get promptHistoryTooltip;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checkingForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// No description provided for @appUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Vidlatte is up to date'**
  String get appUpToDate;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String newVersionAvailable(String version);

  /// No description provided for @openRelease.
  ///
  /// In en, this message translates to:
  /// **'View release'**
  String get openRelease;

  /// No description provided for @allReleases.
  ///
  /// In en, this message translates to:
  /// **'All releases'**
  String get allReleases;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check for updates'**
  String get updateCheckFailed;

  /// No description provided for @currentVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String currentVersionLabel(String version);
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  Future<AppStrings> load(Locale locale) {
    return SynchronousFuture<AppStrings>(lookupAppStrings(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ga', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

AppStrings lookupAppStrings(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppStringsEnGb();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppStringsEn();
    case 'ga':
      return AppStringsGa();
    case 'ru':
      return AppStringsRu();
    case 'zh':
      return AppStringsZh();
  }

  throw FlutterError(
    'AppStrings.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
