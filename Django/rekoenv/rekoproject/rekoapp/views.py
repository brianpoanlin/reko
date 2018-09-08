from django.shortcuts import render
from django.contrib.auth.models import User
from rest_framework import generics, permissions, renderers, viewsets
from rest_framework.decorators import api_view, detail_route
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from rest_framework.parsers import FormParser,MultiPartParser
from rest_framework import status
from rekoapp import jobMatch
import json

from oauth2_provider.views.generic import ProtectedResourceView
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required

import rekoproject.settings as settings
from django.core import serializers
from django.shortcuts import render

from rest_framework.renderers import BaseRenderer

@api_view(['POST'])
#@login_required()
def predictAPI(request):
    if request.method == 'POST':
        res = jobMatch.jobMatch(request.data)
        if res != {}:
            return Response(res, status=status.HTTP_200_OK)
        else:
        return Response({'Error': 'Something went wrong :p'}, status=status.HTTP_400_BAD_REQUEST)
    else:
        return Response({'Error': 'Worng Method call'}, status=status.HTTP_400_BAD_REQUEST)
