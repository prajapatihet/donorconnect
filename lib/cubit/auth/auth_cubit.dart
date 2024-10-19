import 'package:donorconnect/views/pages/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:donorconnect/cubit/auth/auth_state.dart';
import 'package:donorconnect/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 6.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 700), // Increase the duration to 700ms
    );
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // After signing in, get the user data
      _getUserData(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthError("No User Found for that Email"));
      } else if (e.code == 'invalid-credential') {
        emit(const AuthError("Invalid mail or password Provided by User"));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    try {
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() {});
      UserModel userModel = UserModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        name: FirebaseAuth.instance.currentUser!.displayName!,
        email: FirebaseAuth.instance.currentUser!.email!,
        phone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
        isOrganDonor: false,
        isBloodDonor: false,
      );
      _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen(
        (DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            UserModel user =
                UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
            emit(Authenticated(user));
            print(user.name);
            print(user.email);
            // Save user name to SharedPreferences
            _saveUserToPrefs(FirebaseAuth.instance.currentUser!.uid, user);
          } else {
            _firestore
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set(userModel.toMap());
            // Save user data to SharedPreferences
            _saveUserToPrefs(FirebaseAuth.instance.currentUser!.uid, userModel);
            emit(Authenticated(userModel));
          }
        },
        onError: (error) {
          emit(AuthError(error.toString()));
        },
      );
      emit(Authenticated(userModel));
    } catch (e) {
      print(e);
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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      // Save user data to SharedPreferences
      await _saveUserToPrefs(userCredential.user!.uid, userModel);

      emit(
          Authenticated(userModel)); // Emit authenticated state with user model
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(const AuthError("Password Provided is too Weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthError("User with this credential already exists"));
      } else {
        print(e.code);
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(Unauthenticated());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FrontPage(),
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _getUserData(String uid) {
    _firestore.collection('users').doc(uid).snapshots().listen(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          UserModel user =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
          emit(Authenticated(user));
          print(user.name);
          print(user.email);
          // Save user name to SharedPreferences
          _saveUserNameToPrefs(user.uid, user.name);
        } else {
          emit(const AuthError('User data not found'));
        }
      },
      onError: (error) {
        emit(AuthError(error.toString()));
      },
    );
  }

  Future<void> _saveUserNameToPrefs(String userId, String name) async {
    final prefs = await SharedPreferences.getInstance();

    print(name);
    await prefs.setString('${userId}_name', name);
  }

  Future<void> _saveUserToPrefs(String userId, UserModel userModel) async {
    final prefs = await SharedPreferences.getInstance();

    print(userModel.name);
    await prefs.setString('${userId}_name', userModel.name);
    await prefs.setString('${userId}_email', userModel.email);
    await prefs.setString('${userId}_phone', userModel.phone);
    await prefs.setBool('${userId}_isOrganDonor', userModel.isOrganDonor);
    await prefs.setBool('${userId}_isBloodDonor', userModel.isBloodDonor);
  }
}
