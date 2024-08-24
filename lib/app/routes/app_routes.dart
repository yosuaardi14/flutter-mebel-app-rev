// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const LIST_BAHAN_BAKU = '/list-bahan-baku';
  static const LIST_USER = '/list-user';
  static const DETAIL_BAHAN_BAKU = '/detail-bahan-baku';
  static const ADD_BAHAN_BAKU = '/add-bahan-baku';
  static const ADD_USER = '/add-user';
  static const DETAIL_USER = '/detail-user';
  static const ADD_PESANAN = '/add-pesanan';
  static const DETAIL_PESANAN = '/detail-pesanan';
  static const LIST_PESANAN = '/list-pesanan';
  static const CEK_PESANAN = '/cek-pesanan';

  static const ADD_ACTIVITY = '/add-activity';
  static const LIST_ACTIVITY = '/list-activity';
}
