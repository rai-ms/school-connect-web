


class LogLoginEvent {
  final String username;
  final String timeStamp;
  final String lat;
  final String long;

  LogLoginEvent({
    required this.username,
    required this.lat,
    required this.long,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'timeStamp': timeStamp,
      'lat': lat,
      'long': long,
    };
  }
}
