import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/utils/language_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Locale _locale = LanguageService.defaultLocale;
  final appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await LanguageService.getSavedLocale();
    if (mounted) {
      setState(() {
        _locale = savedLocale;
      });
    }
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
    LanguageService.saveLocale(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return _AppInheritedWidget(
      locale: _locale,
      changeLocale: _changeLocale,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.getSupportedLocales(),
            theme: FlexThemeData.light(
            scheme: FlexScheme.blue,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 7,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.blue,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 13,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}

/// Inherited widget to provide locale change functionality to child widgets
class _AppInheritedWidget extends InheritedWidget {
  final Locale locale;
  final void Function(Locale) changeLocale;

  const _AppInheritedWidget({
    required this.locale,
    required this.changeLocale,
    required super.child,
  });

  static _AppInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppInheritedWidget>();
  }

  @override
  bool updateShouldNotify(_AppInheritedWidget oldWidget) {
    return locale != oldWidget.locale;
  }
}

/// Extension to easily access language service from context
extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  void changeLanguage(Locale locale) {
    _AppInheritedWidget.of(this)?.changeLocale(locale);
  }
}
