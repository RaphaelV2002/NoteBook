import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unihelp/firebase_api.dart';
import '/bloc/api_events.dart';
import 'bloc/api_bloc.dart';
import '/bloc/api_states.dart';
import 'NoteList.dart';
import 'CreateEditNoteScreen.dart';
import 'NoteDetailsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Set the dark theme for the app
      home: BlocProvider(
        create: (_) => ApiBloc(), // Create an instance of ApiBloc
        child: MyHomePage(), // Set MyHomePage as the home screen
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ApiBloc>(context).add(NoteListEvent()); // Dispatch an event to fetch the list of notes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBloc(), // Build the UI based on the current state
    );
  }

  Widget buildBloc() {
    return BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
      print(state);
      if (state is LoadingState) {
        return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
      } else if (state is NoteListState) {
        return NoteListScreen(context, state.notes); // Show the list of notes
      } else if (state is CreateEditScreenState) {
        return CreateEditNoteScreen(note: state.note); // Show the create/edit note screen
      } else if (state is NoteDetailsState) {
        return NoteDetailsScreen(note: state.note); // Show the note details screen
      } else if (state is ErrorState) {
        return Center(child: Text("Error")); // Show an error message if there's an error state
      } else {
        return Text("Nothing"); // Show a default message if the state is not recognized
      }
    });
  }
}
