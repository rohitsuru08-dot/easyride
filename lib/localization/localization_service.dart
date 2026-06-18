// Localization service for multi-language support
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_ride/services/local_storage_service.dart';

class LocalizationService {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  LocalizationService(this.locale);

  // Load localization file based on locale
  Future<bool> load() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/localization/${locale.languageCode}.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get translated string by key
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Static method to get LocalizationService from context
  static LocalizationService? of(BuildContext context) {
    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('te', ''), // Telugu
  ];

  // Check if locale is supported
  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }
}

// LocalizationDelegate for loading localization
class LocalizationDelegate extends LocalizationsDelegate<LocalizationService> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationService.isSupported(locale);
  }

  @override
  Future<LocalizationService> load(Locale locale) async {
    LocalizationService localization = LocalizationService(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}

// Extension method for easy string translation
extension TranslateExtension on String {
  String tr(BuildContext context) {
    return LocalizationService.of(context)?.translate(this) ?? this;
  }
}

// Language provider for managing language state
class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  // Initialize language from storage
  Future<void> initialize() async {
    final savedLanguage = await LocalStorageService.getLanguage();
    _locale = Locale(savedLanguage, '');
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == _locale.languageCode) return;

    _locale = Locale(languageCode, '');
    await LocalStorageService.saveLanguage(languageCode);
    notifyListeners();
  }

  // Toggle between English and Telugu
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'en') {
      await changeLanguage('te');
    } else {
      await changeLanguage('en');
    }
  }
}
