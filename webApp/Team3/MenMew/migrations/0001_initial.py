# -*- coding: utf-8 -*-
# Generated by Django 1.10.1 on 2016-09-25 03:09
from __future__ import unicode_literals

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Address',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('line1', models.CharField(max_length=45)),
                ('line2', models.CharField(max_length=45)),
                ('city', models.CharField(max_length=45)),
                ('state', models.CharField(max_length=2)),
                ('zip', models.PositiveIntegerField(max_length=5)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='Ingredient',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=45)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='IngredientCategory',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=45)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='Item',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=45)),
                ('desc', models.CharField(max_length=255)),
                ('item_photo', models.CharField(max_length=255)),
                ('item_price', models.DecimalField(decimal_places=2, max_digits=10)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='ItemCategory',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=45)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='ItemCustomization',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('add', models.BinaryField()),
                ('ingredient_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='item_customization', to='MenMew.Ingredient')),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='ItemIngredient',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='ItemOrdered',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('item_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='MenMew.Item')),
            ],
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=45)),
                ('desc', models.CharField(max_length=255)),
                ('address', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='restaurant', to='MenMew.Address')),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='Server',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('first_name', models.CharField(max_length=45)),
                ('last_name', models.CharField(max_length=45)),
                ('employee_id', models.CharField(max_length=45)),
                ('restaurant_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='MenMew.Restaurant')),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='Table',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('code', models.CharField(max_length=45)),
                ('restaurant_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tables', to='MenMew.Restaurant')),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='Ticket',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('restaurant_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tickets', to='MenMew.Restaurant')),
                ('server_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tickets', to='MenMew.Server')),
                ('table_id', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tickets', to='MenMew.Table')),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.IntegerField(auto_created=True, primary_key=True, serialize=False)),
                ('email', models.CharField(max_length=45)),
                ('password', models.CharField(max_length=128)),
                ('salt', models.CharField(max_length=16)),
                ('first_name', models.CharField(max_length=45)),
                ('last_name', models.CharField(max_length=45)),
            ],
            options={
                'ordering': ('id',),
            },
        ),
        migrations.AddField(
            model_name='ticket',
            name='user_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tickets', to='MenMew.User'),
        ),
        migrations.AddField(
            model_name='itemordered',
            name='ticket_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='MenMew.User'),
        ),
        migrations.AddField(
            model_name='itemordered',
            name='user_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items_ordered', to='MenMew.Ticket'),
        ),
        migrations.AddField(
            model_name='itemcustomization',
            name='item_ordered_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='item_customization', to='MenMew.ItemOrdered'),
        ),
        migrations.AddField(
            model_name='item',
            name='item_category_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='MenMew.ItemCategory'),
        ),
        migrations.AddField(
            model_name='item',
            name='restaurant_id',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='MenMew.Restaurant'),
        ),
        migrations.AddField(
            model_name='ingredient',
            name='category',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='ingredients', to='MenMew.IngredientCategory'),
        ),
    ]
