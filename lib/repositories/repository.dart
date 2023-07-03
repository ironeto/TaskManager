import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseFirebaseFireStoreRepository {

  var db = FirebaseFirestore.instance;
  // final _baseUrl = "https://dmcflutter23t2-default-rtdb.firebaseio.com/";
  String _collection; // collection
  // final auth = FirebaseAuth.instance;

  set dbFireStore(FirebaseFirestore db) {
    this.db = db;
  }

  BaseFirebaseFireStoreRepository(this._collection);

  Future<QuerySnapshot<Map<String, dynamic>>> list() {
    // return db.collection(_collection).where("users_id", ).get(); 
    // return db.collection(_collection).limit(10).get(); 
    return db.collection(_collection).get(); 
  }

  Future<void> insert(String id, Map<String, dynamic> data) {
    return db.collection(_collection).doc(id).set(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> show(String id) {
    return db.collection(_collection).doc(id).get();
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return db.collection(_collection).doc(id).set(data);
  }

 Future<void> delete(String id) {
    return db.collection(_collection).doc(id).delete();
  }
}