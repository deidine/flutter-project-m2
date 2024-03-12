from  venue.models import Venue
from django.db import models


class LocationCite(models.Model): 
     
    id=models.AutoField(primary_key=True)
    venueId=models.ForeignKey(Venue, on_delete=models.CASCADE)
    venueName=models.CharField(max_length=23 )
    address=models.CharField(max_length=23 )
    latitude=models.CharField(max_length=23 )
    longitude=models.CharField(max_length=23 )
