import 'package:flutter/material.dart';
import 'package:flutter_hive_crud/model/contact_class.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'ContactPage.dart';

 String boxName = "contacts";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(applicationDirectory.path);
  Hive.registerAdapter<Contact>(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder<Object>(
        future: Hive.openBox(boxName),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()),);
            else
            return ContactPage();
          }else
            return Scaffold();
        }
      ),
    );
  }

  @override
  void dispose() {
    Hive.box(boxName).close();
    super.dispose();
  }
}
