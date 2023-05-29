import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Pedido {
  String _id;
  String _nombre;
  String _tipo;
  String _descripcion;
  String _fotoLista;
  String _estado;
  Timestamp _fecha;
  String _link3D;

  Pedido({
    required String id,
    required String nombre,
    required String tipo,
    required String descripcion,
    required String fotoLista,
    required String estado,
    required Timestamp fecha,
    required String link3D,
  })  : _id = id,
        _nombre = nombre,
        _tipo = tipo,
        _descripcion = descripcion,
        _fotoLista = fotoLista,
        _estado = estado,
        _fecha = fecha,
        _link3D = link3D;

  String get id => _id;
  String get nombre => _nombre;
  String get tipo => _tipo;
  String get descripcion => _descripcion;
  String get fotoLista => _fotoLista;
  String get estado => _estado;
  Timestamp get fecha => _fecha;
  String get link3D => _link3D;

  set id(String id) {
    _id = id;
  }

  set nombre(String nombre) {
    _nombre = nombre;
  }

  set tipo(String tipo) {
    _tipo = tipo;
  }

  set descripcion(String descripcion) {
    _descripcion = descripcion;
  }

  set fotoLista(String fotoLista) {
    _fotoLista = fotoLista;
  }

  set estado(String estado) {
    _estado = estado;
  }

  set fecha(Timestamp fecha) {
    _fecha = fecha;
  }

  set link3D(String link3D) {
    _link3D = link3D;
  }

  List<Object> get props => [
    _id,
    _nombre,
    _tipo,
    _descripcion,
    _fotoLista,
    _estado,
    _fecha,
    _link3D,
  ];

  static Pedido fromDB(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    return Pedido(
      id: documentSnapshot.id,
      nombre: data['nombre'] as String,
      tipo: data['tipo'] as String,
      descripcion: data['descripcion'] as String,
      fotoLista: data['fotoLista'] as String,
      estado: data['estado'] as String,
      fecha: data['fechaIngresada'] as Timestamp,
      link3D: data['link3D'] as String,
    );
  }

  Color colorDelEstadoPedido(){
    Map<String, Color> coloresPorEstado = {
      "DISEÑO": Color(0xFF3366CC),
      "IMPRESIÓN": Color(0xFF0099CC),
      "PLANCHADO": Color(0xFFFF9900),
      "COSIDO": Color(0xFFCC6699),
      "EMPAQUETADO": Color(0xFF9933CC),
      "ENTREGADO": Colors.green,
    };
    return coloresPorEstado[_estado] ?? Colors.grey;

  }
}