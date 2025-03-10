// chat_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_chat/blocs/auth_bloc.dart';
import '../blocs/message_bloc.dart';
import '../widgets/message_bubble.dart';
 class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, User?>((authBloc) {
      return (authBloc.state is AuthSignedInState)
          ? (authBloc.state as AuthSignedInState).user
          : null;
    });

    final messageBloc = BlocProvider.of<MessageBloc>(context);

    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Chat App')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MessageLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        text: state.messages[index].text,
                        isMe: state.messages[index].userId == user.uid,
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Failed to load messages"));
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      messageBloc.add(SendMessage(_controller.text, user.uid));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}