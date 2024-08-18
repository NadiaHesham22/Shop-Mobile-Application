import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_first_project/modules/shop_app/search/cubit/cubit.dart';
import 'package:my_first_project/shared/components/components.dart';

import '../../../layout/shopApp/cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  //const SearchScreen({super.key});
    var formKey=GlobalKey<FormState>();
    var searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state){},
        builder: (context,state){
          return  Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      onSubmit: (String? text){
                        SearchCubit.get(context).search(text!);
                      },
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (String? value){
                          if(value!.isEmpty){
                            return 'Enter text to search';
                          }
                        },
                        label: 'Search',
                        prefix: Icons.search,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),

                    SizedBox(
                      height: 10.0,
                    ),
                   if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context,index)=>buildListProduct(SearchCubit.get(context).model!.data!.data![index],context,isOldPrice: false),
                        separatorBuilder: (context,index)=>myDivider(),
                        itemCount:SearchCubit.get(context).model!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
