// ignore_for_file: constant_identifier_names

import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/bindings/add_aktivitas_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/views/add_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/bindings/list_aktivitas_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/views/list_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/auth/views/login_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/bindings/cek_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/views/cek_pesanan_view.dart';
import 'package:get/get.dart';

import 'package:flutter_mebel_app_rev/app/modules/add_bahan_baku/bindings/add_bahan_baku_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/bindings/add_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_pesanan/views/add_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_user/bindings/add_user_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/add_user/views/add_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/bindings/detail_bahan_baku_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/bindings/detail_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_pesanan/views/detail_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_user/bindings/detail_user_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/detail_user/views/detail_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/home/views/home_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_bahan_baku/bindings/list_bahan_baku_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_bahan_baku/views/list_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_pesanan/bindings/list_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_pesanan/views/list_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_user/bindings/list_user_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/list_user/views/list_user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.LIST_BAHAN_BAKU,
      page: () => const ListBahanBakuView(),
      binding: ListBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.LIST_USER,
      page: () => const ListUserView(),
      binding: ListUserBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_BAHAN_BAKU,
      page: () => const DetailBahanBakuView(),
      binding: DetailBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.ADD_BAHAN_BAKU,
      page: () => const AddBahanBakuView(),
      binding: AddBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.ADD_USER,
      page: () => const AddUserView(),
      binding: AddUserBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_USER,
      page: () => const DetailUserView(),
      binding: DetailUserBinding(),
    ),
    GetPage(
      name: Routes.ADD_PESANAN,
      page: () => const AddPesananView(),
      binding: AddPesananBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_PESANAN,
      page: () => const DetailPesananView(),
      binding: DetailPesananBinding(),
    ),
    GetPage(
      name: Routes.LIST_PESANAN,
      page: () => const ListPesananView(),
      binding: ListPesananBinding(),
    ),
    GetPage(
      name: Routes.CEK_PESANAN,
      page: () => CekPesananView(),
      binding: CekPesananBinding(),
    ),
    GetPage(
      name: Routes.ADD_ACTIVITY,
      page: () => const AddAktivitasView(),
      binding: AddAktivitasBinding(),
    ),
    GetPage(
      name: Routes.LIST_ACTIVITY,
      page: () => const ListAktivitasView(),
      binding: ListAktivitasBinding(),
    ),
  ];
}
