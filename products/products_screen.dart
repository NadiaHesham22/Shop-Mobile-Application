//import 'dart:js';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/layout/shopApp/cubit/cubit.dart';
import 'package:my_first_project/layout/shopApp/cubit/states.dart';
import 'package:my_first_project/models/shopApp/categories_model.dart';
import 'package:my_first_project/shared/components/components.dart';
import 'package:my_first_project/shared/styles/colors.dart';

import '../../../models/shopApp/home_model/home_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){
        if(state is ShopSuccessChangeFavoritesState){
          if(state.model.status==false){
            showToast(
              text:state.model!.message!,
              state: ToastStates.ERROR,
            );
          }

        }
      },
      builder: (context,state){
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel !=null && ShopCubit.get(context).categoriesModel !=null,
          builder:(context)=>productsBuilder(ShopCubit.get(context).homeModel,ShopCubit.get(context).categoriesModel,context),
          fallback: (context)=>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel? model, CategoriesModel? categoryModel,context)=>SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items:model?.data?.banners.map((e) =>
               Image(
                  image: NetworkImage('${e.image}'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
            ).toList(),

            options: CarouselOptions(
              height: 250.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 100.0,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder:(context,index)=>BuildCategoryItem(categoryModel!.data!.data![index]),
                    separatorBuilder:(context,index)=> SizedBox(
                      width: 10.0,
                    ),
                    itemCount: categoryModel!.data!.data!.length,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'New Products',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1/1.75,
            children: List.generate(
                model!.data!.products.length,
               (index)=> buildGridProduct(model!.data!.products[index],context),
            ),

          ),
        ),

      ],
    ),
  );

  Widget BuildCategoryItem(DataModel model)=>Container(
    height: 100.0,
    width: 100.0,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image:NetworkImage(
            model!.image!,
          ),
          height: 100.0,
          width: 100.0,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(.8,),
          width: double.infinity,
          child: Text(
            model!.name!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildGridProduct(ProductsModel model,context)=>Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image:NetworkImage(model.image!),
              width: double.infinity,
              height: 200.0,
            ),
            if(model.discount!=0)
            Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 5.0,),
              child: Text(
                'DISCOUNT',
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1.3,
                  fontSize: 14.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${model!.price!.round()}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount!=0)
                  Text(
                    '${model!.old_price!.round()}',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: ()
                    {
                      ShopCubit.get(context).changeFavorite(model!.id!);

                    },
                    icon: CircleAvatar(
                      backgroundColor: (model != null &&model.id!=null && ShopCubit.get(context).favorites![model.id]!)
                          ? defaultColor
                          : Colors.grey,
                      radius: 15.0,
                      child: Icon(
                          Icons.favorite_border,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
