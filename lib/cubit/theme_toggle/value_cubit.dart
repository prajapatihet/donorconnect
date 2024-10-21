import 'package:flutter_bloc/flutter_bloc.dart';

class ValueCubit extends Cubit<bool> {
  ValueCubit() : super(false);

  void changeValue(bool value) {
    emit(value);
  }
}
