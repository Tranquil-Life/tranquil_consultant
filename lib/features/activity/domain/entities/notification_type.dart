class NotificationType {
  final String type;

  const NotificationType(this.type);

  static const message = NotificationType('message');
  static const meeting = NotificationType('meeting');
  static const payment = NotificationType('payment');
  static const people = NotificationType('people');
  static const notification = NotificationType('notification');

  @override
  String toString() => type;


  static NotificationType fromValue(String type) {
    switch (type) {
      case 'message':
        return message;
      case 'meeting':
        return meeting;
      case 'payment':
        return payment;
      case 'people':
        return people;
      default:
        return notification;
    }
  }
}