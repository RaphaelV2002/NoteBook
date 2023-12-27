import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_states.dart';
import '../create_account_page.dart';
import '../ProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  WidgetsFlutterBinding.ensureInitialized();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UNIhelp"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Обработка нажатия на кнопку
        },
        child: Icon(Icons.add),
      ),
      body: buildBloc(),
    );
  }

  Widget buildBloc() {
    return BlocBuilder<ApiBloc, ApiStates>(builder: (context, state) {
      if (state is LoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SuccessfulGoogleSignInState) {
        return ProfileScreen(
            userProfile:
                state.userProfile); // Передача userProfile в ProfileScreen
      } else if (state is SuccessfulGoogleSignInState) {
        return ProfileScreen(
            userProfile:
            state.userProfile); // Передача userProfile в ProfileScreen
      } else {
        return CreateAccountPage();
      }
    });
  }
}
