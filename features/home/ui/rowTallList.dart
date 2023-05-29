import 'package:flutter/material.dart';


import '../homebloc/home_bloc.dart';

class TallasWidget extends StatelessWidget {
  final List<String> tallas;
  final HomeBloc homeBloc;

  const TallasWidget({required this.tallas,required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemCount: tallas.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: _buildFila(tallas[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFila(String talla) {
    return ElevatedButton(
      onPressed: () {
        String primeraPosicion = talla.split(':')[0];
        print(primeraPosicion);
        homeBloc.add(listenPerTallaEvent( talla: primeraPosicion,isActivate:true));
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFFEDD40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Container(
        width: 50,
        height: 50,
        child: Center(child: Text(talla,style: TextStyle(color: Colors.black, fontSize: 18),)),
        margin: EdgeInsets.only(right: 8),
      ),
    );
  }
}
