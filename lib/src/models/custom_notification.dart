class CustomNotification{
  final int id;
  final String? title;
  final String? body;
  final DateTime? dateTime;


  CustomNotification({
    required this.id,
    this.title,
    this.body,
    this.dateTime
  });
}