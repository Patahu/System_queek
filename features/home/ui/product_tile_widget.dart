import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../util/pedido.dart';

import '../homebloc/home_bloc.dart';


class ProductTileWidget extends StatelessWidget {
  final Pedido productDataModel;
  final HomeBloc homeBloc;

  const ProductTileWidget({
    Key? key,
    required this.productDataModel,
    required this.homeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Color> coloresPorEstado = {
      "DISEÑO": Color(0xFF3366CC),
      "IMPRESIÓN": Color(0xFF0099CC),
      "PLANCHADO": Color(0xFFFF9900),
      "COSIDO": Color(0xFFCC6699),
      "EMPAQUETADO": Color(0xFF9933CC),
      "ENTREGADO": Colors.green,
    };

    Color colorEstado = coloresPorEstado[productDataModel.estado] ?? Colors.grey;

    return Column(
      children: [
      Container(
      height: 140,
      decoration: BoxDecoration(
          color: colorEstado.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 1,
              blurRadius: 2,

            ),
          ],
        ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              "NOMBRE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 1),
            Text(
              productDataModel.nombre ?? "",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 1),
            Text(
              "ESTADO",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 1),
            Stack(
              children: [
                Text(
                  productDataModel.estado ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  productDataModel.estado ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,

                  ),
                ),
              ],
            ),
            SizedBox(height: 1),
            Text(
              "ID",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 1),
            Text(
              productDataModel.id ?? "",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    ),
        SizedBox(height: 10),
    ElevatedButton.icon(
          onPressed: () {
            homeBloc.add(viewPedidoSeleccionado(
              pedido: productDataModel,
            ));
          },
          icon: Icon(Icons.description),
          label: Text("Ver Detalles"),
          style: ElevatedButton.styleFrom(
            primary: colorEstado,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}