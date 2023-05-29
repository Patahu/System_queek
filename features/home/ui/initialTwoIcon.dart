import 'package:flutter/material.dart';

import '../homebloc/home_bloc.dart';



class initial extends StatelessWidget {
  const initial({
    super.key,
    required this.homeBloc,
  });

  final HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'lib/icon/DETALLES.png',
                        width: 50,
                        height: 50,
                      ),
                      onPressed: () {
                        homeBloc.add(HomeInitialLoadOrders()); //cargar pedido
                      },
                    ),
                  ),
                  Text('Detalles',style: TextStyle(
                    color: Colors.white,

                  )),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'lib/icon/INGRESAR.png',
                        width: 50,
                        height: 50,
                      ),
                      onPressed: () {
                        homeBloc.add(HomeInitialEnterOrdersEvent()); // ingresa pedidos
                      },
                    ),
                  ),
                  Text('Ingresar',
                    style: TextStyle(
                        color: Colors.white,

                    )
                    ,)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}