import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/argument/edit_argument.dart';
import 'package:map_exam/argument/login_argument.dart';
import 'package:map_exam/bloc/home/home_bloc.dart';
import 'package:map_exam/bloc/home/home_event.dart';
import 'package:map_exam/bloc/home/home_state.dart';
import 'package:map_exam/constant/note_action.dart';
import 'package:map_exam/di/injection_container.dart';
import 'package:map_exam/model/note.dart';
import 'package:map_exam/repository/response/api_response.dart';
import 'package:map_exam/screen/screen.dart';
import 'package:map_exam/widget/icon_expand.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final LoginArgument? argument;
  const HomeScreen({this.argument}) : super(key: const Key('home'));

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc bloc = inject<HomeBloc>();
  List<Note> _notes = [];

  @override
  void initState() {
    bloc.add(HomeEventGetNotes(widget.argument?.email ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child: BlocBuilder<HomeBloc, HomeState>(
                bloc: bloc,
                buildWhen: (previous, current) => previous.noteCount != current.noteCount,
                builder: (context, state) {
                  return Text(
                    state.noteCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                  );
                }),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: bloc,
          buildWhen: (previous, current) => previous.notes != current.notes,
          builder: (context, notesState) {
            switch (notesState.notes.status) {
              case Status.loading:
                return const Text("Loading");
              case Status.completed:
                Map<String, dynamic> data = notesState.notes.data!.data() as Map<String, dynamic>;

                if (data['notes'] != null && data['notes'].runtimeType == List) {
                  _notes = (data['notes'] as List).map((e) => Note.fromJson(e)).toList();
                  bloc.add(HomeEventNoteCount(_notes.length));
                }

                return BlocBuilder<HomeBloc, HomeState>(
                    bloc: bloc,
                    buildWhen: (previous, current) => previous.isExpand != current.isExpand,
                    builder: (context, expandState) {
                      return ListView.separated(
                        itemCount: _notes.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.blueGrey,
                        ),
                        itemBuilder: (context, index) => BlocBuilder<HomeBloc, HomeState>(
                          bloc: bloc,
                          buildWhen: (previous, current) =>
                              previous.showEditingToolsIndex != current.showEditingToolsIndex,
                          builder: (context, showEditingToolsState) {
                            return ListTile(
                              trailing: showEditingToolsState.showEditingToolsIndex == index
                                  ? SizedBox(
                                      width: 110.0,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () async {
                                            await Navigator.of(context).pushNamed(EditScreen.routeName,
                                                arguments:
                                                    EditArgument(notes: _notes, action: NoteAction.edit, index: index));
                                            bloc.add(HomeEventGetNotes(widget.argument?.email ?? ''));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            bloc.add(HomeEventDeleteNote(widget.argument?.email ?? '', _notes[index]));
                                          },
                                        ),
                                      ]),
                                    )
                                  : null,
                              title: Text(_notes[index].title!),
                              subtitle: (expandState.isExpand ?? true) ? Text(_notes[index].content!) : null,
                              onTap: () {
                                Navigator.of(context).pushNamed(EditScreen.routeName,
                                    arguments: EditArgument(notes: _notes, index: index));
                              },
                              onLongPress: () {
                                bloc.add(HomeEventShowEditingTools(index));
                              },
                            );
                          },
                        ),
                      );
                    });
              case Status.error:
                return const Text("Something went wrong");
              default:
                return const Text("Document does not exist");
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //     child: const Icon(Icons.menu), tooltip: 'Show less. Hide notes content', onPressed: () {}),

          IconExpand(
            onExpand: (isExpand) {
              bloc.add(HomeEventIsExpand(isExpand));
              debugPrint(isExpand.toString());
            },
          ),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed(EditScreen.routeName, arguments: EditArgument(notes: _notes, action: NoteAction.add));
              bloc.add(HomeEventGetNotes(widget.argument?.email ?? ''));
            },
          ),
        ],
      ),
    );
  }
}
