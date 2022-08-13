import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/argument/login_argument.dart';
import 'package:map_exam/model/note.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  final LoginArgument? argument;
  List<Note> _notes = [];
  StreamController<int> noteCount = StreamController();

  // static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  HomeScreen({this.argument}) : super(key: const Key('home'));

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: StreamBuilder<int>(
                initialData: 0,
                stream: noteCount.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  );
                }),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(argument?.email).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                if (data['notes'] != null && data['notes'].runtimeType == List) {
                  _notes = (data['notes'] as List).map((e) => Note.fromJson(e)).toList();
                  noteCount.sink.add(_notes.length);
                }
              }

              return ListView.separated(
                itemCount: _notes.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.blueGrey,
                ),
                itemBuilder: (context, index) => ListTile(
                  trailing: SizedBox(
                    width: 110.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.blue,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  title: Text(_notes[index].title!),
                  subtitle: Text(_notes[index].content!),
                  onTap: () {},
                  onLongPress: () {},
                ),
              );
            }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.menu), tooltip: 'Show less. Hide notes content', onPressed: () {}),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
