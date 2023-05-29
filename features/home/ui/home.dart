import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistemas_queek/features/home/ui/prendaWigget.dart';
import 'package:sistemas_queek/features/home/ui/product_tile_widget.dart';
import 'package:sistemas_queek/features/home/ui/rowTallList.dart';
import 'package:sistemas_queek/features/home/ui/viewDetailsOrders.dart';
import 'package:sistemas_queek/features/home/ui/yolovScan.dart';
import 'package:sistemas_queek/util/pedido.dart';


import '../../../util/prenda.dart';

import '../homebloc/home_bloc.dart';
import 'PrendaWiggetIngresarPedido.dart';
import 'font.dat.dart';
import 'initialTwoIcon.dart';
import 'orderDetails.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();
  final HomeBloc homeBloc = HomeBloc();
  @override
  void initState() {
    homeBloc.add(homeTransicionNavigateEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.transparent, // Fondo azul
      body: withFond(result: 
        BlocConsumer<HomeBloc, HomeState>(
            bloc: homeBloc,
            listener: (context, state) {
              // Lógica para manejar los cambios de estado
            },
            buildWhen: (previousState, currentState) {
              // Verifica si el estado anterior y el estado actual son el mismo
              return previousState.runtimeType != currentState.runtimeType && currentState is! OrderEnterState;
            },
            builder: (context,state) {
             switch (state.runtimeType) {
              case homeTransicionNavigateState:
              return initial(homeBloc: homeBloc);
              case HomeLoadingState:
                return Container(
                            child: Center(
                          child: CircularProgressIndicator(),
                        ));
              case HomeLoadedSuccessState:
                final successState=state as HomeLoadedSuccessState;
                return ordersDetails(homeBloc: homeBloc, successState: successState);
              case HomeErrorState:
                  return Container(child: Center(child: Text('Error')));
               case viewOrderPrendasAll:
                 final successState=state as viewOrderPrendasAll;
                 print("her-------F"+successState.Prendas.length.toString());
                 return viewDetailOrder(homeBloc: homeBloc, controller: _controller, successState: successState);
              case homeChangeEnterOrderState:
                return enterOrder(homeBloc: homeBloc);
              default:
                return Container();
            }
        
          }
        ),
        ),
                    );
  }
}


class CustomColors {
  static const Color primaryColor = Color(0xFFFFE5A7); // Amarillo claro
  static const Color accentColor = Color(0xFF111215); // Negro azulado
  static const Color textColor = Colors.black; // Blanco
  static const Color textFieldColor = Color(0xFFCCCCCC); // Gris claro
  static const Color backgroundColor = Color(0xFF111215); // Negro azulado
}

class enterOrder extends StatelessWidget {

  final HomeBloc homeBloc;
  enterOrder({
    super.key,
    required this.homeBloc,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        child: ListView(
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: Text(
                        'INGRESAR PEDIDO',
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
              height: 345,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                    bloc: homeBloc,
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: homeBloc.nombrePedido,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Nombre pedido',
                            labelStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFD2E4F3), // Color de los bordes
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.5), // Color de fondo
                          ),
                          onChanged: (value) {
                            //homeBloc.add(TextChangedEvent(value));
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obligatorio';
                            }
                            return null;
                          },
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField(
                      value: homeBloc.tipo.text,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'SUBLIMADO',
                          child: Text('SUBLIMADO'),
                        ),
                        DropdownMenuItem(
                          value: 'OTROS',
                          child: Text('OTROS'),
                        ),
                      ],
                      onChanged: (value) {
                        //homeBloc.tipo.text = value!;
                        //homeBloc.add(TextChangedEvent(value));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: homeBloc.descripcion,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFD2E4F3), // Color de los bordes
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white, // Color de fondo
                      ),


                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: InkWell(
                          onTap: () {

                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => HomeScreen(homeBloc: homeBloc,)));

                            // Acción al presionar el botón de Foto Lista
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomColors.textColor),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFF00BF63),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: CustomColors.textColor,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Foto Lista',
                                  style: TextStyle(color: CustomColors.textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                     // Espacio entre los botones
                    ],
                  ),
                ],
              ),
            ),
            BlocBuilder(
              bloc: homeBloc,
                builder: (context,state){
                  if(state.runtimeType == buttonEnterPrenda){
                    return DataInputWidget(homeBloc);
                  }
                  return ListOrderEnterWigget( homeBloc: homeBloc);
                },
            ),
          ],
        ),
    );
  }
}

class ListOrderEnterWigget extends StatelessWidget {
  const ListOrderEnterWigget({
    super.key,
    required this.homeBloc,
  });


  final HomeBloc homeBloc;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: InkWell(
            onTap: () {
              // Acción al presionar el botón de Agregar
              homeBloc.add(enterPrendaP());
            },
            child: Container(
              height:40,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.textColor),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),

                ),
                color: Color(0xFF00BF63),
              ),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          child: homeBloc.prendasIngresar.isEmpty ?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/icon/VACIO.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 10), // Espacio entre las imágenes
                  Image.asset(
                    'lib/icon/PRENDALISTA.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
              Text('Lista de prendas vacía',
                  style:TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold)),
            ],
          ):
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemCount: homeBloc.prendasIngresar.length,
            itemBuilder: (context, index) {
              return PrendaWidgetIngresarPedido(prenda: homeBloc.prendasIngresar[index],homeBloc: homeBloc);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                homeBloc.add(enterNewOrderEvent());
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF7ED957), // Color de fondo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'INGRESAR PEDIDO',
                  style: TextStyle(
                    color: Colors.black, // Color del texto
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}


class DataInputWidget extends StatefulWidget {
  final HomeBloc homeBloc;
  DataInputWidget(this.homeBloc);
  @override
  _DataInputWidgetState createState() => _DataInputWidgetState();
}

class _DataInputWidgetState extends State<DataInputWidget> {
  String _id = '';
  bool _echo = false;
  List<String> _nombres = [];
  String _numero = '';
  String _sexo = 'Varón';
  String _talla = 'M';
  String _tipo = 'M. CORTA';

  HomeBloc get _homeBloc => widget.homeBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.transparent,

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.lightGreen, // Cambia el color del contenedor aquí
          borderRadius: BorderRadius.circular(10), // Establece el radio de los bordes aquí
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: _nombres.isEmpty? 'Nombre 1, Nombre2 ':'',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _nombres = value.split(',');
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: TextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: _numero.isEmpty ? 'Número' : '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _numero = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _sexo,

                        ),
                        value: 'Varón',
                        onChanged: (value) {
                          setState(() {
                            _sexo = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Varón',
                            child: Text('Varón'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Mujer',
                            child: Text('Mujer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _talla,

                        ),
                        value: _talla,
                        onChanged: (value) {
                          setState(() {
                            _talla = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'M',
                            child: Text('M'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'S',
                            child: Text('S'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _tipo,

                        ),
                        value: _tipo,
                        onChanged: (value) {
                          setState(() {
                            _tipo = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'M. CORTA',
                            child: Text('M. CORTA'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'M. LARGA',
                            child: Text('M. CORTA'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _homeBloc.add(enterPrendaToList(new Prenda(
                    id: '',
                    echo: false,
                    nombres: _nombres,
                    numero:_numero,
                    sexo: _sexo,
                    talla: _talla,
                    tipo: _tipo
                )));
                // Lógica para el botón "Ingresar Prenda"
              },
              child: Text('Ingresar Prenda'),
            ),
          ],
        ),
      ),
    );
  }
}