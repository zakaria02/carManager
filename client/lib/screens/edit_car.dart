import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycarmanager/Service/http.dart';
import 'package:mycarmanager/Service/uploadPictures.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/car.dart';
import 'package:flutter/material.dart';
import '../Service/app_localizations.dart';

class EditCarScreen extends StatefulWidget {
  final Car car;
  EditCarScreen({this.car});
  @override
  State<StatefulWidget> createState() {
    return _EditCarState(car: car);
  }
}

enum SingingCharacter { isNew, isOld }

class _EditCarState extends State<EditCarScreen> with TickerProviderStateMixin {
  double width = 0, height = 0;
  final formKey = new GlobalKey<FormState>();
  Car car;
  _EditCarState({this.car});

  final primaryColor = Color.fromARGB(250, 122, 30, 199);
  final secondaryColor = Colors.white;

  String _immatriculation,
      _marque,
      _model,
      _annee,
      _pays,
      _kilometrage,
      _couleur,
      _options;
  bool _state = false, _isNew = false;
  SingingCharacter sc = SingingCharacter.isOld;
  File _img1, _img2;
  final picker = ImagePicker();
  UploadPicture up;

  void animateButton() {
    var controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    controller.forward();
    setState(() {
      _state = true;
    });
  }

  _uploadPic(File img) async {
    await up.upload(img);
  }

  void _validateInputs() {
    _checkConnection().then((isConnected) {
      if (isConnected) {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          animateButton();
          car.immatriculation = _immatriculation;
          car.marque = _marque;
          car.model = _model;
          car.annee = int.parse(_annee);
          car.pays = _pays;
          car.kilometrage = double.parse(_kilometrage);
          car.couleur = _couleur;
          car.options = _options;
          car.isnew = _isNew;
          updateData("cars", car.id, car).then((value) {
            if (value.ok) {
              if (_img1 != null || _img2 != null) {
                if (_img1 != null) {
                  up = new UploadPicture(carId: car.id);
                  up.createFolder().then((val) {
                    _uploadPic(_img1);
                  });
                }
                if (_img2 != null) {
                  up = new UploadPicture(carId: car.id);
                  up.createFolder().then((val) {
                    _uploadPic(_img2);
                  });
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                    content:
                        Text(AppLocalizations.of(context).translate('edit_ok')),
                    backgroundColor: primaryColor));
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content:
                      Text(AppLocalizations.of(context).translate('edit_ok')),
                  backgroundColor: primaryColor));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content:
                      Text(AppLocalizations.of(context).translate('edit_err')),
                  backgroundColor: primaryColor));
            }
            setState(() {
              _state = false;
            });
            Navigator.popUntil(context, (route) => route.isFirst);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content:
                Text(AppLocalizations.of(context).translate('internet_error')),
            backgroundColor: primaryColor));
      }
    });
  }

  Widget _buildButtonChild() {
    if (!_state) {
      return Text(
        AppLocalizations.of(context).translate('save'),
        style: TextStyle(
          color: secondaryColor,
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      );
    } else {
      return SizedBox(
        height: 26.0,
        width: 26.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
        ),
      );
    }
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

  _takePictureUsingGallery(BuildContext context, int ind) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (ind == 0) {
          _img1 = File(pickedFile.path);
        } else if (ind == 1) {
          _img2 = File(pickedFile.path);
        }
      }
    });
    Navigator.of(context).pop();
  }

  _openGallery(BuildContext context, int ind) async {
    bool isGaranted = await Permission.storage.isGranted;
    if (isGaranted) {
      _takePictureUsingGallery(context, ind);
    } else {
      isGaranted = await Permission.storage.request().isGranted;
      if (isGaranted) {
        _takePictureUsingGallery(context, ind);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  _takePictureUsingCamera(BuildContext context, int ind) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        if (ind == 1) {
          _img1 = File(pickedFile.path);
        } else if (ind == 2) {
          _img2 = File(pickedFile.path);
        }
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context, int ind) async {
    bool isGaranted = await Permission.camera.status.isGranted;
    if (isGaranted) {
      _takePictureUsingCamera(context, ind);
    } else {
      isGaranted = await Permission.camera.request().isGranted;
      if (isGaranted) {
        _takePictureUsingCamera(context, ind);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _showChoiceDialog(BuildContext context, int ind) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('make_choice')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child:
                      Text(AppLocalizations.of(context).translate('gallery')),
                  onTap: () {
                    _openGallery(context, ind);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text(AppLocalizations.of(context).translate('camera')),
                  onTap: () {
                    _openCamera(context, ind);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _immatriculation = car.immatriculation;
    _marque = car.marque;
    _model = car.model;
    _annee = car.annee.toString();
    _pays = car.pays;
    _kilometrage = car.kilometrage.toString();
    _couleur = car.couleur;
    _options = car.options;
    _isNew = car.isnew;
    sc = _isNew ? SingingCharacter.isNew : SingingCharacter.isOld;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        AppLocalizations.of(context).translate('edit_car'),
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
                height: height * 0.02,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('immat'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _immatriculation),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _immatriculation = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('brand'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _marque),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _marque = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('model'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _model),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _model = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('year'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: _annee),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else if (int.parse(value) < 1886 ||
                            int.parse(value) > 2021) {
                          return AppLocalizations.of(context)
                              .translate('year_between');
                        } else
                          return null;
                      },
                      onChanged: (val) {
                        _annee = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('country'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _pays),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _pays = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('kilo'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(text: _kilometrage),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else if (double.parse(value) < 0)
                          return AppLocalizations.of(context)
                              .translate('greater');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _kilometrage = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('color'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _couleur),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _couleur = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 8 / 100, 0, width * 8 / 100, 0),
                    width: width,
                    height: 90,
                    child: TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText:
                            AppLocalizations.of(context).translate('options'),
                        filled: true,
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text: _options),
                      validator: (value) {
                        if (value.isEmpty)
                          return AppLocalizations.of(context)
                              .translate('obligatory_field');
                        else
                          return null;
                      },
                      onChanged: (val) {
                        _options = val;
                      },
                    ),
                  ),
                  AutoSizeText(
                    AppLocalizations.of(context).translate('carIs'),
                    maxLines: 24,
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AutoSizeText(
                        AppLocalizations.of(context).translate('new'),
                        maxLines: 18,
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Radio(
                        activeColor: primaryColor,
                        value: SingingCharacter.isNew,
                        groupValue: sc,
                        onChanged: (value) {
                          setState(() {
                            sc = value;
                            _isNew = true;
                          });
                        },
                      ),
                      AutoSizeText(
                        AppLocalizations.of(context).translate('old'),
                        maxLines: 18,
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Radio(
                        activeColor: primaryColor,
                        value: SingingCharacter.isOld,
                        groupValue: sc,
                        onChanged: (value) {
                          setState(() {
                            sc = value;
                            _isNew = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              AutoSizeText(
                AppLocalizations.of(context).translate('car_pictures'),
                maxLines: 24,
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2.0),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: InkWell(
                      onTap: () {
                        _showChoiceDialog(context, 0);
                      },
                      child: _img1 != null
                          ? Image.file(
                              _img1,
                              height: height * 0.2,
                              width: height * 0.2,
                            )
                          : Image.asset(
                              "assets/images/button1.png",
                              height: height * 0.2,
                              width: height * 0.2,
                            ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2.0),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: InkWell(
                      onTap: () {
                        _showChoiceDialog(context, 1);
                      },
                      child: _img2 != null
                          ? Image.file(
                              _img2,
                              height: height * 0.2,
                              width: height * 0.2,
                            )
                          : Image.asset(
                              "assets/images/button1.png",
                              height: height * 0.2,
                              width: height * 0.2,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                width: width * 0.8,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: primaryColor),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      primaryColor,
                    ),
                  ),
                  child: _buildButtonChild(),
                  onPressed: _validateInputs,
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
