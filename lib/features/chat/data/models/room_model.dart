class DailyRoom {
  final String room;
  final String roomUrl;
  final int expiresAt;
  final bool reused;

  DailyRoom({
    required this.room,
    required this.roomUrl,
    required this.expiresAt,
    required this.reused
  });

  factory DailyRoom.fromJson(Map<String, dynamic> json) {
    return DailyRoom(
      room: (json['room'] ?? "").toString(),
      roomUrl: json['room_url'] as String,
      expiresAt: json['expires_at'] as int, // Unix seconds
      reused: json['reused'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'room_url': roomUrl,
      'expires_at': expiresAt, // keep as Unix seconds
      'reused': reused,
    };
  }

  /// Human-readable expiry time
  DateTime get expiresAtDateTime =>
      DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000, isUtc: true)
          .toLocal();

  /// Seconds left until expiration
  int get secondsLeft =>
      expiresAtDateTime.difference(DateTime.now()).inSeconds.clamp(0, 1 << 31);
}
