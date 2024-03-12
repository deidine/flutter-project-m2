from django.db import models

from employees.models import EmployeeList
 

class Venue(models.Model):
    STUTS = (
        ('valid', 'Valid'),
        ('invalid', 'Invalid'),
        )
    venueId =  models.AutoField(primary_key=True)
    userId=models.ForeignKey(EmployeeList, on_delete=models.CASCADE)

    venueName = models.CharField(max_length=100)
    pricePerHour =models.IntegerField()
    location = models.CharField(max_length=200)
    category = models.CharField(max_length=100)
    rating = models.DecimalField(max_digits=3, decimal_places=1)
    image = models.ImageField(upload_to='venue_images/')

    status=models.CharField(max_length=23, choices=STUTS)
