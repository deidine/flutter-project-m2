class ScheduleRequest {
  int venueId;
  String date;
  int? txId;

  ScheduleRequest({required this.venueId, required this.date, this.txId});
}
