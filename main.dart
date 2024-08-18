import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_first_project/layout/shopApp/cubit/cubit.dart';
import 'package:my_first_project/layout/shopApp/shop_layout.dart';
import 'package:my_first_project/modules/home/home_screen.dart';
import 'package:my_first_project/modules/messenger/messenger_screen.dart';
import 'package:my_first_project/modules/shop_app/login/shop_login_screen.dart';
import 'package:my_first_project/modules/shop_app/on_boarding/onboarding_screen.dart';
import 'package:my_first_project/shared/components/constants.dart';
import 'package:my_first_project/shared/cubit/cubit.dart';
import 'package:my_first_project/shared/cubit/states.dart';
import 'package:my_first_project/shared/network/local/cache_helper.dart';
import 'package:my_first_project/shared/network/remote/dio_helper.dart';
import 'package:my_first_project/shared/styles/themes.dart';

import 'layout/NewsApp/cubit/cubit.dart';
import 'layout/NewsApp/news_layout.dart';
import 'layout/TodoApp/Todo_home_layout.dart';
import 'modules/bmi/BMI_calculator.dart';
import 'modules/login/login_screen.dart';
import 'modules/shop_app/register_screen/shop_register_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark=CacheHelper.getData(key: 'isDark');

  bool? onBoarding=CacheHelper.getData(key: 'onBoarding');
  token=CacheHelper.getData(key: 'token');
print(token);
  print('IAM HERE ${onBoarding}');

  Widget widget;
  if(onBoarding!=null){
    if(token!=null) widget=ShopLayout();
    else widget=ShopLoginScreen();
  }else {
    widget=OnBoardingScreen();
  }

  //runApp(const MyApp(isDark));
  runApp(MyApp(
      isDark: isDark,
    startWidget: widget,
  ));

}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  const MyApp({Key? key, required this.isDark,required this.startWidget}) : super(key: key);
  final bool? isDark;
  final Widget startWidget;

  //MyApp(this.isDark);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>NewsCubit()..getBusiness()..getSports()..getScience(),),
        BlocProvider(create: (BuildContext context)=>AppCubit()..changeMode(fromShared:isDark,)),
        BlocProvider(create: (BuildContext context)=>ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()),


      ],
      child: BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark:ThemeMode.light,
            home:startWidget,
          );
        },
      ),
    );
  }
}



