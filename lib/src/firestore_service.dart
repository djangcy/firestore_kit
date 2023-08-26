import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_kit/src/exceptions/firestore_failure.dart';

class FirestoreService {
  const FirestoreService({
    required CollectionReference collection,
  }) : _collection = collection;

  final CollectionReference _collection;

  List<Map<String, dynamic>> _readDocs<T>(
    QuerySnapshot<Object?> snapshot, {
    SnapshotOptions? options,
  }) {
    return snapshot.docs
        .map((doc) {
          final d0 = doc as DocumentSnapshot<Map<String, dynamic>>;

          if (d0.exists) {
            return d0.data();
          }
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  Stream<List<Map<String, dynamic>>> _readCollection(
    Query collection, {
    SnapshotOptions? options,
  }) {
    return collection
        .snapshots()
        .map((snapshot) => _readDocs(snapshot, options: options));
  }

  Future<List<Map<String, dynamic>>> _readCollectionOnce(
    Query collection, {
    SnapshotOptions? options,
  }) {
    return collection.get().then((snapshot) => _readDocs(
          snapshot,
          options: options,
        ));
  }

  Query _buildQuery({
    Query Function(Query)? queryBuilder,
  }) {
    final builder = queryBuilder ?? (Query q) => q;
    var query = builder(_collection);

    return query;
  }

  Stream<List<Map<String, dynamic>>> queryCollection({
    Query Function(Query)? queryBuilder,
  }) {
    final query = _buildQuery(queryBuilder: queryBuilder);

    return _readCollection(query);
  }

  Future<List<Map<String, dynamic>>> queryCollectionOnce({
    Query Function(Query)? queryBuilder,
  }) {
    final query = _buildQuery(queryBuilder: queryBuilder);

    return _readCollectionOnce(query);
  }

  Future<void> setDoc(
    Map<String, dynamic> doc, {
    required String docId,
    SetOptions? options,
  }) async {
    try {
      return _collection.doc(docId).set(doc);
    } catch (e) {
      throw FirestoreFailure(e.toString());
    }
  }

  Future<String> addDoc(Map<String, dynamic> doc) async {
    try {
      final result = await _collection.add(doc);

      return result.id;
    } catch (e) {
      throw FirestoreFailure(e.toString());
    }
  }

  void updateDoc(
    Map<String, dynamic> doc, {
    required String docId,
    SetOptions? options,
    Function(String? message)? onError,
  }) {
    try {
      _collection.doc(docId).update(doc);
    } catch (e) {
      throw FirestoreFailure(e.toString());
    }
  }

  void deleteDoc({required String docId}) {
    try {
      _collection.doc(docId).delete();
    } catch (e) {
      throw FirestoreFailure(e.toString());
    }
  }
}
