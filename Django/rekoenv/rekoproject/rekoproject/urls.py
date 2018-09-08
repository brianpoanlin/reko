from django.conf.urls import include, url
from rest_framework.schemas import get_schema_view
from rest_framework.documentation import include_docs_urls

from django.contrib.auth.models import User
from rest_framework import routers, serializers, viewsets
from django.conf import settings

# Serializers define the API representation.
class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email')

# ViewSets define the view behavior.
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Routers provide an easy way of automatically determining the URL conf.
router = routers.DefaultRouter()
router.register(r'users', UserViewSet)

API_TITLE = 'Job Match API'
API_DESCRIPTION = 'A Web API for Job Matching.'
schema_view = get_schema_view(title=API_TITLE)

urlpatterns = [
    # url(r'^splashbi/', include('worker.urls')),
    # url(r'^', include(router.urls)),
    # url(r'^accounts/', include('django.contrib.auth.urls')),
    # url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    # url(r'^schema/$', schema_view),
    # url(r'^docs/', include_docs_urls(title=API_TITLE, description=API_DESCRIPTION)),
    # url(r'^o/', include('oauth2_provider.urls', namespace='oauth2_provider'))
    #url(r'^o/', include('oauth2_endpoint_views', namespace="oauth2_provider")),
]
