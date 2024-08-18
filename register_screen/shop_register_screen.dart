import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/modules/shop_app/register_screen/cubit/cubit.dart';

import '../../../layout/shopApp/shop_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/colors.dart';
import '../login/cubit/cubit.dart';
import '../login/cubit/states.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {
 // const ShopRegisterScreen({super.key});

  var formKey=GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var nameController=TextEditingController();
  var phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShopRegisterCubit(),
      child:BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener: (context ,state){
          if(state is ShopRegisterSuccessStates){
            if(state.loginModel.status==true){
              CacheHelper.saveData(key: 'token',
                  value: state.loginModel.data?.token
              ).then((value) {

                token=state.loginModel.data?.token;
                navigateAndfinish(context,
                  ShopLayout(),
                );
              });

            }else{
              showToast(
                text: state?.loginModel?.message ?? 'No message available',
                state: ToastStates.ERROR,
              );
            }
          }

        },
        builder: (context,state){
         return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,

                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'please enter your name';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          suffix: Icons.visibility_outlined,
                          suffixPressed: (){
                            print('pressed');
                          },
                          controller: passwordController,

                          type: TextInputType.visiblePassword,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validate: (value){
                            if(value!.isEmpty){
                              return 'please enter your number';
                            }
                          },
                          label: 'Phone ',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition:state is ! ShopRegisterLoadingStates,
                          builder: (context)=>defaultButton(
                            function: (){
                              if(formKey.currentState!.validate()){
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            text: 'Register',
                            color: defaultColor,
                          ),
                          fallback: (context)=>Center(child: CircularProgressIndicator()),

                        ),
                        SizedBox(
                          height: 15.0,
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}
