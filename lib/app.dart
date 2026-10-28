import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/autogen/autogen_bloc.dart';
import 'bloc/gallery/gallery_bloc.dart';
import 'bloc/generation/generation_bloc.dart';
import 'bloc/llm/llm_bloc.dart';
import 'bloc/prompt_history/prompt_history_bloc.dart';
import 'bloc/servers/servers_bloc.dart';
import 'bloc/settings/settings_bloc.dart';
import 'bloc/studio/studio_bloc.dart';
import 'config/theme.dart';
import 'l10n/app_strings.dart';
import 'presentation/navigation/router.dart';
import 'services/storage_service.dart';
import 'services/update_checker.dart';

class VidlatteApp extends StatelessWidget {
  final StorageService storageService;

  const VidlatteApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: storageService),
        ChangeNotifierProvider(create: (_) => UpdateChecker()),
      ],
      child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsBloc(storage: storageService)..add(SettingsLoadRequested()),
        ),
        BlocProvider(
          create: (_) => ServersBloc(storage: storageService)..add(ServersLoadRequested()),
        ),
        BlocProvider(
          create: (_) => GenerationBloc(storage: storageService),
        ),
        BlocProvider(
          create: (_) => GalleryBloc(storage: storageService)..add(GalleryLoadRequested()),
        ),
        BlocProvider(
          create: (_) => StudioBloc(storage: storageService)..add(StudioLoadRequested()),
        ),
        BlocProvider(
          create: (_) => LlmBloc(storage: storageService)..add(const LlmLoadRequested()),
        ),
        BlocProvider(
          create: (_) => AutoGenBloc(storage: storageService),
        ),
        BlocProvider(
          create: (_) => PromptHistoryBloc(storage: storageService)..add(PromptHistoryLoadRequested()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final themeMode = AppTheme.modeFor(state.settings.themeMode);
          final locale = _localeFromTag(state.settings.locale);
          return MaterialApp.router(
            title: 'Vidlatte',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkVariantFor(state.settings.themeMode),
            themeMode: themeMode,
            locale: locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: AppStrings.localizationsDelegates,
            routerConfig: AppRouter.config,
          );
        },
      ),
      ),
    );
  }
}

Locale? _localeFromTag(String tag) {
  switch (tag) {
    case 'system':
      return null;
    case 'en':
    case 'en-GB':
      return const Locale('en', 'GB');
    case 'zh':
      return const Locale('zh');
    case 'ru':
      return const Locale('ru');
    case 'ga':
      return const Locale('ga');
    default:
      return null;
  }
}
