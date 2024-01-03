import 'package:flutter/material.dart';
import 'Note.dart';
import 'bloc/api_bloc.dart';
import 'bloc/api_states.dart';
import 'bloc/api_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

// Widget for displaying the list of notes in a grid view
Widget NoteListScreen(context, List<Note> notes) {
  // Sort list entries by creation time in reverse order
  notes.sort((a, b) => b.creationTime.compareTo(a.creationTime));
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Note List', // Title of the app bar
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 30,
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        BlocProvider.of<ApiBloc>(context).add(CreateEditScreenEvent());
      },
      backgroundColor: Colors.green,
      child: Icon(Icons.add, color: Colors.white, size: 40), // Floating action button to add a new note
    ),
    body: Scrollbar( // Scrollbar for scrolling the grid view
      child: GridView.builder( // Builder for creating a grid view
        shrinkWrap: true, // Wrap content to its children's height
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid view
          crossAxisSpacing: 1.0, // Spacing between columns
          mainAxisSpacing: 1.0, // Spacing between rows
        ),
        itemCount: notes.length, // Total number of notes
        itemBuilder: (context, index) {
          final note = notes[index]; // Get the note at the current index
          return Card( // Card for each note in the grid view
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
            ),
            child: InkWell( // InkWell for making the card tappable
              onTap: () {
                BlocProvider.of<ApiBloc>(context).add(NoteDetailsEvent(note)); // Event to view details of the note
              },
              child: Container(
                padding: const EdgeInsets.all(8.0), // Padding around the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          note.title, // Title of the note
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          overflow: TextOverflow.ellipsis, // Overflow behavior for the title
                          maxLines: 1, // Maximum lines for the title
                        ),
                        SizedBox(height: 8), // Spacer with height of 8
                        Text(
                          note.content, // Content of the note
                          overflow: TextOverflow.ellipsis, // Overflow behavior for the content
                          maxLines: 6, // Maximum lines for the content
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0), // Padding around the creation time
                      child: Text(
                        DateFormat('dd MMMM yyyy HH:mm')
                            .format(note.creationTime.toDate()), // Format and display creation time of the note
                        style: TextStyle(color: Colors.grey), // Style for the creation time text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
