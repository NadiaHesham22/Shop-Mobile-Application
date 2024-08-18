import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/layout/shopApp/cubit/cubit.dart';
import 'package:my_first_project/layout/shopApp/cubit/states.dart';
import 'package:my_first_project/shared/components/components.dart';
import 'package:my_first_project/shared/components/constants.dart';
import 'package:my_first_project/shared/styles/colors.dart';

class SettingsScreenShop extends StatelessWidget {
 // const SettingsScreen({super.key});

  var formKey=GlobalKey<FormState>();
  var nameController =TextEditingController();
  var emailController =TextEditingController();
  var phoneController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
     listener: (context,state)
     {
     },
     builder: (context,state){
       var model=ShopCubit.get(context).userModel;

       nameController.text=model!.data!.name!;
       emailController.text=model!.data!.email!;
       phoneController.text=model!.data!.phone!;

       return  ConditionalBuilder(
         condition: ShopCubit.get(context).userModel !=null,
         builder: (context)=>Padding(
           padding: const EdgeInsets.all(20.0),
           child: Form(
             key: formKey,
             child: Column(
               children: [
                 // if(state is ShopLoadingUpdateUserStates)
                 //   LinearProgressIndicator(),

                 defaultFormField(
                   controller: nameController,
                   type: TextInputType.name,
                   validate: (String? value){
                     if(value!.isEmpty){
                       return 'name must not be empty';
                     }
                     return null;
                   },
                   label: 'Name',
                   prefix: Icons.person,
                 ),

                 SizedBox(
                   height: 12.0,
                 ),

                 defaultFormField(
                   controller: emailController,
                   type: TextInputType.emailAddress,
                   validate: (String? value){
                     if(value!.isEmpty){
                       return 'email must not be empty';
                     }
                     return null;
                   },
                   label: 'Email Address',
                   prefix: Icons.email,
                 ),

                 SizedBox(
                   height: 12.0,
                 ),

                 defaultFormField(
                   controller: phoneController,
                   type: TextInputType.phone,
                   validate: (String? value){
                     if(value!.isEmpty){
                       return 'phone must not be empty';
                     }
                     return null;
                   },
                   label: 'Phone',
                   prefix: Icons.phone,
                 ),
                 SizedBox(
                   height: 10.0,
                 ),
                 defaultButton(
                   color: defaultColor,
                     function: (){
                     if(formKey.currentState!.validate()){
                       ShopCubit.get(context).updateUserData(
                         name: nameController.text,
                         email: emailController.text,
                         phone: phoneController.text,
                       );
                     }
                     },
                     text: 'Update',
                 ),
                 SizedBox(
                   height: 10.0,
                 ),
                 defaultButton(
                   color: defaultColor,
                   function: (){
                     SignOut(context);
                   },
                   text: 'Logout',
                 ),

               ],
             ),
           ),
         ),
         fallback: (context)=>Center(child: CircularProgressIndicator()),
       );
     },
    );

  }
}
