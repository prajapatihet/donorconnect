import 'package:donorconnect/language/helper/language.dart';
import 'package:donorconnect/language/services/language_repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// part '';
class LanguageCubit extends Cubit<Language> {
  LanguageCubit() : super(Language.english);

  void initilize() {
    emit(LanguageRepository.getPrefferedLanguge());
  }

  // set
  void changeLanguage(Language getlanguageFromUser) {
    emit(getlanguageFromUser);
    LanguageRepository.addPreferredLanguage(getlanguageFromUser);
  }
}
