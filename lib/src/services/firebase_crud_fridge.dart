import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionStore = _firestore.collection('fridge');

class FirebaseCrudFridge {
  // CREATE
  static Future<AppResponse> addFood({
    required String food,
  }) async {
    AppResponse response = AppResponse();
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

  static Future<AppResponse> updateFood({
    required String food,
    required String docId,
  }) async {
    AppResponse response = AppResponse();
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
  static Future<AppResponse> deleteFood({
    required String docId,
  }) async {
    AppResponse response = AppResponse();
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
