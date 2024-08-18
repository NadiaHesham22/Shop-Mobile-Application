import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_first_project/layout/shopApp/shop_layout.dart';
import 'package:my_first_project/modules/shop_app/login/cubit/cubit.dart';
import 'package:my_first_project/modules/shop_app/on_boarding/onboarding_screen.dart';
import 'package:my_first_project/shared/components/components.dart';
import 'package:my_first_project/shared/network/local/cache_helper.dart';
import 'package:my_first_project/shared/styles/colors.dart';


import '../../../shared/components/constants.dart';
import '../register_screen/shop_register_screen.dart';
import 'cubit/states.dart';

class ShopLoginScreen extends StatelessWidget {
  //const ShopLoginScreen({super.key});
  var formKey=GlobalKey<FormState>();

  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
       listener: (context,state){
         if(state is ShopLoginSuccessStates){
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
                         'LOGIN',
                         style: Theme.of(context).textTheme.headline4?.copyWith(
                           color: Colors.black,
                         ),
                       ),
                       Text(
                         'login now to browse our hot offers',
                         style: Theme.of(context).textTheme.bodyText1?.copyWith(
                           color: Colors.grey,

                         ),
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
                       ConditionalBuilder(
                         condition:state is ! ShopLoginLoadingStates ,
                         builder: (context)=>defaultButton(
                           function: (){
                             if(formKey.currentState!.validate()){
                               ShopLoginCubit.get(context).userLogin(
                                 email: emailController.text,
                                 password: passwordController.text,
                               );
                             }
                           },
                           text: 'Login',
                           color: defaultColor,
                         ),
                         fallback: (context)=>Center(child: CircularProgressIndicator()),

                       ),
                       SizedBox(
                         height: 15.0,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             'Do not have an account? ',
                           ),
                           defaultTextButton(
                             function: (){
                               navigatetTo(context,ShopRegisterScreen());
                             },
                             text:'register',
                           ),
                         ],
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
