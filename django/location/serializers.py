from rest_framework import serializers
from .models import LocationCite

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = LocationCite
        fields = ('id','address','venueName','venueId','latitude','longitude' )
 