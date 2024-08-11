import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unsung_memer/controller/fetchMeme.dart';
import 'package:unsung_memer/controller/saveMyData.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  String imgUrl = "";
  int? memeNo;
  bool isLoading = true;
  bool isButtonLoading = false;
  int targetMeme = 100;
  late AnimationController _controller;

  void UpdateImg() async {
    setState(() {
      isLoading = true;
      isButtonLoading = true;
    });
    _controller.repeat(reverse: true);
    String getImgUrl = await FetchMeme.fetchMeme();
    setState(() {
      imgUrl = getImgUrl;
      isLoading = false;
      isButtonLoading = false;
    });
    _controller.stop();
  }

  GetInitMemeNo() async {
    memeNo = await SaveMyData.fetchData() ?? 0;
    if (memeNo! > 100) {
      targetMeme = 500;
    } else if (memeNo! > 500) {
      targetMeme = 1000;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    GetInitMemeNo();
    UpdateImg();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double fontSizeFactor =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 1.5
                : 1.0;
        double imageHeight =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 500
                : 350;
        double imageWidth =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 600
                : MediaQuery.of(context).size.width;
        double buttonHeight =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 70
                : 50;
        double buttonWidth =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 180
                : 118;
        double kunalAnimationHeight =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 40
                : 40;
        double linkIconSize =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet
                ? 40
                : 25;

        return Scaffold(
          body: Stack(children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.1,
                child: Lottie.asset('lib/assets/Animation - 1721215209651.json',
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromARGB(131, 255, 255, 255)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Meme #${memeNo.toString()}",
                      style: TextStyle(
                          fontFamily: "Lexend",
                          color: const Color.fromARGB(255, 7, 139, 255),
                          fontSize: 35 * fontSizeFactor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Target ${targetMeme} Memes",
                      style: TextStyle(
                          fontFamily: "Lexend",
                          color: Color.fromARGB(255, 255, 128, 0),
                          fontSize: 35 * fontSizeFactor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    isLoading
                        ? Container(
                            height: imageHeight,
                            width: imageWidth,
                            child: Center(
                              child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: LottieBuilder.asset(
                                      'lib/assets/loading.json',
                                      repeat: true)),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: imgUrl,
                            height: imageHeight,
                            width: imageWidth,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: Lottie.asset('lib/assets/loading.json',
                                  height: 200, width: 200),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                    SizedBox(height: 30),
                    Container(
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(18, 194, 233, 10),
                            Color.fromRGBO(
                              196,
                              113,
                              237,
                              10,
                            ),
                            Color.fromRGBO(246, 79, 89, 10),
                          ])),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isButtonLoading = true;
                          });
                          await SaveMyData.saveData(memeNo! + 1);
                          GetInitMemeNo();
                          UpdateImg();
                        },
                        child: Container(
                          height: buttonHeight,
                          width: buttonWidth,
                          child: Center(
                            child: isButtonLoading
                                ? Lottie.asset("lib/assets/car.json",
                                    height: buttonHeight,
                                    width: buttonWidth,
                                    repeat: true)
                                : Text(
                                    "Update Meme",
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 17 * fontSizeFactor,
                                        fontFamily: "Lexend",
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1.5),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "App created by:",
                      style: TextStyle(
                          fontFamily: "Lexend",
                          fontSize: 13 * fontSizeFactor,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.link,
                          size: linkIconSize,
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            launchUrlString(
                                'https://www.linkedin.com/in/kunal-prajapat-487079263/');
                          },
                          child: Text(
                            "Kunal",
                            style: TextStyle(
                                fontSize: 25 * fontSizeFactor,
                                fontFamily: 'Lexend',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 5),
                        Lottie.asset('lib/assets/Kunal.json',
                            height: kunalAnimationHeight),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
