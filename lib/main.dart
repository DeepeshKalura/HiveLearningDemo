import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.initFlutter(appDocumentDir.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  Future<String> storingBox(int studentId, Map<String, String> about) async {
    String response = 'UnSuccessful';
    try {
      var student = await Hive.openBox<Map<String, String>>('student');

      student.put(studentId, about);

      response = 'Successful';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> readingBox(int studentId) async {
    String response = 'UnSuccessful';
    try {
      var student = await Hive.openBox<Map<String, String>>('student');

      response = student.get(studentId).toString();
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> updatingBox(int studentId, Map<String, String> about) async {
    String response = 'UnSuccessful';
    try {
      var student = await Hive.openBox<Map<String, String>>('student');

      student.put(studentId, about);

      response = 'Successful';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> deletingBox(int studentId) async {
    String response = 'UnSuccessful';
    try {
      var student = await Hive.openBox<Map<String, String>>('student');

      student.delete(studentId);

      response = 'Successful';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  // CRUD Operations functi

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hive Demo 1'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      storingBox(1, {
                        'name': 'John',
                        'age': '20',
                        'address': 'USA',
                      });
                    },
                    child: const Text('Create'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      readingBox(1);
                    },
                    child: const Text('Read'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      elevation: MaterialStateProperty.all(3),
                    ),
                    onPressed: () {
                      updatingBox(1, {
                        'name': 'John',
                        'age': '20',
                        'address': 'USA',
                      });
                    },
                    child: const Text('Update'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      deletingBox(1);
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewScreen(),
                        ),
                      );
                    },
                    child: const Text("View >"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ViewScreen extends StatelessWidget {
  const ViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Screen'),
      ),
      body: Column(children: [
        Expanded(
          child: FutureBuilder(
            future: Hive.openBox('student'),
            builder: (context, snapshot) {
              return Card(
                child: Column(
                  children: [
                    Text(snapshot.data?.get(1)['name'].toString() ?? 'No Data'),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
