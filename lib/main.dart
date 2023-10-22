import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/data/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetSecureStorage.init(container: LocalStorageService.container);
  runApp(
    GetMaterialApp(
      title: "Mebel App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
