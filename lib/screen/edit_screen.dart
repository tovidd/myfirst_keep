import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_exam/argument/edit_argument.dart';
import 'package:map_exam/bloc/edit/edit_bloc.dart';
import 'package:map_exam/bloc/edit/edit_event.dart';
import 'package:map_exam/bloc/edit/edit_state.dart';
import 'package:map_exam/constant/note_action.dart';
import 'package:map_exam/di/injection_container.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = '/edit';
  final EditArgument argument;
  // static Route route() => MaterialPageRoute(builder: (_) => const EditScreen());

  const EditScreen({required this.argument}) : super(key: const Key('edit'));

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _fieldEnabled = false;
  User? user = FirebaseAuth.instance.currentUser;
  final EditBloc bloc = inject<EditBloc>();

  @override
  void initState() {
    setUpData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getTitle() {
    switch (widget.argument.action) {
      case NoteAction.edit:
        return 'Edit Note';
      case NoteAction.add:
        return 'Add new Note';
      default:
        return 'View Note';
    }
  }

  bool showCheckIcon() {
    switch (widget.argument.action) {
      case NoteAction.edit:
        return true;
      case NoteAction.add:
        return true;
      default:
        return false;
    }
  }

  void setUpData() {
    switch (widget.argument.action) {
      case NoteAction.edit:
        {
          _fieldEnabled = true;
          _titleController.text = widget.argument.notes![widget.argument.index!].title!;
          _descriptionController.text = widget.argument.notes![widget.argument.index!].content!;
        }
        break;
      case NoteAction.add:
        {
          _fieldEnabled = true;
        }
        break;
      default:
        {
          _fieldEnabled = false;
          _titleController.text = widget.argument.notes![widget.argument.index!].title!;
          _descriptionController.text = widget.argument.notes![widget.argument.index!].content!;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(getTitle()),
        actions: [
          if (showCheckIcon())
            BlocListener<EditBloc, EditState>(
              bloc: bloc,
              listenWhen: (previous, current) => previous.isSucceed != current.isSucceed,
              listener: (context, state) {
                if (state.isSucceed) {
                  Navigator.of(context).pop();
                }
              },
              child: IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                ),
                onPressed: () {
                  if (widget.argument.action == NoteAction.edit) {
                    bloc.add(EditEventEditNote(
                      email: user?.email ?? '',
                      notes: widget.argument.notes!,
                      index: widget.argument.index!,
                      newTitle: _titleController.text,
                      newContent: _descriptionController.text,
                    ));
                  } else if (widget.argument.action == NoteAction.add) {
                    bloc.add(EditEventAddNote(
                      email: user?.email ?? '',
                      notes: widget.argument.notes!,
                      newTitle: _titleController.text,
                      newContent: _descriptionController.text,
                    ));
                  }
                },
              ),
            ),
          IconButton(
            icon: const Icon(
              Icons.cancel_sharp,
              size: 30,
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              initialValue: null,
              enabled: _fieldEnabled,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TextFormField(
                controller: _descriptionController,
                enabled: _fieldEnabled,
                initialValue: null,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Type the description',
                ),
                onChanged: (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
