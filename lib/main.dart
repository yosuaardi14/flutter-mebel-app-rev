import 'package:flutter/material.dart';
import 'package:flutter_mebel_app_rev/app/data/services/auth_service.dart';
import 'package:flutter_mebel_app_rev/app/data/services/local_storage_service.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  var initialPage = await checkLogin();
  runApp(
    GetMaterialApp(
      title: "Mebel App",
      initialRoute: initialPage,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [FormBuilderLocalizations.delegate],
    ),
  );
}

Future<String> checkLogin() async {
  AuthService authService = AuthService();
  return await authService.loadLoginData()
      ? Routes.LIST_PESANAN
      : AppPages.INITIAL;
}