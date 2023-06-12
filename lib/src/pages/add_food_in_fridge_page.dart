import 'package:flutter/material.dart';

import '../services/firebase_crud_fridge.dart';
import 'list_food_in_fridge_page.dart';

class AddFoodInFridgePage extends StatefulWidget {
  const AddFoodInFridgePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddFoodInFridgePage();
  }
}

class _AddFoodInFridgePage extends State<AddFoodInFridgePage> {
  final _foodName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        controller: _foodName,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Food",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListButton = TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const ListFoodInFridgePage(),
          ),
          (route) => false, //To disable back feature set to false
        );
      },
      child: const Text('View what is in the fridge',
          style: TextStyle(color: Colors.cyan)),
    );

    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response =
                await FirebaseCrudFridge.addFood(food: _foodName.text);
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

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
            'Add food in fridge',
            style: TextStyle(color: Colors.cyan),
          )
        ]),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  const SizedBox(height: 25.0),
                  saveButton,
                  const SizedBox(height: 45.0),
                  viewListButton,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
