import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/api_bloc.dart';
import 'Note.dart';
import 'bloc/api_events.dart';
import 'package:intl/intl.dart';

class CreateEditNoteScreen extends StatefulWidget {
  final Note? note;

  CreateEditNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _CreateEditNoteScreenState createState() => _CreateEditNoteScreenState();
}

class _CreateEditNoteScreenState extends State<CreateEditNoteScreen> {
  DateTime? _selectedDate;
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();
  late TextEditingController _reminderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
    _reminderController = TextEditingController(
        text: widget.note?.reminderDate != null
            ? DateFormat.yMMMd().format(widget.note!.reminderDate!.toDate())
            : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note != null ? 'Note Edit' : 'Note Create',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
          ),
        ),
        leading: BackButton(onPressed: () {
          final title = _titleController.text;
          final content = _contentController.text;
          if (title.isNotEmpty && content.isNotEmpty) {
            final note = Note(
              id: widget.note?.id ?? '',
              // Use the id if editing an existing note
              title: title,
              content: content,
              creationTime: Timestamp.now(),
              reminderDate: _selectedDate != null
                  ? Timestamp.fromDate(_selectedDate!)
                  : null,
            );
            if (widget.note != null) {
              BlocProvider.of<ApiBloc>(context).add(UpdateNoteEvent(
                  note)); // Dispatch an event to update the note
            } else {
              BlocProvider.of<ApiBloc>(context).add(SaveNoteEvent(
                  note)); // Dispatch an event to create a new note
            }
            BlocProvider.of<ApiBloc>(context).add(NoteDetailsEvent(widget
                .note!)); // Dispatch an event to view the details of the note
          } else {
            BlocProvider.of<ApiBloc>(context).add(NoteListEvent());
          }
        }),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  // Text field for entering the title
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter the title',
                  ),
                  style: TextStyle(fontSize: 40),
                ),
                TextField(
                  // Text field for selecting a reminder date
                  controller: _reminderController,
                  decoration: InputDecoration(
                    hintText: 'Select a reminder date',
                  ),
                  onTap: () {
                    _selectDate(context); // Call a method to select a date
                  },
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16), // Spacer with height of 16
                TextField(
                  // Text field for entering the text content
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Enter the text',
                    border: InputBorder.none,
                  ),
                  maxLines: null, // Allow unlimited lines for text input
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to select a date
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _reminderController.text = DateFormat.yMMMd().format(_selectedDate!);
      _reminderController.selection = TextSelection.fromPosition(TextPosition(
          offset: _reminderController.text.length,
          affinity: TextAffinity.upstream));
    } else {
      _selectedDate = null;
      _reminderController
          .clear(); // Clear the input field if the date is not selected
    }
  }
}
