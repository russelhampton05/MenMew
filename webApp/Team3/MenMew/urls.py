from django.conf.urls import url
from MenMew import views
from rest_framework.urlpatterns import format_suffix_patterns
urlpatterns = [
    url(r'^users/$', views.UserList.as_view()),
    url(r'^users/(?P<pk>[0-9]+)/$', views.UserDetail.as_view()),
    url(r'^tables/$', views.TableList.as_view()),
    url(r'^tables/(?P<pk>[0-9]+)/$', views.TableDetail.as_view()),
    url(r'^restaurants/$', views.RestaurantList.as_view()),
    url(r'^restaurants/(?P<pk>[0-9]+)/$', views.RestaurantDetail.as_view()),
    url(r'^addresses/$', views.AddressList.as_view()),
    url(r'^addresses/(?P<pk>[0-9]+)/$', views.AddressDetailDetail.as_view()),
    url(r'^tickets/$', views.TicketList.as_view()),
    url(r'^tickets/(?P<pk>[0-9]+)/$', views.TicketDetail.as_view()),
    url(r'^servers/$', views.ServerList.as_view()),
    url(r'^servers/(?P<pk>[0-9]+)/$', views.ServerDetail.as_view()),
    url(r'^ingredientcategories/$', views.IngredientCategoryList.as_view()),
    url(r'^ingredientcategories/(?P<pk>[0-9]+)/$', views.IngredientCategoryDetailDetail.as_view()),
    url(r'^ingredients/$', views.IngredientList.as_view()),
    url(r'^ingredients/(?P<pk>[0-9]+)/$', views.IngredientDetail.as_view()),
    url(r'^itemsordered/$', views.ItemOrderedListList.as_view()),
    url(r'^itemsordered/(?P<pk>[0-9]+)/$', views.ItemOrderedDetail.as_view()),
    url(r'^itemingredients/$', views.ItemIngredientListList.as_view()),
    url(r'^itemingredients/(?P<pk>[0-9]+)/$', views.ItemIngredientDetail.as_view()),
    url(r'^items/$', views.ItemList.as_view()),
    url(r'^items/(?P<pk>[0-9]+)/$', views.ItemDetail.as_view()),
    url(r'^itemcategories/$', views.ItemCategoryList.as_view()),
    url(r'^itemcategories/(?P<pk>[0-9]+)/$', views.ItemCategoryDetail.as_view()),
    url(r'^itemcustomizations/$', views.ItemCustomizationList.as_view()),
    url(r'^itemcustomizations/(?P<pk>[0-9]+)/$', views.ItemCustomizationDetail.as_view()),

]

urlpatterns = format_suffix_patterns(urlpatterns)