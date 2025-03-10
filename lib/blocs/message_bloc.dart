import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/firestore_service.dart';
import '../models/message_model.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FirestoreService _firestoreService;

  MessageBloc(this._firestoreService) : super(MessageLoading()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

   Future<void> _onLoadMessages(
    LoadMessages event, Emitter<MessageState> emit) async {
  try {
    print("Loading messages...");
    _firestoreService.getMessages().listen((messages) {
      print("Messages loaded: ${messages.length}");
      emit(MessageLoaded(messages));
    });
  } catch (e) {
    print("Failed to load messages: $e");
    emit(MessageError(message:"Failed to load messages"));
  }
}

  Future<void> _onSendMessage(SendMessage event, Emitter<MessageState> emit) async {
    try {
      await _firestoreService.sendMessage(event.text, event.userId);
    } catch (e) {
      emit(MessageError(message: "Failed to send message"));
    }
  }
}

abstract class MessageEvent {}

class LoadMessages extends MessageEvent {}

class SendMessage extends MessageEvent {
  final String text;
  final String userId;

  SendMessage(this.text, this.userId);
}

abstract class MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;
  MessageLoaded(this.messages);
}

class MessageError extends MessageState {
  final String message;
  MessageError({required this.message});
}
