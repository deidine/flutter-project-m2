from django.urls import path
from . import views

urlpatterns = [
    path('api/location/', views.booking_list),
     
]