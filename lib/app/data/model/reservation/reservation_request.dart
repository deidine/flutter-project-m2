class ReservationRequesterr {
  final int? idTransaction;
  final int? venueId;
  final int? userId;
  final DateTime bookingTime;
  final DateTime beginTime;
  final DateTime endTime;
  final List<int> hours;
  final int totalPrice;

  ReservationRequesterr({
    this.idTransaction,
    this.venueId,
    this.userId,
    required this.beginTime,
    required this.endTime,
    required this.hours,
    required this.bookingTime,
    required this.totalPrice,
  });

  Map<String, dynamic> updateReservationToJson() {
    return {
      'idTransaction': idTransaction,
      'begin_time': beginTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'hours': hours,
      'bookingTime': bookingTime.millisecondsSinceEpoch,
      'totalPrice': totalPrice,
    };
  }

  Map<String, dynamic> createReservationToJson() {
    return {
      'venueId': venueId,
      'userId': userId,
      'begin_time': beginTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'hours': hours,
      'bookingTime': bookingTime.millisecondsSinceEpoch,
      'totalPrice': totalPrice,
    };
  }
}
