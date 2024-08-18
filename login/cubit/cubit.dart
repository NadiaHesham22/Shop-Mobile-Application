import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/models/shopApp/shopApp_login_model.dart';
import 'package:my_first_project/modules/shop_app/login/cubit/states.dart';
import 'package:my_first_project/shared/network/end_points.dart';
import 'package:my_first_project/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{

  ShopLoginCubit():super(ShopLoginInitialStates());

  ShopLoginModel? loginModel;

  static ShopLoginCubit get(context)=>BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
}){
    emit(ShopLoginLoadingStates());
    DioHelper.postData(
      url:LOGIN,
      data:{
        'email':email,
        'password':password,
      },
    ).then((value){
      print(value.data);
      loginModel=ShopLoginModel.fromJson(value.data);
      print(loginModel?.data?.token);
      print(loginModel?.status);
      print(loginModel?.message);

      emit(ShopLoginSuccessStates(loginModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopLoginErrorStates(error.toString()));
    });
  }

}