import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_events.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_states.dart';
import 'NoteList.dart';
import 'CreateEditNoteScreen.dart';
import 'NoteDetailsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:unihelp/CreateEditNoteScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepOrangeAccent)),
      home: BlocProvider(
        create: (_) => ApiBloc(),
        child: MyHomePage(),
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
    BlocProvider.of<ApiBloc>(context).add(NoteListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: buildBloc(),
    );
  }

  Widget buildBloc() {
    return BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
      if (state is LoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is NoteListState) {
        return NoteListScreen(context,state.notes);
      } else if (state is CreateEditScreenState) {
        return CreateEditNoteScreen(note: state.note);
      } else if (state is NoteDetailsState) {
        return NoteDetailsScreen(context, state.note);
      } else {
        return Text("Nothing");
      }
    });
  }
}
