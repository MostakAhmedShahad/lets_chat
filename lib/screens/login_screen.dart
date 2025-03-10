import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Trigger the sign-in anonymously event
            context.read<AuthBloc>().add(AuthSignInAnonymously());
          },
          child: Text("Login Anonymously"),
        ),
      ),
    );
  }
}
