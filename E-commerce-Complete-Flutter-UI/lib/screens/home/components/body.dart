import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}
const isOnboardingFinished = 'isOnboardingFinished';

class _BodyState extends State<Body> {
  @override
  Timer timer;
  bool isLoading = true;

  @override
  void initState() {
    gigDetails();
    super.initState();
  }

  Future gigDetails() async {
    demoProducts = [];
    print("In Gig");
    var url = Uri.parse("http://192.168.143.6:3000/api/getGigs");
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

      }),
    );

    if (response.statusCode == 200) {
      print("in reponse");
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      //print(response.body);
      final decoded = json.decode(response.body);
      decoded.forEach((gig) =>
          demoProducts.add(Product(id: int.parse(gig["gigid"]), images: [
            "assets/images/ps4_console_white_1.png",
            "assets/images/ps4_console_white_2.png",
            "assets/images/ps4_console_white_3.png",
            "assets/images/ps4_console_white_4.png",
          ], colors: [
            Color(0xFFF6625E),
            Color(0xFF836DB8),
            Color(0xFFDECB9C),
            Colors.white,
          ],
              price: double.parse(gig["payscale"]),
              title: gig["title"],
              lister: gig["lister"],
              description: gig["description"],
              nature: gig["nature"],
              payscale: double.parse(gig["payscale"]),
              dateExpiry: DateTime.tryParse(gig["dateExpiry"]),
              datePosted: DateTime.tryParse(gig["datePosted"]),
              category: gig["category"],
              requirements: gig["requirements"],
              overview: gig["overview"],
              street: gig["address"][0]["street"],
              landmark: gig["address"][0]["landmark"],
              district: gig["address"][0]["district"],
              state: gig["address"][0]["state"],
              country: gig["address"][0]["country"]))
      );
      _changePage();
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to create album.');
    }
    print(demoProducts.length);
  }

  _changePage() {
    Navigator.of(context).pushReplacement(
      // this is route builder without any animation
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container() : OnBoarding();
  }
}




  Widget build(BuildContext context) {
      return SafeArea(
      child: FutureBuilder(
        future: gigDetails(),
        builder: (BuildContext context, snapshot) {
          child:
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.sentiment_dissatisfied),
                      Text("Something went wrong ${snapshot.error}"),
                      FlatButton(
                        child: Text("Retry"),
                        onPressed: () {},
                      )
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(20)),
                    HomeHeader(),
                    SizedBox(height: getProportionateScreenWidth(10)),
                    DiscountBanner(),
                    Categories(),
                    SpecialOffers(),
                    SizedBox(height: getProportionateScreenWidth(30)),
                    PopularProducts(),
                    SizedBox(height: getProportionateScreenWidth(30)),
                  ],
                ),
              );
            default:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.sentiment_dissatisfied),
                    Text("Something went wrong ${snapshot.error}"),
                    FlatButton(
                      child: Text("Retry"),
                      onPressed: () {},
                    )
                  ],
                ),
              );
          }
        }
        )
      );
  }
}