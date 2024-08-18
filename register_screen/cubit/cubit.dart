import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/models/shopApp/shopApp_login_model.dart';
import 'package:my_first_project/modules/shop_app/login/cubit/states.dart';
import 'package:my_first_project/modules/shop_app/register_screen/cubit/states.dart';
import 'package:my_first_project/shared/network/end_points.dart';
import 'package:my_first_project/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{

  ShopRegisterCubit():super(ShopRegisterInitialStates());

  ShopLoginModel? loginModel;

  static ShopRegisterCubit get(context)=>BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
}){
    emit(ShopRegisterLoadingStates());
    DioHelper.postData(
      url:REGISTER,
      data:{
        'name':name,
        'email':email,
        'password':password,
        'phone':phone,
      },
    ).then((value){
      print(value.data);
      loginModel=ShopLoginModel.fromJson(value.data);
      print(loginModel?.data?.token);
      print(loginModel?.status);
      print(loginModel?.message);

      emit(ShopRegisterSuccessStates(loginModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopRegisterErrorStates(error.toString()));
    });
  }

}