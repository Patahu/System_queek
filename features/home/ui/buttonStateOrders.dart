import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../homebloc/home_bloc.dart';



class ColorButtonRow extends StatelessWidget {
  final Map<String, Color> coloresPorEstado = {
    "DISEÑO": Color(0xFF3366CC),
    "IMPRESIÓN": Color(0xFF0099CC),
    "PLANCHADO": Color(0xFFFF9900),
    "COSIDO": Color(0xFFCC6699),
    "EMPAQUETADO": Color(0xFF9933CC),
    "ENTREGADO": Colors.green,
  };
  final HomeBloc homeBloc;
  ColorButtonRow({super.key, required this.homeBloc});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: coloresPorEstado.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0), // Ajusta el valor según tus necesidades
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                primary: entry.value,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                homeBloc.add(changeViewPedido(estado: entry.key));
              },
              icon: Image.asset(
                'lib/icon/${entry.key}.png',
                width: 35,
                height: 45,
              ),
              label: SizedBox.shrink(),
            ),
          );
        }).toList(),
      ),
    );
  }
}