import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simbanay_1/classes/clsApp.dart';

class clsBannerAdsController {
   BannerAd? bannerAd;
   bool isBannerAdLoaded = false;

   final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final adUnitIdLive = Platform.isAndroid
      ? 'ca-app-pub-7554455378496217/9066312517'
      : 'ca-app-pub-7554455378496217/2504003089';

  void initBanner(){
    if(isBannerAdLoaded==false){
      bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: clsApp.displayRealAds ? adUnitIdLive : adUnitId,
          listener: BannerAdListener(
              onAdFailedToLoad: (ad, error) {
                String value = clsApp.displayRealAds ? adUnitIdLive : adUnitId;
                print('ad Failed to load->'+ error.message + ' ' + value);
                ad.dispose();
              },
              onAdLoaded: (ad) {
                print('Ad Loaded perfectly!');
                isBannerAdLoaded = true;
              }),
          request: const AdRequest());
      //bannerAd!.load();
    }else{
      print('already loaded bannerAds, lets used the previous ads to resume it.');
      //bannerAd?.load();
    }

  }

  String appMode = 'trial';
  void loadThemeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      appMode = prefs.getString('appMode') ?? clsApp.DEFAULT_APP_MODE;
  }

  Widget getBannerAds(){
    initBanner();
    return Text('not');
    return
      isBannerAdLoaded
        ? SafeArea(
      child: Column(
          children: [
            Center(child: Text('Advertisement', style: TextStyle(fontSize: 10.0),)),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: AdWidget(
                  ad: bannerAd!
              ),
            ),
          ]),
    ) : SizedBox(height: 0,);
  }

  Widget getBannerAdsLarge(){
    initBanner();
    return Text('not');
    return  isBannerAdLoaded
        ? SafeArea(
      child: Column(
          children: [
            Center(child: Text('Advertisement', style: TextStyle(fontSize: 10.0),)),
            SizedBox(
              width: double.infinity,
              height: bannerAd?.size.height.toDouble(),
              child: AdWidget(
                  ad: bannerAd!
              ),
            ),
          ]),
    ) : SizedBox(height: 0,);
  }



}