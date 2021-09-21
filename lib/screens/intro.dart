import 'package:flutter/material.dart';
import 'package:homecook/screens/login.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';

import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  static const routeName = '/intro-screen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "MUSEUM",
        styleTitle: TextStyle(
          color: Colors.blueAccent,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Ye indulgence unreserved connection alteration appearance",
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
        pathImage: "assets/images/girl.png",
      ),
    );
    slides.add(
      Slide(
        title: "COFFEE SHOP",
        styleTitle: TextStyle(
          color: Colors.blueAccent,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        styleDescription: TextStyle(
          color: Colors.blueGrey,
          fontSize: 20.0,
          fontFamily: 'Raleway',
        ),
        pathImage: "assets/images/kitchen.png",
      ),
    );
    slides.add(Slide());
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.blueAccent,
      size: 35.0,
    );
  }

  Widget renderSkipBtn() {
    return Text(
      'Skip',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = List();
    for (int i = 0; i < slides.length - 1; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Center(
              child: Image.asset(
                currentSlide.pathImage,
                width: 250.0,
                height: 250.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            child: Text(
              currentSlide.title,
              style: currentSlide.styleTitle,
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(top: 30.0),
          ),
          Container(
            child: Text(
              currentSlide.description,
              style: currentSlide.styleDescription,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
          ),
        ],
      ));
    }
    tabs.add(LoginScreen());
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        slides: this.slides,
        renderSkipBtn: this.renderSkipBtn(),
        // colorSkipBtn: Colors.blueAccent,
        renderNextBtn: this.renderNextBtn(),
        colorDot: Colors.blueAccent,
        sizeDot: 12.0,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
        listCustomTabs: this.renderListCustomTabs(),
        backgroundColorAllSlides: Colors.white,
        refFuncGoToTab: (refFunc) {
          this.goToTab = refFunc;
        },
        // shouldHideStatusBar: false,
        onTabChangeCompleted: this.onTabChangeCompleted,
      ),
    );
  }
}
