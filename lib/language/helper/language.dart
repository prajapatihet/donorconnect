enum Language {
  english(countryFlag: "🇮🇳", languageName: "English", languageCode: "en"),
  hindi(countryFlag: "🇮🇳", languageName: "हिंदी", languageCode: "hi"),
  gujarati(countryFlag: "🇮🇳", languageName: "ગુજરાતી ‍", languageCode: "gu");

  final String countryFlag;
  final String languageName;
  final String languageCode;

  const Language({
    required this.countryFlag,
    required this.languageName,
    required this.languageCode,
  });
}
