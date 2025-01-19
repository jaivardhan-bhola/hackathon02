import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:piwot2/components/weatherContainer.dart';
import 'package:url_launcher/url_launcher.dart';

class Schemecarousel extends StatefulWidget {
  const Schemecarousel({super.key});

  @override
  State<Schemecarousel> createState() => _SchemecarouselState();
}

class _SchemecarouselState extends State<Schemecarousel> {
  var box = Hive.box('appBox');
  var host = 'http://${dotenv.env['HOST']}:${dotenv.env['PORT']}';
  Map<dynamic, dynamic>? schemes;

  @override
  void initState() {
    super.initState();
    schemes = Map<dynamic, dynamic>.from(box.get('schemes', defaultValue: {}));
  }

  int _current = 0;
  void urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    ;
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        if (schemes != null && schemes!.isNotEmpty)
          CarouselSlider(
            items: [
              Weathercontainer(), // Add WeatherContainer as the first item
              ...schemes!.entries.map((entry) => GestureDetector(
                    onTap: (){
                      urlLauncher(entry.key);
                    },
                child: Container(
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          child: Image.network(host + entry.value,
                              fit: BoxFit.cover, width: screenWidth * 0.8),
                        ),
                      ),
                    ),
              ))
            ],
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(schemes!.length + 1, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

