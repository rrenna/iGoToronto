from django.db import models

#Blogging and News models
class Post(models.Model): 
	title = models.CharField(max_length=128)
	preview = models.CharField(max_length=256)
	#author = models.ForeignKeyField(
	body = models.TextField()
	timestamp = models.DateTimeField()
	class Meta:
		get_latest_by = "timestamp"

#Data models
class CabCompany(models.Model):
	name = models.CharField(max_length=128)
	positiveRatings = models.IntegerField()
	negativeRatings = models.IntegerField()
	address = models.CharField(max_length=256)
	latitude = models.FloatField()
	longitude = models.FloatField()
	phone = models.CharField(max_length=24)
	
	
	
	
	 
	
