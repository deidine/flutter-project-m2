class ScheduleRequest {
  int venueId;
   
String? begin,end;
  String date;
  int? txId;

  ScheduleRequest({required this.venueId,  this.begin,  this.end, required this.date, this.txId});
 
}
