import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../util/prenda.dart';
import '../homebloc/home_bloc.dart';


class PrendaWidget extends StatelessWidget {
  final Prenda prenda;
  final HomeBloc homeBloc;
  const PrendaWidget({required this.prenda,required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color:prenda.echo ? Colors.green:Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Nombres',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Text(
            prenda.nombres.join(", "),
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Número',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                prenda.numero,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              Text(
                'Sexo',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                prenda.sexo,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              Text(
                'Talla',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                prenda.talla,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),

          Text(
            'Tipo',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Text(
            prenda.tipo,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          Checkbox(
            value: prenda.echo,
            onChanged: (value) {
              homeBloc.add(changeEchoEvent( isActivate: value!, idPrenda: prenda.id));
              // Aquí puedes manejar la lógica de cambio del atributo `echo`
            },
          ),
        ],
      ),
    );
  }
}