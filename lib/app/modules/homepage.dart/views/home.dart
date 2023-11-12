import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qouteapp/utils/loading_animation.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/qoutes.dart';
import '../../../../utils/savequote.dart';
import '../../../routes/app_pages.dart';
import '../../googlesignin.dart/controllers/googlesignin_dart_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthController authController = Get.find();
  List? imageList;
  int? imageNumber = 0;
  var accessKey = 'GU4stsyNLYx-oTtS07poTByUElPRQa-4aEOQFRrxeTU';

  @override
  void initState() {
    super.initState();
    getImagesFromUnsplash();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: imageList != null
          ? Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: BlurHash(
              key: ValueKey(
                  imageList![imageNumber!]['blur_hash']),
              hash: imageList![imageNumber!]['blur_hash'],
              duration: Duration(milliseconds: 500),
              image: imageList![imageNumber!]['urls']['regular'],
              curve: Curves.easeInOut,
              imageFit: BoxFit.cover,
            ),
          ),
          Container(
            width: width,
            height: height,
            color: Colors.black.withOpacity(0.6),
          ),
          Container(
            width: width,
            height: height,
            child: SafeArea(
              child: CarouselSlider.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index1, index2) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          quotesList[index1][kQuote],
                          style: kQuoteTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '- ${quotesList[index1][kAuthor]} -',
                        style: kAuthorTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    pageSnapping: true,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    onPageChanged: (index, value) {
                      HapticFeedback.lightImpact();
                      if (index >= 0 && index < quotesList.length) {
                        imageNumber = index;
                        setState(() {});
                      }
                    }),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 30,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await authController.signOut();
                    Get.toNamed(Routes.SPLASH);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.white, // Choose a sign-out color
                  ),
                  child: const Icon(Icons.logout, color: Colors.black),
                ),
              ],
            ),
          ),
          Positioned(
            top: 700,
            left: 20,
            right: 20,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.share),
              onPressed: () {
                if (imageList != null && imageNumber! >= 0 && imageNumber! < imageList!.length) {
                  shareQuote(
                    quotesList[imageNumber!][kQuote],
                    quotesList[imageNumber!][kAuthor],
                    imageList![imageNumber!]['urls']['regular'],
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 650,
            left: 30,
            right: 30,

            child: InkWell(
                onTap: () {
                  likeQuote();
                },

                child: const Icon(Icons.change_circle, color: Colors.white)),
          ),
          // Positioned(
          //   top: 750,
          //   left: 20,
          //   right: 20,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       IconButton(
          //         color: Colors.white,
          //         icon: const Icon(Icons.share),
          //         onPressed: () {
          //           if (imageList != null && imageNumber! >= 0 && imageNumber! < imageList!.length) {
          //             shareQuote(
          //               quotesList[imageNumber!][kQuote],
          //               quotesList[imageNumber!][kAuthor],
          //               imageList![imageNumber!]['urls']['regular'],
          //             );
          //           }
          //         },
          //       ),
          //       IconButton(
          //         color: Colors.white,
          //         icon: const Icon(Icons.save),
          //         onPressed: () {
          //           if (imageList != null && imageNumber! >= 0 && imageNumber! < imageList!.length) {
          //             viewSavedQuotes(
          //               quotesList[imageNumber!][kQuote],
          //               quotesList[imageNumber!][kAuthor],
          //               imageList![imageNumber!]['urls']['regular'],
          //             );
          //           }
          //         },
          //       ),
          //       IconButton(
          //         color: Colors.white,
          //         icon: const Icon(Icons.folder),
          //         onPressed: () {
          //           viewSavedQuotes(context, quotesList,  imageList![imageNumber!]['urls']['regular']);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      )
          : Container(
        width: width,
        height: height,
        color: Colors.black.withOpacity(0.6),
        child: const SizedBox(
          width: 100,
          height: 100,
          child: Center(child: LoadingAnimation()),
        ),
      ),
    );
  }

  void shareQuote(String quote, String author, String imageUrl) {
    Share.share('$quote\n\n- $author\n\nImage: $imageUrl');
  }


  void getImagesFromUnsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=nature&order_by=relevant&client_id=$accessKey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashData = json.decode(response.body);
    print(unsplashData);
    imageList = unsplashData['results'];
    setState(() {});
  }

  void likeQuote() {
    imageNumber = (imageNumber! + 1) % imageList!.length;
    setState(() {});
  }
}