import 'package:firebase_auth/firebase_auth.dart';
import 'package:pantry_chef/models/user.dart';
import 'db_user_collection.dart';
import 'dart:async';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    // print(user.uid);
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // register with email & password
  Future registerWithEmailAndPassword(
      String fname, String email, String password, String confirm) async {
    try {
      if((password != confirm) || (fname.isEmpty)){
        return null;
      } else {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      List<String> initFavorite = [];
      print('the user being created has id: ' + user.uid);
      // create a new document for the user with the uid
      //TODO: fix registration for new Users
      await UserDatabaseService(uid: user.uid).createUserData(email, fname,
          '', user.uid, false, '', '', false, false, false, false, false, initFavorite);
          await UserDatabaseService(uid: user.uid).newUserIngredientList();
          await UserDatabaseService(uid: user.uid).newUserMealPlanList();
      return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
