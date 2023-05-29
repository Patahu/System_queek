import 'package:flutter/material.dart';

import '../../../util/prenda.dart';

import '../homebloc/home_bloc.dart';

class PrendaWidgetIngresarPedido extends StatelessWidget {
  final Prenda prenda;
  final HomeBloc homeBloc;
  const PrendaWidgetIngresarPedido({required this.prenda,required this.homeBloc});

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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    // Lógica para el botón de eliminar
                  },
                  icon: Image.asset('lib/icon/ELIMINAR.png'),
                ),
              ),
              SizedBox(width: 10), // Espacio entre los botones
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    // Lógica para el botón de editar
                  },
                  icon: Image.asset('lib/icon/EDITAR.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}