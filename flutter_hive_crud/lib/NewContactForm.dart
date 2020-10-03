import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'model/contact_class.dart';

String boxName = "contacts";
class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _hiveBox = Hive.box(boxName);

  String _name;
  String _age;

  void addContact(Contact contact) {
    _hiveBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _age = value,
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text('Add New Contact'),
            onPressed: () {
              _formKey.currentState.save();
              final newContact = Contact(_name, int.parse(_age));
              addContact(newContact);
              _formKey.currentState.reset();
            },
          ),
        ],
      ),
    );
  }
}