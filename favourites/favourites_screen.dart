import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/models/shopApp/favorites_model.dart';

import '../../../layout/shopApp/cubit/cubit.dart';
import '../../../layout/shopApp/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesStates,
          builder:(context)=> ListView.separated(
            itemBuilder: (context,index)=>buildListProduct(ShopCubit.get(context).favoriteModel!.data!.data![index].product!,context),
            separatorBuilder: (context,index)=>myDivider(),
            itemCount:ShopCubit.get(context).favoriteModel!.data!.data!.length,
          ),
          fallback:(context)=> Center(child: CircularProgressIndicator()),
        );
      },
    );
  }


}
