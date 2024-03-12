 
import 'package:mapgoog/app/data/model/user/user_response.dart';
import 'package:mapgoog/app/data/model/venue/venue_response.dart';
import 'package:mapgoog/app/data/repository/booking_repository.dart';

import '../model/reservation/reservation_response.dart';
import '../model/reservation/schedule_request.dart';

abstract class BookingService {
  static Future<List<int>> getSchedule(ScheduleRequest request) async {
    return await BookingRepository.getSchedule(request);
  }

  static Future<List<UserResponse>> getReservationListByUser() async {
    return await BookingRepository.getUsers();
  }
    static Future<List<ReservationResponse>> getReservationListByVenueId(
      int benueId) async {
    return await BookingRepository.getReservationListByVenueId(benueId);
  }
   static Future<List<ReservationResponse>> searchReservationListByDate(
      String date) async {
    return await BookingRepository.sendSearchQuery(date);
  }

  static Future<void> cancelReservation(String idTransaction) async {
    BookingRepository.cancelReservation(idTransaction);
  }

  static Future<void> createReservation(ReservationResponse request) async {
    BookingRepository.createReservation(request);
  }

  static Future<void> updateReservation(ReservationResponse request) async {
    BookingRepository.updateReservation(request);
  }

  static Future<List<int>> getScheduleExcludeTxId(
      ScheduleRequest request) async {
    return await BookingRepository.getScheduleExcludeTxId(request);
  }

  static updateBookingStatus(ReservationResponse booking,int id) async {
  try {
     await BookingRepository.updateStatus(booking,id);
  } catch (e) {
    // Handle the error properly
    print('Failed to update user: $e'); 
  }
}

  static delete(int id) async{
    try {
     await BookingRepository.delete(id);
  } catch (e) {
    // Handle the error properly
    print('Failed to delete booking: $e'); 
  }
  }

}
