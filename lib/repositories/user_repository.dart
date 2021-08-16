import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_link_reward_app/models/user.dart';
import 'package:dynamic_link_reward_app/services/auth_service.dart';
import 'package:dynamic_link_reward_app/services/code_generator.dart';
import 'package:dynamic_link_reward_app/services/deep_link_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserRepository {
  UserRepository._();
  static UserRepository? _instance;

  static UserRepository? get instance {
    if (_instance == null) {
      _instance = UserRepository._();
    }
    return _instance;
  }

  ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);

  User? get user {
    return currentUserNotifier.value;
  }

  Future<User?> logIn(String email, String password, {required Function() notifyListeners}) async {
    final authUser = await AuthService.instance?.logIn(email, password);
    if (authUser != null) {
      final user = await getUser(authUser.uid);
      currentUserNotifier.value = user;
      notifyListeners();
      return user;
    } else {
      return null;
    }
  }

  Future<User?> registerUser(String name, String email, String password,
      {String? referrerCode, required Function() notifyListeners}) async {
    final uid = await AuthService.instance?.signUp(email, password);
    final referCode = CodeGenerator.generateCode('refer');
    final referLink = await DeepLinkService.instance?.createReferLink(referCode);
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'refer_link': referLink,
      'refer_code': referCode,
      'reward': 0,
    });
    currentUserNotifier.value = await getUser(uid!);
    notifyListeners();
    if (referrerCode != null && referrerCode.isNotEmpty) {
      await rewardUserFromReferCode(referrerCode);
    }
  }

  Future<User?> getUser(String uid) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print("user Id ${userSnapshot.data()}");
    if (userSnapshot.exists) {
      return User.fromJson(userSnapshot.id, userSnapshot.data() as Map<String, dynamic>);
    }
  }

  Future<void> rewardUserFromReferCode(String referCode) async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').where('refer_code', isEqualTo: referCode).get();
    Future.wait(userSnapshot.docs.map((doc) async {
      if (doc.exists) {
        await rewardUser(doc.id, referCode);
      }
    }));
  }

  Future<void> rewardUser(String uid, String referrerCode) async {
    final user = await getUser(uid);
    try {
      user?.referrers?.firstWhere((referCode) => referCode == referrerCode);
    } catch (_) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'reward': FieldValue.increment(100),
        'referrers': FieldValue.arrayUnion([referrerCode]),
      });
    }
  }

  Future<void> listenToCurrent(void Function() notifyListeners) async {
    if (UserRepository.instance?.user == null) {
      var fbUser = auth.FirebaseAuth.instance.currentUser;
      if (fbUser == null) {
        try {
          fbUser = await auth.FirebaseAuth.instance.authStateChanges().first;
          if (fbUser != null) {
            currentUserNotifier.value = await getUser(fbUser.uid);
            notifyListeners();
          }
        } catch (_) {}
      }
      if (fbUser == null) {
        print("no  user");
      } else {
        final user = await getUser(fbUser.uid);
        currentUserNotifier.value = user;
        print(user?.uid);

        notifyListeners();
      }
    }
  }

  logOutUser() async {
    currentUserNotifier.value = null;
    await AuthService.instance?.logOut();
  }
}
