import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/api_bloc.dart';
import 'bloc/api_states.dart';
import 'Note.dart';
import 'bloc/api_events.dart';

class CreateEditNoteScreen extends StatefulWidget {
  final Note? note;

  CreateEditNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _CreateEditNoteScreenState createState() => _CreateEditNoteScreenState();
}

class _CreateEditNoteScreenState extends State<CreateEditNoteScreen> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'Create Note'),
      ),
      body: BlocProvider(
        create: (_) => ApiBloc(),
        child: BlocBuilder<ApiBloc, ApiStates>(
          builder: (context, state) {
            print(state);
            if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NoteListState) {
              return buildPadding(context);
            } else {
              return Center(child: Text('Failed to load notes'));
            }
          },
        ),
      ),
    );
  }

  Padding buildPadding(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
            maxLines: null,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final title = _titleController.text;
              final content = _contentController.text;
              final note = Note(
                id: widget.note?.id ?? '',
                // Используйте id, если редактируется существующая заметка
                title: title,
                content: content,
                creationTime: DateTime.now(),
              );
              if (widget.note != null) {
                BlocProvider.of<ApiBloc>(context).add(UpdateNoteEvent(note)); // Отправка события обновления записи
              } else {
                BlocProvider.of<ApiBloc>(context).add(SaveNoteEvent(note)); // Отправка события создания новой записи
              }
              Navigator.pop(context);
            },
            child: Text(widget.note != null ? 'Save Changes' : 'Create Note'),
          ),
        ],
      ),
    );
  }
}
