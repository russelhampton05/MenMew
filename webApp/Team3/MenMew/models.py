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


class Table(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    restaurant_id = models.ForeignKey(Restaurant, related_name="tables")
    code = models.CharField(max_length=45)

    class Meta:
        ordering = ('id',)


class Restaurant(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    name = models.CharField(max_length=45)
    desc = models.CharField(max_length=255)
    address = models.ForeignKey(Address, related_name='restaurant')

    class Meta:
        ordering = ('id',)


class Address(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    line1 = models.CharField(max_length=45)
    line2 = models.CharField(max_length=45)
    city = models.CharField(max_length=45)
    state = models.CharField(max_length=2)
    zip = models.PositiveIntegerField(max_length=5)

    class Meta:
        ordering = ('id',)


class Ticket(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    restaurant_id = models.ForeignKey(Restaurant, "tickets")
    table_id = models.ForeignKey(Table)
    server_id = models.ForeignKey(Server, related_name='tickets')
    user_id = models.ForeignKey(User, related_name='user_id')

    class Meta:
        ordering = ('id',)


class Server(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    first_name = models.CharField(max_length=45)
    last_name = models.CharField(max_length=45)
    employee_id = models.CharField(max_length=45)
    restaurant_id = models.ForeignKey(Restaurant)

    class Meta:
        ordering = ('id',)


class IngredientCategory(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    name = models.CharField(max_length=45)

    class Meta:
        ordering = ('id',)


class Ingredient(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    name = models.CharField(max_length=45)
    category = models.ForeignKey(IngredientCategory, "ingredients")

    class Meta:
        ordering = ('id',)


class ItemOrdered(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    user_id = models.ForeignKey(Ticket, related_name= "items_ordered")
    ticket_id = models.ForeignKey(User)
    item_id = models.ForeignKey(Item)


class ItemIngredient(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)

    class Meta:
        ordering = ('id',)


class Item(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    name = models.CharField(max_length=45)
    desc = models.CharField(max_length=255)
    restaurant_id = models.ForeignKey(Restaurant, related_name="items")
    item_category_id = models.ForeignKey(ItemCategory)
    item_photo = models.CharField(max_length=255)
    item_price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        ordering = ('id',)


class ItemCategory(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    name = models.CharField(max_length=45)

    class Meta:
        ordering = ('id',)


class ItemCustomization(models.Model):
    id = models.IntegerField(primary_key=True, auto_created=True)
    item_ordered_id = models.ForeignKey(ItemOrdered, related_name="item_customization")
    ingredient_id = models.ForeignKey(Ingredient, "item_customization")
    add = models.BinaryField()

    class Meta:
        ordering = ('id',)
