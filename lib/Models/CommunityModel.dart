class Community {
  final String id;
  final String name;
  final List<String> members;
  final List<Message> messages;

  Community({required this.id, required this.name, required this.members, required this.messages});
}

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});
}
