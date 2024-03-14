
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:simbanay_1/classes/Themes.dart';

import '../widgets/ads/BannerAds.dart';
import 'Settings.dart';
class LessonDetails extends StatefulWidget {
  const LessonDetails({super.key});

  @override
  State<LessonDetails> createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {

  int _currentFontSize = 1;
  bool _fontDecrease = true;
  bool _fontIncrease = true;

  @override
  void initState() {
    reloadTheme();
    super.initState();
  }

  void reloadTheme() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentFontSize = prefs.getInt('fontSize') ?? 1;
    if(_currentFontSize==0) _fontDecrease=false;
    else if(_currentFontSize==2) _fontIncrease=false;
    colorTheme = prefs.getString('colorThemes') ?? 'Blue';
    setState(() {});
  }
  void updateFontSize() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', _currentFontSize);

  }


  List<String> availableFontSize = ['_sm','','_lg'];
  String getLessonFile(String lessonNo){

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    String fileName='';
    switch(lessonNo) {
      case '1':
        fileName = !isDarkMode ? "sim_01_salvation"+availableFontSize[_currentFontSize]+".html" : "sim_01_dark_salvation"+availableFontSize[_currentFontSize]+".html";
        break;
      case '2':
        fileName = !isDarkMode ? "sim_02_assurance_of_salvation"+availableFontSize[_currentFontSize]+".html" : "sim_02_dark_assurance_of_salvation"+availableFontSize[_currentFontSize]+".html";
        break;
      case '3':
        fileName = !isDarkMode ? "sim_03_repentance"+availableFontSize[_currentFontSize]+".html" : "sim_03_dark_repentance"+availableFontSize[_currentFontSize]+".html";
        break;
      case '4':
        fileName = !isDarkMode ? "sim_04_forgiveness"+availableFontSize[_currentFontSize]+".html" : "sim_04_dark_forgiveness"+availableFontSize[_currentFontSize]+".html";
        break;
      case '5':
        fileName = !isDarkMode ? "sim_05_new_birth"+availableFontSize[_currentFontSize]+".html" : "sim_05_dark_new_birth"+availableFontSize[_currentFontSize]+".html";
        break;
      case '6':
        fileName = !isDarkMode ? "sim_06_lordship"+availableFontSize[_currentFontSize]+".html" : "sim_06_dark_lordship"+availableFontSize[_currentFontSize]+".html";
        break;
      case '7':
        fileName = !isDarkMode ? "sim_07_word"+availableFontSize[_currentFontSize]+".html" : "sim_07_dark_word"+availableFontSize[_currentFontSize]+".html";
        break;
      case '8':
        fileName = !isDarkMode ? "sim_08_worship"+availableFontSize[_currentFontSize]+".html" : "sim_08_dark_worship"+availableFontSize[_currentFontSize]+".html";
        break;
      case '9':
        fileName = !isDarkMode ? "sim_09_prayer"+availableFontSize[_currentFontSize]+".html" : "sim_09_dark_prayer"+availableFontSize[_currentFontSize]+".html";
        break;
      case '10':
        fileName =  !isDarkMode ? "sim_10_fellowship"+availableFontSize[_currentFontSize]+".html" : "sim_10_dark_fellowship"+availableFontSize[_currentFontSize]+".html";
        break;
      case '11':
        fileName =  !isDarkMode ? "sim_11_witness"+availableFontSize[_currentFontSize]+".html" : "sim_11_dark_witness"+availableFontSize[_currentFontSize]+".html";
        break;
      case '12':
        fileName =  !isDarkMode ? "sim_12_baptism"+availableFontSize[_currentFontSize]+".html" : "sim_12_dark_baptism"+availableFontSize[_currentFontSize]+".html";
        break;
    }
    return fileName;
  }
  late final WebViewController controller;

  @override
  Widget build(BuildContext context) {


    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String,String>;
    final String lessonNo = routeArgs['lessonNo'].toString();
    final String title = routeArgs['title'].toString();
    late final WebViewController _controller;
    String fileName='';

    fileName = getLessonFile(lessonNo);

      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(true)
        ..runJavaScript('<script>setFontSize('+ availableFontSize[_currentFontSize] +');</script>')
        ..loadFlutterAsset('assets/files/'+fileName);

      // #docregion platform_features
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      // #enddocregion platform_features
      _controller = controller;



    return Scaffold(
      appBar: AppBar(
      title:  Text(lessonNo + ': ' + title),
      actions: [
        IconButton(onPressed: _fontDecrease ?  (){
        setState(() {
            int index = _currentFontSize - 1;
              if (index <= 0) {
                _currentFontSize = 0;
                _fontDecrease = false;
              } else {
                _fontIncrease=true;
                _currentFontSize--;
              }
            print(_currentFontSize);
            updateFontSize();
            });
            }: null,
            icon: Icon(Icons.text_decrease,
            color:  _fontDecrease ? Colors.white: Colors.grey[400])),

        IconButton(onPressed: _fontIncrease ? (){
          setState(() {
            int index = _currentFontSize + 1;
            if(index>1){
              _currentFontSize = 2;
              _fontIncrease = false;
            }else {
              _currentFontSize++;
              _fontDecrease=true;
            }
            });
          print(_currentFontSize);
          updateFontSize();
        }: null,
            icon: Icon(Icons.text_increase,
            color: _fontIncrease ? Colors.white: Colors.grey[400])),
      ],
      backgroundColor: myThemes.getColor(colorTheme),
      ),
      body:  Column(children: [
        Expanded(child: WebViewWidget(controller: _controller,)),
        BannerAds()
      ]),
    );
  }
}
