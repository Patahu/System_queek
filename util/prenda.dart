import 'package:cloud_firestore/cloud_firestore.dart';

class Prenda {
  String _id;
  bool _echo;
  List<String> _nombres;
  String _numero;
  String _sexo;
  String _talla;
  String _tipo;

  Prenda({
    required String id,
    required bool echo,
    required List<String> nombres,
    required String numero,
    required String sexo,
    required String talla,
    required String tipo,
  })  : _id = id,
        _echo = echo,
        _nombres = nombres,
        _numero = numero,
        _sexo = sexo,
        _talla = talla,
        _tipo = tipo;

  String get id => _id;
  bool get echo => _echo;
  List<String> get nombres => _nombres;
  String get numero => _numero;
  String get sexo => _sexo;
  String get talla => _talla;
  String get tipo => _tipo;

  set id(String id) {
    _id = id;
  }

  set echo(bool echo) {
    _echo = echo;
  }

  set nombres(List<String> nombres) {
    _nombres = nombres;
  }

  set numero(String numero) {
    _numero = numero;
  }

  set sexo(String sexo) {
    _sexo = sexo;
  }

  set talla(String talla) {
    _talla = talla;
  }

  set tipo(String tipo) {
    _tipo = tipo;
  }

  List<Object?> get props => [
    _id,
    _echo,
    _nombres,
    _numero,
    _sexo,
    _talla,
    _tipo,
  ];

  static Prenda fromDB(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    return Prenda(
      id: documentSnapshot.id,
      echo: data['echo'] as bool,
      nombres: List<String>.from(data['nombres']),
      numero: data['numero'] as String,
      sexo: data['sexo'] as String,
      talla: data['talla'] as String,
      tipo: data['tipo'] as String,
    );
  }
}