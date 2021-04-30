import 'package:flutter/cupertino.dart';

class Car {
  int id;
  String immatriculation;
  String marque;
  String model;
  int annee;
  String pays;
  double kilometrage;
  String couleur;
  String options;
  bool isnew;
  List<String> pictures;

  Car({
    this.id,
    @required this.immatriculation,
    @required this.marque,
    @required this.model,
    @required this.annee,
    @required this.pays,
    @required this.kilometrage,
    @required this.couleur,
    @required this.options,
    @required this.isnew,
    this.pictures,
  });

  String _printPictures() {
    String pics = "";
    for (int i = 0; i < pictures.length; i++) {
      pics += "\t" + pictures[i] + "\n";
    }
    return pics;
  }

  @override
  String toString() {
    return "id : $id\nimmatriculation : $immatriculation\nmarque : $marque\nmodel : $model\nannee : $annee\npays : $pays\nkilometrage : $kilometrage\ncouleur : $couleur\noptions : $options\nisnew : $isnew\nPictures: ${_printPictures()}";
  }

  Map<String, dynamic> toJson() => {
        'immatriculation': this.immatriculation,
        'marque': this.marque,
        'model': this.model,
        'annee': this.annee,
        'pays': this.pays,
        'kilometrage': this.kilometrage,
        'couleur': this.couleur,
        'options': this.options,
        'isnew': isnew ? 1 : 0,
      };

  factory Car.fromJson(Map<String, dynamic> json) {
    var kilo = json['kilometrage'];
    return new Car(
        id: json['id'] as int,
        immatriculation: json['immatriculation'] as String,
        marque: json['marque'] as String,
        model: json['model'] as String,
        annee: json['annee'] as int,
        pays: json['pays'] as String,
        kilometrage: kilo is double ? kilo : kilo.toDouble(),
        couleur: json['couleur'] as String,
        options: json['options'] as String,
        isnew: json['isnew'] as int == 1,
        pictures: []);
  }
}
