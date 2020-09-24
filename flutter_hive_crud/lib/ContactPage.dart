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
  final _hiveBox =  Hive.box(boxName);

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
      builder: (context, contactBox){
        return ListView.builder(
            itemCount: _hiveBox.length,
            itemBuilder: (_, index){
              final contact = _hiveBox.getAt(index) as Contact;
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.age.toString()),
              );
            });
      },
    );
  }
}