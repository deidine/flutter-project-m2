from django.utils import timezone
from .models import Booking
import datetime
from django.http import JsonResponse
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Booking
from .serializers import BookingSerializer 

@api_view(['GET', 'POST'])
def booking_list(request):
    if request.method == 'GET':
        bookings = Booking.objects.all()
        serializer = BookingSerializer(bookings, many=True)
        return JsonResponse(serializer.data,safe=False)
    
    elif request.method == 'POST':
        data2 = {
        "venueId": request.data.get('venueId'),
        "userId": request.data.get('userId'),
        "beginTime": request.data.get('beginTime'), 
        "endTime": request.data.get('endTime'), 
        "hours": request.data.get('hours'),
        "bookingTime": request.data.get('bookingTime'),
        "totalPrice": request.data.get('totalPrice'),
        # "transactionId": 1,
        "status":"invalid"
    } 
        bookings_within_range = Booking.objects.filter(venueId= request.data.get('venueId'), 
                                                       bookingTime=request.data.get('bookingTime'),
                                                       beginTime__gte=request.data.get('beginTime'),
                                                     
                                                       status="valid")
        bookings_within_range2 = Booking.objects.filter(venueId= request.data.get('venueId'), 
                                                       bookingTime=request.data.get('bookingTime'),
                                                       endTime__lte=request.data.get('endTime'),
                                                       status="valid")        
        bookings_within_range3 = Booking.objects.filter(venueId= request.data.get('venueId'), 
                                                       bookingTime=request.data.get('bookingTime'),
                                                    beginTime=request.data.get('beginTime'), 
                                                        status="valid")
        if bookings_within_range or bookings_within_range2 or bookings_within_range3 :
            print("The requested time slot overlaps with existing bookings")
            return Response("The requested time slot overlaps with existing bookings", status=status.HTTP_400_BAD_REQUEST)
    
    
        print(bookings_within_range)
        serializer = BookingSerializer(data=data2)
        # print(serializer)
        print(serializer.is_valid())
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        print(serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def booking_detail(request, pk):
    try:
        booking = Booking.objects.get(pk=pk)
    except Booking.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = BookingSerializer(booking)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = BookingSerializer(booking, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        booking.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
 
def bookingsVenuDate(request):
    venue_id = request.GET.get('venue')
    date = request.GET.get('date')

    if not venue_id or not date:
        return JsonResponse({'error': 'Both venue and date parameters are required.'}, status=400)

    try:
        venue_id = int(venue_id)
        # date=datetime.strptime(date, "%Y-%m-%d %H:%M:%S.%f").strftime("%Y-%m-%d %H:%M:%S.%f")
        date = datetime.datetime.fromtimestamp(int(date) / 1000)  # Convert timestamp to datetime object
    except (ValueError, OverflowError):
        return JsonResponse({'error': 'Invalid venue or date parameter.'}, status=400)

    bookings = Booking.objects.filter(venueId=venue_id, beginTime__date=date)

    # Serialize bookings data if needed
    data = [{'transactionId': booking.transactionId, 'userId': booking.userId, 'beginTime': booking.beginTime,
             'endTime': booking.endTime, 'hours': booking.hours, 'bookingTime': booking.bookingTime,
             'totalPrice': booking.totalPrice} for booking in bookings]
    return JsonResponse(data, safe=False)



def get_schedule(request):
    if request.method == 'GET':
        venue_id = request.GET.get('venue')
        date_str = request.GET.get('date')
        
        try:
            date = datetime.fromtimestamp(int(date_str) / 1000)  # Convert milliseconds since epoch to Python datetime
        except ValueError:
            return JsonResponse({'error': 'Invalid date'}, status=400)

        # Query bookings for the given venue and date
        bookings = Booking.objects.filter(venueId=venue_id, bookingTime__date=date.date())

        # Extract the hours from bookings
        hours = [booking.beginTime for booking in bookings]

        # Construct a list of available hours (e.g., all hours minus booked hours)
        all_hours = list(range(8, 20))  # Assuming working hours are from 8:00 to 20:00
        available_hours = [hour for hour in all_hours if hour not in hours]

        return JsonResponse({'hours': available_hours})
    else:
        return JsonResponse({'error': 'Method not allowed'}, status=405)
    
def get_booking(request,id):
 
    list=Booking.objects.filter(userId=id)
    serializer = BookingSerializer(list, many=True)

    # return JsonResponse({'employees': employees})
    return JsonResponse(serializer.data, safe=False) 

def get_booking_venue(request,venid):
 
    list=Booking.objects.filter(venueId=venid)
    serializer = BookingSerializer(list, many=True)

    # return JsonResponse({'employees': employees})
    return JsonResponse(serializer.data, safe=False) 



@api_view(['PUT'])
 
# @csrf_exempt
def update_status(request, transaction):
    try:
        booking = Booking.objects.get(transactionId=transaction)
    except Booking.DoesNotExist:
        return JsonResponse({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)
     
    if request.method == 'PUT':
        print("deien") 
        serializer = BookingSerializer(booking, data=request.data )
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        print(serializer.errors)
        
        return JsonResponse(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    else:
        return JsonResponse({'error': 'Method not allowed'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)

@api_view(['DELETE'])
def delete_booking(request, transaction):
    try:
        booking = Booking.objects.get(transactionId=transaction)
    except Booking.DoesNotExist:
        return JsonResponse({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'DELETE':
        booking.delete()
        return JsonResponse({'message': 'Booking deleted successfully'}, status=status.HTTP_204_NO_CONTENT)


 
# def search_bookings(request):
def search_bookings(request):
    # Get the search query (date) from the request data
    search_date_str = request.POST.get('date', '')

    # Parse the date string to a datetime object
    try:
        search_date = datetime.strptime(search_date_str, '%Y-%m-%d').date()
    except ValueError:
        return JsonResponse({'error': 'Invalid date format'}, status=400)

    # Perform the search based on the date
    # Filter bookings that have the same bookingTime as the search date
    bookings = Booking.objects.filter(bookingTime=search_date)

    # Serialize the search results
    serializer = BookingSerializer(bookings, many=True)

    # Return the serialized data as JSON response
    return JsonResponse(serializer.data, safe=False)
 
from datetime import datetime, time
def timeBetween(request):
    begin = request.GET.get('begin')
    date = request.GET.get('date')
    end = request.GET.get('end')
    venueId=request.GET.get('venueId') 


    # if begin ==None and end==None:
    #     bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date, status="valid")
    #     print("vide")
    # else:
    #     bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date, beginTime=begin, endTime=end,status="valid")
    # bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date,beginTime__gte=begin, endTime__lte=end,status="valid")
    bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date, status="valid")
    
    serializer = BookingSerializer(bookings_within_range, many=True)    
    return JsonResponse(serializer.data, safe=False)
 
#  from datetime import datetime, time
# def timeBetween(request):
#     begin = request.GET.get('begin')
#     date = request.GET.get('date')
#     end = request.GET.get('end')
#     venueId=request.GET.get('venueId') 

#     check = request.GET.get('check')
#     begin_time = datetime.strptime(begin, '%H:%M').time()
#     end_time = datetime.strptime(end, '%H:%M').time()
#     check_time = datetime.strptime(check, '%H:%M').time()

#     if begin_time <= check_time <= end_time:
#         print(True)

#     elif begin_time > end_time:
#         print(check_time >= begin_time or check_time <= end_time)
#     else:
#         print(False)

#     if begin ==None and end==None:
#         bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date, status="valid")
#         print("vide")
#     else:
#         bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date, beginTime=begin, endTime=end,status="valid")
#     # bookings_within_range = Booking.objects.filter(venueId=venueId, bookingTime=date,beginTime__gte=begin, endTime__lte=end,status="valid")
    
#     serializer = BookingSerializer(bookings_within_range, many=True)    
#     return JsonResponse(serializer.data, safe=False)
 
 