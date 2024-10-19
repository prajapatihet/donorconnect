import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  // void initialTheme() {
  //   emit(ThemeMode.system);
  // }

  void switchTheme(bool currentValue) {
    if (currentValue) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
    // emit(ThemeMode.system);
  }
}
