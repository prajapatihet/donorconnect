import 'package:donorconnect/language/helper/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepository {
  static late SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // store language in local storage
  static void addPreferredLanguage(Language language) {
    _prefs.setString("language_key", language.languageCode);
  }

  // get stored language
  static Language getPrefferedLanguge() {
    final code = _prefs.getString("language_key");
    for (var values in Language.values) {
      if (values.languageCode == code) return values;
    }
    return Language
        .english; // default to English if not found in stored languages
  }
}
