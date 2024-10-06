import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:donorconnect/cubit/auth/auth_state.dart';
import 'package:donorconnect/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthCubit(this._auth, this._firestore) : super(AuthInitial()) {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _getUserData(user.uid);
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required bool isOrganDonor,
    required bool isBloodDonor,
  }) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        isOrganDonor: isOrganDonor,
        isBloodDonor: isBloodDonor,
      );
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userModel.toMap());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _getUserData(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          UserModel user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          emit(Authenticated(user));
        } else {
          emit(AuthError('User data not found'));
        }
      },
      onError: (error) {
        emit(AuthError(error.toString()));
      },
    );
  }
}