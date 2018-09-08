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

from django.http import HttpResponse
from django.contrib.auth.decorators import login_required

import rekoproject.settings as settings
from django.core import serializers
from django.shortcuts import render

from rest_framework.renderers import BaseRenderer

@api_view(['POST'])
#@login_required()
def jobMatchApi(request):
    if request.method == 'POST':
        res = jobMatch.jobMatchApi(request.data)
        if res != {}:
            return Response(res, status=status.HTTP_200_OK)
        else:
            return Response({'Error': 'Something went wrong :p'}, status=status.HTTP_400_BAD_REQUEST)
    else:
        return Response({'Error': 'Worng Method call'}, status=status.HTTP_400_BAD_REQUEST)

class BinaryFileRenderer(BaseRenderer):
    media_type = 'application/octet-stream'
    format = None
    charset = None
    render_style = 'binary'

    def render(self, data, media_type=None, renderer_context=None):
        return data
