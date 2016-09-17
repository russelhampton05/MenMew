from rest_framework import serializers
from MenMew.models import *


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'salt', 'first_name', 'last_name')


class RestaurantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Restaurant
        address = AddressSerializer(many=False)
        fields = ('id', 'name', 'desc', 'address')


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = ('id', 'line1', 'line2', 'city', 'state', 'zip')
#TODO testing