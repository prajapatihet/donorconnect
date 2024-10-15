import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

// ForgotPasswordState Definitions
part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final FirebaseAuth _auth;

  ForgotPasswordCubit(this._auth) : super(ForgotPasswordInitial());

  Future<void> resetPassword(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const ForgotPasswordError('No user found for that email.'));
      } else {
        emit(ForgotPasswordError(e.message ?? 'An unknown error occurred.'));
      }
    }
  }
}
