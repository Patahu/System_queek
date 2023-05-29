import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistemas_queek/features/home/ui/product_tile_widget.dart';


import '../homebloc/home_bloc.dart';
import 'buttonStateOrders.dart';
import 'home.dart';

class ordersDetails extends StatelessWidget {
  const ordersDetails({
    super.key,
    required this.homeBloc,
    required this.successState,
  });

  final HomeBloc homeBloc;
  final HomeLoadedSuccessState successState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Column(
        children: [
          Container(height: MediaQuery.of(context).size.height * 0.06,),
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            color: Color(0xFFFFE5A7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      homeBloc.add(homeTransicionNavigateEvent());
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.78,
                  child: Center(
                    child: Text(

                      'DETALLE DE PEDIDOS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.78,
              child:successState.pedido.length==0?
              Container(
                height: 150,
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Image(image: AssetImage('lib/icon/VACIO.png')),
                    Text('Estado sin registros',
                      style: TextStyle(
                        color: Colors.white, // Color del texto
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),)
                  :
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // Ajusta este valor según tus necesidades
                children: List.generate(successState.pedido.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0), // Espacio alrededor del widget
                    child: ProductTileWidget(
                      homeBloc: homeBloc,
                      productDataModel: successState.pedido[index],
                    ),
                  );
                }),
              )
          ),
          ColorButtonRow(homeBloc: homeBloc,),
        ],
      ),
    );
  }
}
