from django.shortcuts import render

# Create your views here.

from MenMew.models import *
from MenMew.serializers import *
from rest_framework import generics


class UserList(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class UserDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class TableList(generics.ListCreateAPIView):
    queryset = Table.objects.all()
    serializer_class = TableSerializer


class TableDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Table.objects.all()
    serializer_class = TableSerializer


class RestaurantList(generics.ListCreateAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer


class RestaurantDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer


class AddressList(generics.ListCreateAPIView):
    queryset = Address.objects.all()
    serializer_class = AddressSerializer


class AddressDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Address.objects.all()
    serializer_class = AddressSerializer


class TicketList(generics.ListCreateAPIView):
    queryset = Ticket.objects.all()
    serializer_class = TicketSerializer


class TicketDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Ticket.objects.all()
    serializer_class = TicketSerializer


class ServerList(generics.ListCreateAPIView):
    queryset = Server.objects.all()
    serializer_class = ServerSerializer


class ServerDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Server.objects.all()
    serializer_class = ServerSerializer


class IngredientCategoryList(generics.ListCreateAPIView):
    queryset = IngredientCategory.objects.all()
    serializer_class = IngredientCategorySerializer


class IngredientCategoryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = IngredientCategory.objects.all()
    serializer_class = IngredientCategorySerializer


class IngredientList(generics.ListCreateAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer


class IngredientDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Ingredient.objects.all()
    serializer_class = IngredientSerializer


class ItemOrderedList(generics.ListCreateAPIView):
    queryset = ItemOrdered.objects.all()
    serializer_class = ItemOrderedSerializer


class ItemOrderedDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemOrdered.objects.all()
    serializer_class = ItemOrderedSerializer


class ItemIngredientList(generics.ListCreateAPIView):
    queryset = ItemIngredient.objects.all()
    serializer_class = ItemIngredientSerializer


class ItemIngredientDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemIngredient.objects.all()
    serializer_class = ItemIngredientSerializer


class ItemList(generics.ListCreateAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer


class ItemDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Item.objects.all()
    serializer_class = ItemSerializer


class ItemCategoryList(generics.ListCreateAPIView):
    queryset = ItemCategory.objects.all()
    serializer_class = ItemCategorySerializer


class ItemCategoryDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemCategory.objects.all()
    serializer_class = ItemCategorySerializer


class ItemCustomizationList(generics.ListCreateAPIView):
    queryset = ItemCustomization.objects.all()
    serializer_class = ItemCustomizationSerializer


class ItemCustomizationDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ItemCustomization.objects.all()
    serializer_class = ItemCustomizationSerializer
