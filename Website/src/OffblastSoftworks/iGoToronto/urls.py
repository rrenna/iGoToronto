from django.conf.urls.defaults import *
from django.contrib.auth.views import login

urlpatterns = patterns('OffblastSoftworks.iGoToronto.views',
     (r'^about$', 'about'),
     (r'^next$', 'next'),
     (r'post/(?P<post_id>\d+)/$','post'),
     #(r'login$', login, {'template_name': 'login.html'}),
     (r'whatsNext$', 'whatsNextiPhone'),
     (r'$', 'home')
)