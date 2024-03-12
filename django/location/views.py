import datetime
from django.http import JsonResponse
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import LocationCite
from .serializers import LocationSerializer 

# Create your views here.

@api_view(['GET', 'POST'])
def booking_list(request):
    if request.method == 'GET':
        cite = LocationCite.objects.all()
        serializer = LocationSerializer(cite, many=True)
        return JsonResponse(serializer.data,safe=False)
    