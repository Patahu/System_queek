
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistemas_queek/features/home/ui/prendaWigget.dart';
import 'package:sistemas_queek/features/home/ui/rowTallList.dart';


import '../homebloc/home_bloc.dart';
import '../wishlist/bloc/wishlist_bloc.dart';


class viewDetailOrder extends StatefulWidget {
  viewDetailOrder({
    Key? key,
    required this.homeBloc,
    required TextEditingController controller,
    required this.successState,
  }) : _controller = controller;

  final HomeBloc homeBloc;
  final TextEditingController _controller;
  final viewOrderPrendasAll successState;

  @override
  _viewDetailOrderState createState() => _viewDetailOrderState();
}

class _viewDetailOrderState extends State<viewDetailOrder> {
  late WishlistBloc _wishlistBloc;

  @override
  void initState() {
    super.initState();
    _wishlistBloc = WishlistBloc(widget.successState.pedido)..add(changeOrderStateEventWishlist());
    
  }

  @override
  void dispose() {
    _wishlistBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ListView(
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
                    widget.homeBloc.add(HomeInitialLoadOrders());
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: Text(
                    'DETALLE DE PRENDAS',
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
        Container(height: 10,),
        FractionallySizedBox(
          widthFactor: 0.7, // Ajusta el valor según tus necesidades (0.0 - 1.0)
          child: TextField(
            controller: widget._controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFD2E4F3),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            style: TextStyle(fontSize: 20.0),
            maxLines: 1,
            onSubmitted: (value) {
              // Aquí puedes agregar la lógica que deseas ejecutar al presionar Enter
              print('Texto ingresado: $value');

              if (value.isNotEmpty) {
                widget.homeBloc.add(listenPerNameEvent(name: value, isActivate: true));
              }
            },
          ),
        ),
        Center(child: Text('Tallas',style: TextStyle(color: Colors.white, fontSize: 20),),),
        TallasWidget( tallas:widget.successState.tallas, homeBloc: widget.homeBloc,),
        Container(height: 10,),
        BlocBuilder(
            bloc: widget.homeBloc,
            builder: (context,state){
              final successState2=state as viewOrderPrendasAll;

              return Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemCount: successState2.Prendas.length,
                  itemBuilder: (context, index) {
                    return PrendaWidget(prenda: successState2.Prendas[index],homeBloc: widget.homeBloc);
                  },
                ),
              );

            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.homeBloc.add(listenPerTallaEvent(talla: 'M', isActivate: false));
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFD2E4F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: 50,
                height: 50,
                child: Center(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                margin: EdgeInsets.only(right: 8),
              ),
            ),
            SizedBox(width: 10,),

            BlocBuilder(
                bloc: _wishlistBloc,
                builder: (context,state){
                  final successState2=state as WishlistInitial;

                  return ElevatedButton(
                    onPressed: () {
                      _wishlistBloc.add(changeOrderStateEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: successState2.colors,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(child: Text('A',
                        style: TextStyle(color: Colors.black, fontSize: 30),)),
                      margin: EdgeInsets.only(right: 8),
                    ),
                  );
                }),
          ],
        ),

      ],
    );
  }
}
