import 'package:cloud_firestore/cloud_firestore.dart';

class BaseFirestoreService {
  static BaseFirestoreService? _instance;
  final String collectionName;
  late final CollectionReference<Map<String, dynamic>> _collection;
  
  // Getter
  CollectionReference<Map<String, dynamic>> get collection => _collection;

  // Private constructor with the collectionName parameter
  BaseFirestoreService.internal(this.collectionName) {
    _collection = FirebaseFirestore.instance.collection(collectionName);
  }

  // Factory constructor to create or return the existing singleton instance
  factory BaseFirestoreService(String collectionName) {
    _instance ??= BaseFirestoreService.internal(collectionName);
    return _instance!;
  }
}
