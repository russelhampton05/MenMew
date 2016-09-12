from rest_framework import serializers
from MenMew.models import User
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'salt', 'first_name', 'last_name')


