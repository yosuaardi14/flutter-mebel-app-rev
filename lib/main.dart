import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/app.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/local_storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorageService.initStorage();
  AuthService authService = AuthService();
  await authService.loadLoginData();
  runApp(const App());
}