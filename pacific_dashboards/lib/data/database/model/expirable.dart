mixin Expirable {
  int timestamp;

  bool isExpired() {
    if (timestamp == null) {
      return false;
    }

    final oldDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final todayDate = DateTime.now();
    final timePass = todayDate.difference(oldDate);
    return timePass.inHours > 12;
  }
}