import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/model/contact_class.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'NewContactForm.dart';

String boxName = "contacts";

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key key,
  }) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _hiveBox = Hive.box(boxName);
   TextEditingController _ageController = TextEditingController();
   TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hive Tutorial'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            NewContactForm(),
          ],
        ));
  }

  Widget _buildListView() {
    return WatchBoxBuilder(
      box: _hiveBox,
      builder: (context, contactBox) {
        return ListView.builder(
            itemCount: _hiveBox.length,
            itemBuilder: (_, index) {
              final contact = _hiveBox.getAt(index) as Contact;
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.age.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.update, color: Colors.green,),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) {

                                _nameController = new TextEditingController(text: contact.name);
                                _ageController = new TextEditingController(text: contact.age.toString());

                                return Dialog(
                                  child: Container(
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: _nameController,
                                            ),
                                            SizedBox(height: 16),
                                            TextField(
                                              controller: _ageController,
                                            ),
                                            SizedBox(height: 16),
                                            FlatButton(
                                              child: Text("update"),
                                              onPressed: () {
                                                final age = _ageController.text;
                                                final name =
                                                    _nameController.text;

                                                final newContact = Contact(
                                                    name, int.parse(age));
                                                _hiveBox.putAt(
                                                    index, newContact);
                                                Navigator.pop(context);
                                                _ageController.clear();
                                                _nameController.clear();
                                              },
                                            )
                                          ])),
                                );
                              });
                        }),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("Do you want to delete \"${contact
                                      .name}\" from list?"),
                                  titleTextStyle: TextStyle(color: Colors.red),
                                  actions: [
                                    Expanded(child: FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        _hiveBox.deleteAt(index);
                                        Navigator.pop(context);
                                      },
                                    )),
                                    Expanded(child: FlatButton(
                                      child: Text("No"),
                                      onPressed: () => Navigator.pop(context),
                                    ))
                                  ],
                                );
                              });
                        })
                  ],
                ),
              );
            });
      },
    );
  }
}
