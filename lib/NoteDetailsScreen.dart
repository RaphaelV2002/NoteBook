import 'package:flutter/material.dart';
import 'package:unihelp/bloc/api_events.dart';
import 'Note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/api_bloc.dart';
import 'package:intl/intl.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;

  NoteDetailsScreen({Key? key, required this.note}) : super(key: key);

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note Details', // Title of the app bar
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
          ),
        ),
        leading: BackButton(
          // Back button to navigate back
          onPressed: () {
            BlocProvider.of<ApiBloc>(context).add(NoteListEvent());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Floating action button to edit the note
        onPressed: () {
          BlocProvider.of<ApiBloc>(context)
              .add(CreateEditScreenEvent(note: widget.note));
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 40,
        ),
      ),
      body: Scrollbar(
        // Scrollbar for scrolling the content
        child: SingleChildScrollView(
          // SingleChildScrollView to make the content scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Padding around the content
            child: Column(
              // Main column containing the content
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  // Title of the note
                  widget.note.title,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16), // Spacer with height of 16
                Row(
                  // Row to display creation time and reminder date
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      // Column for creation time
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Label for creation time
                          "Creation time: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          // Display creation time
                          DateFormat('dd MMMM yyyy HH:mm')
                              .format(widget.note.creationTime.toDate()),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      // Column for reminder date (if available)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.note.reminderDate != null
                            ? Text(
                                // Label for reminder date
                                "Reminder date: ",
                                style: TextStyle(fontSize: 18),
                              )
                            : Container(),
                        widget.note.reminderDate != null
                            ? Text(
                                // Display reminder date
                                DateFormat.yMMMd()
                                    .format(widget.note.reminderDate!.toDate()),
                                style: TextStyle(fontSize: 18),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16), // Spacer with height of 16
                Text(
                  // Content of the note
                  widget.note.content,
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
