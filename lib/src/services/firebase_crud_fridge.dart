import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionStore = _firestore.collection('fridge');

class FirebaseCrudFridge {
  // CREATE
  static Future<Response> addFood({
    required String food,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collectionStore.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "food": food,
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Food successfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  // READ
  static Stream<QuerySnapshot> readFood() {
    CollectionReference notesItemCollection = _collectionStore;

    return notesItemCollection.snapshots();
  }

  // UPDATE

  static Future<Response> updateFood({
    required String food,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collectionStore.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{"food": food};

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated Food";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  // DELETE
  static Future<Response> deleteFood({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collectionStore.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Successfully Deleted Food";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
