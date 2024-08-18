import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/layout/shopApp/cubit/states.dart';
import 'package:my_first_project/models/shopApp/categories_model.dart';
import 'package:my_first_project/models/shopApp/favorites_model.dart';
import 'package:my_first_project/models/shopApp/home_model/home_model.dart';
import 'package:my_first_project/models/shopApp/shopApp_login_model.dart';
import 'package:my_first_project/modules/settings_screen/settings_screen.dart';
import 'package:my_first_project/modules/shop_app/categories/categories_screen.dart';
import 'package:my_first_project/modules/shop_app/favourites/favourites_screen.dart';
import 'package:my_first_project/modules/shop_app/products/products_screen.dart';
import 'package:my_first_project/modules/shop_app/settings/settings_screen.dart';
import 'package:my_first_project/shared/components/constants.dart';
import 'package:my_first_project/shared/network/remote/dio_helper.dart';

import '../../../models/shopApp/change_favorites_model.dart';
import '../../../shared/network/end_points.dart';


class ShopCubit extends Cubit<ShopStates>{

  ShopCubit(): super(ShopInitialStates());

  static ShopCubit get (context)=>BlocProvider.of(context);

  int currentIndex=0;

List<Widget> bottomScreens=[
  ProductsScreen(),
  CategoriesScreen(),
  FavouritesScreen(),
  SettingsScreenShop(),
];

void changeBottom(int index){
  currentIndex=index;
  emit(ShopChangeBottomNav());
}

HomeModel? homeModel;

Map <int,bool>favorites={};

void getHomeData(){
  emit(ShopLoadingHomeData());

  DioHelper.getData(
     url: HOME,
    token: token,
  ).then((value){
print(token.toString());
    homeModel=HomeModel.fromJson(value.data);
    
    // print(homeModel?.data?.banners.toString());
    // print(homeModel?.status);
    // print('oooh ${homeModel?.data?.products.toString()}');

    homeModel?.data?.products?.forEach((element) {
      favorites.addAll({
        element!.id!:element!.in_favorites!,
      });
    });
    print(favorites.toString());

    emit(ShopSuccessHomeData());
  }).catchError((error){
    print('heey ${error.toString()}');
    emit(ShopErrorHomeData());

  });

}

  CategoriesModel? categoriesModel;

  void getCategories(){

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,

    ).then((value){

      categoriesModel=CategoriesModel.fromJson(value.data);


      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      print('heey ${error.toString()}');
      emit(ShopErrorCategoriesStates());

    });

  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorite(int productID){

    favorites[productID]=!favorites[productID]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id':productID,
        },
      token: token,
    ).then((value) {
      changeFavoritesModel=ChangeFavoritesModel.fromJson(value.data);

      print(value.data);

      if(changeFavoritesModel!.status==false){
        favorites[productID]=!favorites[productID]!;
      }else{
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));

    }).catchError((error){
      favorites[productID]=!favorites[productID]!;
      emit(ShopErrorChangeFavroitesStates());

    });
  }

  FavoriteModel? favoriteModel;

  void getFavorites(){
    emit(ShopLoadingGetFavoritesStates());

    DioHelper.getData(
      url: FAVORITES,
      token: token,

    ).then((value){

      favoriteModel=FavoriteModel.fromJson(value.data);
       print('yes ${value.data.toString()}');

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error){
      print('heey ${error.toString()}');
      emit(ShopErrorGetFavoritesStates());

    });

  }

  ShopLoginModel? userModel;

  void getUserData(){
    emit(ShopLoadingUserDataStates());

    DioHelper.getData(
      url: PROFILE,
      token: token,

    ).then((value){

      userModel=ShopLoginModel.fromJson(value.data);
      print('name is ${userModel!.data!.name!}');

      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error){
      print('heey ${error.toString()}');
      emit(ShopErrorUserDataStates());

    });

  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
}){
    emit(ShopLoadingUpdateUserStates());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,

      },

    ).then((value){

      userModel=ShopLoginModel.fromJson(value.data);
      print('name is ${userModel!.data!.name!}');

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error){
      print('heey ${error.toString()}');
      emit(ShopErrorUpdateUserStates());

    });

  }
}