import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_crud_fridge.dart';
import '../models/fridge.dart';
import 'add_food_in_fridge_page.dart';
import 'edit_fridge_page.dart';
import '';

class ListFoodInFridgePage extends StatefulWidget {
  const ListFoodInFridgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListFoodInFridgePage();
  }
}

class _ListFoodInFridgePage extends State<ListFoodInFridgePage> {
  final AuthenticationService authService = AuthenticationService();

  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrudFridge.readFood();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Row(children: const [
          Icon(
            Icons.severe_cold,
            size: 30,
            color: Colors.cyan,
          ),
          SizedBox(width: 10),
          Text(
            'Food in the fridge',
            style: TextStyle(color: Colors.cyan),
          )
        ]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.app_registration,
              color: Colors.cyan,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) =>
                      const AddFoodInFridgePage(),
                ),
                (route) =>
                    false, //if you want to disable back feature set to false
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                      child: Column(children: [
                    ListTile(
                      title: Text(e["food"]),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 143, 133, 226),
                            padding: const EdgeInsets.all(5.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    EditFridgePage(
                                  food: Fridge(uid: e.id, food: e["food"]),
                                ),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 143, 133, 226),
                            padding: const EdgeInsets.all(5.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'),
                          onPressed: () async {
                            var response = await FirebaseCrudFridge.deleteFood(
                                docId: e.id);
                            if (response.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                          Text(response.message.toString()),
                                    );
                                  });
                            }
                          },
                        ),
                      ],
                    ),
                  ]));
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const signOutTimeout = Duration(seconds: 10);

          authService.signOut().timeout(signOutTimeout, onTimeout: () {
            // Handle timeout error
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Timeout Error'),
                  content: const Text('Sign-out operation timed out.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            return; // Return early or perform any necessary cleanup
          }).then((_) {
            // Sign-out operation completed successfully
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginScreen(authenticationService: authService)),
            );
          }).catchError((error) {
            // Handle other errors
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text('Sign-out operation failed: $error'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          });
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
