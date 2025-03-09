import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/message_bloc.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  
  final authService = AuthService();
  final firestoreService = FirestoreService();

  runApp(MyApp(
    authService: authService,
    firestoreService: firestoreService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final FirestoreService firestoreService;

  MyApp({required this.authService, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authService)),
        BlocProvider(create: (_) => MessageBloc(firestoreService)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSignedIn) {
              return ChatScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}
