import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mycarmanager/Service/http.dart';
import 'package:mycarmanager/widgets/CircularProgressWidget.dart';
import 'car_details.dart';
import 'add_car.dart';
import '../Service/app_localizations.dart';
import '../model/car.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';

class CarsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarsListScreenState();
  }
}

class _CarsListScreenState extends State<CarsListScreen> {
  double width = 0, height = 0;
  final primaryColor = Color.fromARGB(250, 122, 30, 199);
  final secondaryColor = Colors.white;
  bool _uploading = false;
  TextEditingController _textController = TextEditingController();

  var allCars = [];
  var items = [];

  void filterSearch(String query) async {
    var customersSearchList = allCars;
    if (query.isNotEmpty) {
      var customersListData = [];
      customersSearchList.forEach((item) {
        var customer = Car.fromJson(item);
        if (customer.immatriculation
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            customer.marque.toLowerCase().contains(query.toLowerCase())) {
          customersListData.add(item);
        }
      });
      setState(() {
        items = [];
        items.addAll(customersListData);
      });
      return;
    } else {
      setState(() {
        items = [];
        items = allCars;
      });
    }
  }

  Future<void> _getData() async {
    setState(() {
      _uploading = false;
    });
    await new Future.delayed(new Duration(seconds: 1));
    getData('cars').then((cars) {
      setState(() {
        allCars = cars.data;
        items = allCars;
        _uploading = true;
      });
    });
  }

  _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    _checkConnection().then((isConnected) {
      if (isConnected) {
        _getData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content:
                Text(AppLocalizations.of(context).translate('internet_error')),
            backgroundColor: primaryColor));
      }
    });
    super.initState();
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22, color: secondaryColor),
      backgroundColor: primaryColor,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
          child: Icon(
            Icons.add,
            color: secondaryColor,
          ),
          backgroundColor: primaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddCarScreen(),
              ),
            );
          },
          label: AppLocalizations.of(context).translate('add_car'),
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
          labelBackgroundColor: primaryColor,
        ),
      ],
    );
  }

  _showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget yesButton = TextButton(
        child: Text(AppLocalizations.of(context).translate('yes')),
        onPressed: () {
          deleteData("cars", id).then((value) {
            if (value.ok) {
              _getData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content:
                      Text(AppLocalizations.of(context).translate('delete_ok')),
                  backgroundColor: primaryColor));
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content: Text(
                      AppLocalizations.of(context).translate('delete_err')),
                  backgroundColor: primaryColor));
            }
          });
        });
    Widget noButton = TextButton(
      child: Text(AppLocalizations.of(context).translate('no')),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context).translate('delete')),
      content: Text(AppLocalizations.of(context).translate('sure')),
      actions: [
        yesButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: _getFAB(),
      body: Builder(
        builder: (context) => Column(
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
                      AppLocalizations.of(context).translate('all_cars'),
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
            Padding(
              padding:
                  EdgeInsets.fromLTRB(width * 8 / 100, 0, width * 8 / 100, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filterSearch(value);
                  });
                },
                controller: _textController,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate('search') + '...',
                  labelText: AppLocalizations.of(context).translate('search'),
                  labelStyle: TextStyle(
                    color: primaryColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
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
            Visibility(
              visible: _uploading,
              child: Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  strokeWidth: 3,
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        Car car = Car.fromJson(items[i]);
                        return Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 8 / 100, 0, width * 8 / 100, 0),
                          width: width,
                          child: Card(
                            color: Colors.deepPurple[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: AutoSizeText(
                                '${car.immatriculation}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: AutoSizeText(
                                  '${car.marque}, ${car.model}\n${car.kilometrage} KM'),
                              trailing: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _showAlertDialog(context, car.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CarDetailsScreen(
                                      car: car,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  onRefresh: _getData,
                ),
              ),
            ),
            Visibility(
              visible: _uploading,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: AutoSizeText(
                    AppLocalizations.of(context).translate('swipe'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
