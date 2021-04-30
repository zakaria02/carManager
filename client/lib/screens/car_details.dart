import 'package:cached_network_image/cached_network_image.dart';
import 'package:mycarmanager/Service/http.dart';
import 'package:mycarmanager/widgets/CircularProgressWidget.dart';

import '../Service/app_localizations.dart';
import '../model/car.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'edit_car.dart';

class CarDetailsScreen extends StatefulWidget {
  final Car car;
  CarDetailsScreen({this.car});
  @override
  State<StatefulWidget> createState() {
    return _CarDetailsState(car: car);
  }
}

class _CarDetailsState extends State<CarDetailsScreen> {
  Car car;
  _CarDetailsState({this.car});

  double width = 0, height = 0;
  final primaryColor = Color.fromARGB(250, 122, 30, 199);
  final secondaryColor = Colors.white;
  bool _uploading = false;

  Future<void> _getData() async {
    setState(() {
      _uploading = false;
    });
    await new Future.delayed(new Duration(seconds: 1));
    getData('images', id: car.id).then((images) {
      if (images.data.length > 0) {
        for (int i = 0; i < images.data.length; i++) {
          car.pictures.add(images.data[i]['link']);
        }
      }
      setState(() {
        _uploading = true;
      });
    });
  }

  List<Widget> _buildPictures() {
    List<Widget> imgs = [];
    for (int i = 0; i < car.pictures.length; i++) {
      imgs.add(Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2.0),
          color: Colors.white,
          shape: BoxShape.rectangle,
        ),
        child: CachedNetworkImage(
          imageUrl: car.pictures[i],
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ));
      imgs.add(SizedBox(
        height: 10,
      ));
    }
    return imgs;
  }

  @override
  void initState() {
    car.pictures = [];
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: width,
                  child: Image.asset("assets/images/appbar.png"),
                ),
                Center(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('car_details'),
                      style: TextStyle(
                        fontSize: 22,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Quicksand",
                      ),
                    ),
                  ],
                ))
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(width * 0.05, 2, width * 0.05, 2),
              child: Visibility(
                visible: _uploading,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        AppLocalizations.of(context).translate('inf') + " :",
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 20,
                      indent: 0,
                      endIndent: 320,
                      color: Colors.grey,
                      thickness: 5,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('immat') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.immatriculation}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                        SizedBox(
                          width: width * 0.05,
                        )
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('brand') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.marque}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('model') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.model}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('year') + " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.annee}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('country') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.pays}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('kilo') + " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.kilometrage} KM",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('color') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.couleur}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('options') +
                              " :",
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.options}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          AppLocalizations.of(context).translate('carIs'),
                          style: TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          "${car.isnew ? AppLocalizations.of(context).translate('new') : AppLocalizations.of(context).translate('old')}",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 10,
                      indent: 0,
                      endIndent: 20,
                      color: Colors.grey[700],
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        AppLocalizations.of(context).translate('imgs') + " :",
                        style: TextStyle(
                            fontFamily: "Quicksand",
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      height: 20,
                      indent: 0,
                      endIndent: 320,
                      color: Colors.black,
                      thickness: 5,
                    ),
                    Column(
                      children: _buildPictures(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: primaryColor),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryColor,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('edit'),
                          style: TextStyle(
                            color: secondaryColor,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditCarScreen(
                                car: car,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !_uploading,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.3,
                  ),
                  CircularProgressWidget(
                    message: AppLocalizations.of(context).translate('wait'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
