class Message {
  final String text;
  final bool isUser; // true if sent by user, false if from AI
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});
}