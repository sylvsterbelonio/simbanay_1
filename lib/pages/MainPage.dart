
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simbanay_1/pages/SettingsStateless.dart';
import 'package:simbanay_1/pages/booklet.dart';
import 'package:simbanay_1/defaults/defaults.dart';
import 'package:simbanay_1/pages/Settings.dart';
import 'package:simbanay_1/classes/Themes.dart';
import 'package:simbanay_1/classes/clsApp.dart';
import 'package:simbanay_1/widgets/ads/BannerAds.dart';
import 'package:simbanay_1/widgets/ads/clsBannerAdsController.dart';

var indexClicked = 0;
var appBarTitle = 'Booklet';
GlobalKey gk= GlobalKey();


class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}



class _MainPageState extends State<MainPage>{


  late List<Widget> pages = [];
  late String appMode='trial';
  //late Widget bannerAds = BannerAds();

  void loadAppPurchase() async{

    final bool available = await InAppPurchase.instance.isAvailable();
    if (available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      print('yes');
    }else{
      print('sorry no');
    }

    // Set literals require Dart 2.2. Alternatively, use
// `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
    const Set<String> _kIds = <String>{'Premium'};
    final ProductDetailsResponse response =
    await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print('wala jud');
    }
    List<ProductDetails> products = response.productDetails;

    setState(() {
      print('===>' + products.toString());
    });
  }

  @override
  void initState(){
   // bannerAdsController.initBanner();
    loadAppPurchase();
    initTheme();
    pages = [
      const Center(child: Booklet(),
      ),
      Container(child: SettingsStateless(colorTheme: colorTheme,  selectedColor: loadThemeData,appMode: appMode),
      ),
      const Center(child: Text('exit'),
      )
    ];
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void initTheme() async{
    setState(() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      colorTheme = prefs.getString('colorThemes') ?? 'Blue';
      appMode = prefs.getString('appMode') ?? clsApp.DEFAULT_APP_MODE;
    });
  }

  void loadThemeData(String selectedColor) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('colorThemes', selectedColor);
    appMode = prefs.getString('appMode') ?? clsApp.DEFAULT_APP_MODE;
    colorTheme = selectedColor;


    pages = [
      const Center(child: Booklet(),
      ),
      Container(child: SettingsStateless(colorTheme: colorTheme,  selectedColor: loadThemeData,appMode:appMode),
      ),
      const Center(child: Text('exit'),
      )
    ];


    setState(() {
      //colorTheme = prefs.getString('colorThemes') ?? 'Red';
    });
  }

  @override
  Widget build(BuildContext context) {

    VoidCallback clickDrawer(int index){
      return () {
        setState((){
          indexClicked=index;
          Navigator.pop(context);
          if(index==0)
            appBarTitle = 'Booklet';
          else
            appBarTitle = 'Settings';
        });
      };
    }

    Future<bool> _onBackPressed() async{
      return (await showDialog(
          context: context,
          builder: (context)=> AlertDialog(
            title: const Text('Do you really want to exit the app?',style: TextStyle(fontSize: 16.0),),
            actions: <Widget>[
              TextButton(
                  onPressed: ()=>Navigator.pop(context,false),
                  child:  Text('No',style: TextStyle(color: myThemes.getColor(colorTheme)),)),
              TextButton(
                  onPressed: ()=>Navigator.pop(context,true),
                  child:  Text('Yes',style: TextStyle(color: myThemes.getColor(colorTheme)),)),
            ],
          )
      )
      );
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: myThemes.getColor(colorTheme),
        ),
        body: pages[indexClicked],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text('SIMBANAY',style: (TextStyle(fontWeight: FontWeight.bold)),),
                accountEmail: const Text('Reach (Series: One)'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset('assets/images/raw_icon.png'),
                  ),
                ),
                decoration: BoxDecoration(
                    color: myThemes.getColor(colorTheme),
                    image: DecorationImage(
                        image: AssetImage(''),
                        fit: BoxFit.cover)
                ),
              ),
              ListTile(
                  leading: Icon(
                      Defaults.drawerItemIcon[0],
                      color: indexClicked ==0 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),
                  title: Text(
                    Defaults.drawerItemText[0],
                    style: TextStyle(color: indexClicked ==0 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),),
                  onTap: clickDrawer(0)
              ),
              ListTile(
                  leading: Icon(
                      Defaults.drawerItemIcon[1],
                      color: indexClicked ==1 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),
                  title: Text(
                    Defaults.drawerItemText[1],
                    style: TextStyle(color: indexClicked ==1 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),),
                  onTap: clickDrawer(1)
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                    Defaults.drawerItemIcon[2],
                    color: indexClicked ==2 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),
                title: Text(
                  Defaults.drawerItemText[2],
                  style: TextStyle(color: indexClicked ==2 ? myThemes.getColor(colorTheme) : Defaults.drawerItemColor),),
                onTap: (){
                  setState(() {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context)=> AlertDialog(
                          title: const Text('Do you really want to exit the app?',style: TextStyle(fontSize: 16.0),),
                          actions: <Widget>[
                            TextButton(
                                onPressed: ()=>Navigator.pop(context,false),
                                child:  Text('No',style: TextStyle(color: myThemes.getColor(colorTheme)),)),
                            TextButton(
                                onPressed: ()=>Navigator.pop(context,true),
                                child:  Text('Yes',style: TextStyle(color: myThemes.getColor(colorTheme)),)),
                          ],
                        )
                    );
                  });
                },
              )
            ],
          ),
        ),
      ),
    );

  }
}