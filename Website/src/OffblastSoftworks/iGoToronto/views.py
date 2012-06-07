from django.http import HttpResponseRedirect,HttpResponse
from django.http import Http404
from django.shortcuts import *
from django.template import RequestContext
from django.contrib.auth.models import User
from OffblastSoftworks.iGoToronto.models import *

def home(request):
	posts = Post.objects.order_by('-timestamp')
	return render_to_response('home.html',{'posts':posts})
	
def post(request,post_id):
  	p = Post.objects.get(pk=post_id)
  	return render_to_response('post.html',{'post':p})
  	    
def about(request):
    return render_to_response('about.html')
   
def next(request):
	return render_to_response('next.html')

def whatsNextiPhone(request):
    return render_to_response('iPhone/whatsNextiPhone.html')
