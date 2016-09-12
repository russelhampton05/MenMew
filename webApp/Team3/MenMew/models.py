from django.db import models
from pygments.lexers import get_all_lexers
from pygments.styles import get_all_styles


# Create your models here.

class User(models.Model):
        id = models.IntegerField(primary_key=True, auto_created=True)
        email = models.CharField(max_length=45)
        password = models.CharField(max_length=128)
        salt = models.CharField(max_length=16)
        first_name = models.CharField(max_length=45)
        last_name = models.CharField(max_length=45)

        class Meta:
                ordering = ('id',)


