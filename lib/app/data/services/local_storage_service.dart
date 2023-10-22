import 'package:get_secure_storage/get_secure_storage.dart';

class LocalStorageService {
  static const container = "FlutterMebelApp";

  static Future<void> writeData(String key, dynamic value) async {
    final storage = GetSecureStorage(container: container);
    await storage.write(key, value);
  }

  static dynamic readData(String key) async {
    final storage = GetSecureStorage(container: container);
    await storage.read(key);
  }

  static Future<void> removeData(String key) async {
    final storage = GetSecureStorage(container: container);
    await storage.remove(key);
  }

  static Future<void> removeALl() async {
    final storage = GetSecureStorage(container: container);
    await storage.erase();
  }
}
