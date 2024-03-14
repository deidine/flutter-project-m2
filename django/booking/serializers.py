from rest_framework import serializers
from .models import Booking

class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = ('venueId','userId','beginTime','endTime','hours','bookingTime','totalPrice','status','transactionId')
# class BookingSerializerCreate(serializers.ModelSerializer):
    
#     class Meta:
#         model = Booking
#         fields = ('venueId','userId','beginTime','endTime','hours','bookingTime','totalPrice' ) 


# class BookingSerializer(serializers.ModelSerializer):
#     begin_time = serializers.CharField()
#     end_time = serializers.CharField()

#     class Meta:
#         model = Booking
#         fields = ['transactionId', 'venueId', 'userId', 'begin_time', 'end_time', 'hours', 'bookingTime', 'totalPrice', 'status']
