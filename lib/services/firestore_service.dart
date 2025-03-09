import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages() {
    return _firestore.collection('messages')
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList());
  }

  Future<void> sendMessage(String text, String userId) async {
    await _firestore.collection('messages').add({
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
