import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthSignInAnonymously>(_onSignInAnonymously);
    on<AuthSignOut>(_onSignOut);
    _authService.userStream.listen((user) {
      add(AuthUserChanged(user));
    });
  }

  Future<void> _onSignInAnonymously(
      AuthSignInAnonymously event, Emitter<AuthState> emit) async {
    try {
      await _authService.signInAnonymously();
    } catch (e) {
      emit(AuthError("Failed to sign in"));
    }
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    try {
      await _authService.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("Failed to sign out"));
    }
  }
}

abstract class AuthEvent {}

class AuthSignInAnonymously extends AuthEvent {}

class AuthSignOut extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final dynamic user;
  AuthUserChanged(this.user);
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSignedIn extends AuthState {
  final dynamic user;
  AuthSignedIn(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
