import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_first_project/modules/shop_app/login/shop_login_screen.dart';
import 'package:my_first_project/shared/components/components.dart';
import 'package:my_first_project/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../shared/styles/colors.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;
      BoardingModel({
        required this.image,
        required this.title,
        required this.body,
      });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //const OnBoardingScreen({super.key});
  var boardController=PageController();

  bool isLast=false;
  void submit(){
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if(value) {
        navigateAndfinish(context, ShopLoginScreen());
      }
    });
  }

  List<BoardingModel> boarding=[
    BoardingModel(
      image:'images/onBoarding1.jpg',
      title:'title1',
      body:'body1',
    ),
    BoardingModel(
      image:'images/onBoarding1.jpg',
      title:'title2',
      body:'body2',
    ),
    BoardingModel(
      image:'images/onBoarding1.jpg',
      title:'title3',
      body:'body3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: (){
              submit();
            },
            child: Text(
              'SKIP',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index){
                  if(index==boarding.length-1){
                    setState(() {
                      isLast=true;
                    });
                  }else{
                    setState(() {
                      isLast=false;
                    });
                  }
                },
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder:(context,index)=>BuildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5.0,
                    activeDotColor: defaultColor,

                  ),
                  count: boarding.length,
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: (){

                    if(isLast){
                      submit();
                    }else{
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child:Icon(
                      Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildBoardingItem(BoardingModel model)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image:AssetImage('${model.image}'),
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Text(
        '${model.title}',
        style:TextStyle(
          fontSize: 24.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
      Text(
        '${model.body}',
        style:TextStyle(
          fontSize: 14.0,
        ),
      ),
      SizedBox(
        height: 15.0,
      ),
    ],
  );
}
