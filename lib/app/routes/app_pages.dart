// ignore_for_file: constant_identifier_names

import 'package:flutter_mebel_app_rev/app/modules/aktivitas/add_aktivitas/views/add_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/aktivitas/list_aktivitas/views/list_aktivitas_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/auth/views/login_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/add_bahan_baku/views/add_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/detail_bahan_baku/views/detail_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/bahan_baku/list_bahan_baku/views/list_bahan_baku_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/bindings/cek_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/cek_pesanan/views/cek_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/home/views/home_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/bindings/add_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/add_pesanan/views/add_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/bindings/detail_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/detail_pesanan/views/detail_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/list_pesanan/bindings/list_pesanan_binding.dart';
import 'package:flutter_mebel_app_rev/app/modules/pesanan/list_pesanan/views/list_pesanan_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/add_user/views/add_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/detail_user/views/detail_user_view.dart';
import 'package:flutter_mebel_app_rev/app/modules/user/list_user/views/list_user_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      // binding: HomeBinding(),
      children: [
        GetPage(
          name: Routes.LOGIN,
          page: () => const LoginPage(),
          // binding: LoginBinding(),
        ),
        GetPage(
          name: Routes.CEK_PESANAN,
          page: () => CekPesananView(),
          binding: CekPesananBinding(),
        ),
      ],
    ),
    GetPage(
      name: Routes.LIST_BAHAN_BAKU,
      page: () => const ListBahanBakuPage(),
      // binding: ListBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.LIST_USER,
      page: () => const ListUserPage(),
      // binding: ListUserBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_BAHAN_BAKU,
      page: () => const DetailBahanBakuPage(),
      // binding: DetailBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.ADD_BAHAN_BAKU,
      page: () => const AddBahanBakuPage(),
      // binding: AddBahanBakuBinding(),
    ),
    GetPage(
      name: Routes.ADD_USER,
      page: () => const AddUserPage(),
      // binding: AddUserBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_USER,
      page: () => const DetailUserPage(),
      // binding: DetailUserBinding(),
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
      name: Routes.ADD_ACTIVITY,
      page: () => const AddAktivitasPage(),
      // binding: AddAktivitasBinding(),
    ),
    GetPage(
      name: Routes.LIST_ACTIVITY,
      page: () => const ListAktivitasPage(),
      // binding: ListAktivitasBinding(),
    ),
  ];
}
