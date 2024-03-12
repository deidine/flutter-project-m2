from django.contrib import admin

from .models import LocationCite
@admin.register(LocationCite)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id','address',
                    'venueName')

 