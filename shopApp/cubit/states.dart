import 'package:my_first_project/models/shopApp/change_favorites_model.dart';
import 'package:my_first_project/models/shopApp/shopApp_login_model.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates{}

class ShopChangeBottomNav extends ShopStates{}

class ShopLoadingHomeData extends ShopStates{}

class ShopSuccessHomeData extends ShopStates{}

class ShopErrorHomeData extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesStates extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopChangeFavoritesState extends ShopStates{}

class ShopErrorChangeFavroitesStates extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesStates extends ShopStates{}

class ShopLoadingGetFavoritesStates extends ShopStates{}

class ShopSuccessUserDataState extends ShopStates{
  final ShopLoginModel loginModel;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataStates extends ShopStates{}

class ShopLoadingUserDataStates extends ShopStates{}

//
class ShopSuccessUpdateUserState extends ShopStates{
  final ShopLoginModel loginModel;

  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopErrorUpdateUserStates extends ShopStates{}

class ShopLoadingUpdateUserStates extends ShopStates{}