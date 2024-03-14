import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simbanay_1/classes/lesson.dart';
import 'package:simbanay_1/widgets/LessonCardTemplate.dart';
import 'package:simbanay_1/pages/Settings.dart';
import 'package:simbanay_1/classes/Themes.dart';
import 'package:simbanay_1/classes/clsApp.dart';
import 'package:simbanay_1/widgets/ads/RewardedInterstitialAds.dart';

import '../widgets/ads/AppOpenAds.dart';
import '../widgets/ads/BannerAds.dart';
import '../widgets/ads/InterstitialAds.dart';
import '../widgets/ads/RewardedAds.dart';

class Booklet extends StatefulWidget {
  const Booklet({super.key});
  @override
  State<Booklet> createState() => _BookletState();
}

class _BookletState extends State<Booklet>{


  bool bannerAdsLoaded = false;
  Widget bannerAds = BannerAds();
  int adClickCount = 0;

  List<Lesson> lesson = [];
  String appMode = 'trial';

  void loadThemeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      colorTheme = prefs.getString('colorThemes') ?? 'Blue';
      appMode = prefs.getString('appMode') ??  clsApp.DEFAULT_APP_MODE;
      adClickCount = prefs.getInt('adClickCount') ??  0;

      lesson = [
        Lesson(lessonNo: '1',title: 'SALVATION',subTitle: 'Kaluwasan',color: colorTheme),
        Lesson(lessonNo: '2',title: 'ASSURANCE OF SALVATION',subTitle: 'Kasiguruhan sa Kaluwasan',color: colorTheme),
        Lesson(lessonNo: '3',title: 'REPENTANCE',subTitle: 'Paghinulsol',color: colorTheme),
        Lesson(lessonNo: '4',title: 'FORGIVENESS',subTitle: 'Pagpasaylo',color: colorTheme),
        Lesson(lessonNo: '5',title: 'NEW BIRTH',subTitle: 'Bag-ong Pagkatawo',color: colorTheme),
        Lesson(lessonNo: '6',title: 'LORDSHIP',subTitle: 'Ang Pagka Agalon ni Hesus',color: colorTheme),
        Lesson(lessonNo: '7',title: 'WORD',subTitle: 'Pulong sa Dios',color: colorTheme),
        Lesson(lessonNo: '8',title: 'WORSHIP',subTitle: 'Pagsimba',color: colorTheme),
        Lesson(lessonNo: '9',title: 'PRAYER',subTitle: 'Pag ampo',color: colorTheme),
        Lesson(lessonNo: '10',title: 'FELLOWSHIP',subTitle: 'Panagtigum',color: colorTheme),
        Lesson(lessonNo: '11',title: 'WITNESS',subTitle: 'Pagsangyaw sa Uban',color: colorTheme),
        Lesson(lessonNo: '12',title: 'BAPTISM',subTitle: 'Bautismo sa Tubig',color: colorTheme),
      ];
    });
  }
  void updateAdClickCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('adClickCount', adClickCount);
  }

  @override
  void initState() {
    // TODO: implement initState
    loadThemeData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
            child: Column(
              children:[

              Column(
                children: lesson.map((e) => LessonCardTemplate(
                    lesson: e,
                    appMode: appMode,
                    openLesson: (){
                      setState(() {
                        print(e.lessonNo);
                        if(appMode=='trial'){

                          InterstitialAds.load();

                          if(e.lessonNo=='1' || e.lessonNo=='2' || e.lessonNo=='3' || e.lessonNo=='4' || e.lessonNo=='5'){
                            Navigator.pushNamed(
                                context, '/lesson_details',arguments: {
                              'lessonNo' : e.lessonNo,
                              'title': e.title
                            });
                          }else{
                            showDialog(
                                context: context,
                                builder: (context)=> AlertDialog(
                                  title: const Text('Sorry, the app is a trial version. To unlock this, you need to buy the full version of this app.',style: TextStyle(fontSize: 16.0),),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: ()=>Navigator.pop(context,false),
                                        child:  Text('Ok',style: TextStyle(color: myThemes.getColor(colorTheme)),)),
                                  ],
                                )
                            );
                          }
                        }else{

                          //InterstitialAds.load();
                          //RewardedInterstitialAds.loadAd();
                          setState(() {

                            adClickCount++;
                            if(adClickCount>5){
                              adClickCount=0;
                              AppOpenAds.loadAd();
                            }
                            updateAdClickCount();
                            print('adCount=' + adClickCount.toString());

                            Navigator.pushNamed(
                                context, '/lesson_details',arguments: {
                              'lessonNo' : e.lessonNo,
                              'title': e.title
                            });
                          });

                        }


                      });
                    }
                )).toList(),
              ),

              ],

        ),
    ),
          ),
          BannerAds()])
    );

  }
}