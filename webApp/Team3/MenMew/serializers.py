from rest_framework import serializers
from MenMew.models import *


class UserSerializer(serializers.ModelSerializer):
    items_ordered = serializers.RelatedField(many=True, read_only=True)
    tickets = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'password', 'salt', 'first_name', 'tickets', 'last_name', 'items_ordered')


class TableSerializer(serializers.ModelSerializer):
    tickets = serializers.RelatedField(many=True, read_only=True)
    class Meta:
        model = Table
        fields = ('id','tickets', 'code')


class RestaurantSerializer(serializers.ModelSerializer):
    tables = serializers.RelatedField(many=True, read_only=True)
    servers = serializers.RelatedField(many=True, read_only=True)
    tickets = serializers.RelatedField(many=True, read_only=True)
    items = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = Restaurant
        fields = ('id', 'name', 'desc', 'tables', 'servers', 'tickets', 'items')


class AddressSerializer(serializers.ModelSerializer):
    restaurant = serializers.RelatedField(many=False, read_only=True)

    class Meta:
        model = Address
        fields = ('id', 'line1', 'line2', 'city', 'state', 'zip', 'restaurant')


class TicketSerializer(serializers.ModelSerializer):
    items_ordered = serializers

    class Meta:
        model = Ticket
        fields = ('id', 'items_ordered')


class ServerSerializer(serializers.ModelSerializer):
    tickets = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = Server
        fields = ('id', 'first_name', 'last_name', 'tickets', 'employee_id')


class IngredientCategorySerializer(serializers.ModelSerializer):
    ingredients = serializers.RelatedField(many=True, read_only=True)
    items = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = IngredientCategory
        ordering = ('id', 'name', 'ingredients', 'items')


class IngredientSerializer(serializers.ModelSerializer):
    item_customization = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = Ingredient
        ordering = ('id', 'name', 'item_customization')


class ItemOrderedSerializer(serializers.ModelSerializer):
    item_customization = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        Model = ItemOrdered
        ordering = ('id', 'item_customization')


class ItemIngredientSerializer(serializers.ModelSerializer):
    items = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        Model = ItemIngredient
        ordering = ('id', 'items')


class ItemSerializer(serializers.ModelSerializer):
    items_ordered = serializers.RelatedField(many=True, read_only=True)

    class Meta:
        model = Item
        ordering = ('id', 'items_ordered', 'name', 'desc', 'item_photo', 'item_price')


class ItemCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemCategory
        ordering = ('id', 'name')


class ItemCustomizationSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemCustomization
        ordering = ('id', 'add')
