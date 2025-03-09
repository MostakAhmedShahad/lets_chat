class Message {
  final String text;
  final String userId;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.userId,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Message(
      text: data['text'],
      userId: data['userId'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
