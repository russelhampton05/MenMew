from rest_framework import serializers
from Team3.MenMew.models import User, LANGUAGE_CHOICES, STYLE_CHOICES

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'salt', 'first_name', 'last_name')


