import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';



import '../../../repository/data_base_pedido.dart';
import '../../../util/pedido.dart';
import '../../../util/prenda.dart';


part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  DataBasePedidos _dataBasePedidos =new DataBasePedidos();
  bool _isActivateTall=false;
  bool _isActivateName=false;
  String _tall='M';
  Pedido? _pedido;
  String _nama='';
  String _estadoVer='DISEÑO';
  StreamSubscription? _subscriptionPedido=null;
  StreamSubscription? _subscriptionPrenda=null;

  Color _colorsOder=Colors.white;
  final List<Prenda> prendasIngresar=[];
  final TextEditingController nombrePedido = TextEditingController(text:'');
  final TextEditingController tipo = TextEditingController(text: 'SUBLIMADO');
  final TextEditingController descripcion = TextEditingController(text: '');

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialLoadOrders>(homeInitialEvent);
    on<HomeProductWishlistButtonClickedEvent>(
        homeProductWishlistButtonClickedEvent);
    on<viewPedidoSeleccionado>(homeProductCartButtonClickedEvent);
    on<HomeWishlistButtonNavigateEvent>(homeWishlistButtonNavigateEvent);
    on<HomeCartButtonNavigateEvent>(homeCartButtonNavigateEvent);
    on<homeTransicionNavigateEvent>(homeChangeTransicionNavigateEvent);
    on<updatePedidoEvent>(homeChangeLoadOrders);
    on<updatePrendaEvent>(homeChangeLoadPrenda);
    on<listenPerTallaEvent>(listenJustOneTall);
    on<changeEchoEvent>(changeEcho);
    on<listenPerNameEvent>(listenJustOnNameTall);
    on<enterNewOrderEvent>(enterNewOrder);
    on<changeViewPedido>(changeEstado);
    on<HomeInitialEnterOrdersEvent>(homeChangeEnterOrderEvent);
    on<enterPrendaToList>(insertOnePrendaList);
    on<TextChangedEvent>(changeName);
    on<enterPrendaP>(changeListToPrendaEnter);
    on<eventIngresarPrendasDeGenerador>(enterOnGenerateList);
  }

  FutureOr<void> homeInitialEvent(HomeInitialLoadOrders event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    if (_subscriptionPrenda != null) {
      _subscriptionPrenda!.cancel();
    }
    if (_subscriptionPedido != null) {
      _subscriptionPedido!.cancel();
    }
    _subscriptionPedido= _dataBasePedidos.datosPedido().listen((edido) {
      add(updatePedidoEvent(pedido:edido));
    });
  }
  FutureOr<void> enterOnGenerateList(
      eventIngresarPrendasDeGenerador event, Emitter<HomeState> emit) {
    print('enterOnGenerateList');
    prendasIngresar.addAll(event.prendas);
    emit(compleEnterPrendaToList(prendasIngresar));
  }

  FutureOr<void> insertOnePrendaList(
      enterPrendaToList event, Emitter<HomeState> emit) {
    prendasIngresar.add(event.prenda);
      emit(compleEnterPrendaToList(prendasIngresar));
  }
  FutureOr<void> changeName(
      TextChangedEvent event, Emitter<HomeState> emit) {
    print('TextChangedEvent');
    emit(validateNameEnter(event.text));
  }
  FutureOr<void> changeListToPrendaEnter(
      enterPrendaP event, Emitter<HomeState> emit) {
    print('insertOnePrendaList');
    emit(buttonEnterPrenda());
  }
  FutureOr<void> changeEstado(
      changeViewPedido event, Emitter<HomeState> emit) {
      _estadoVer=event.estado;
      add(HomeInitialLoadOrders());
  }
  FutureOr<void> changeEcho(
      changeEchoEvent event, Emitter<HomeState> emit) {

    _dataBasePedidos.actualizarAtributoEcho(_pedido!.id,event.idPrenda,event.isActivate);
    //emit(HomeProductItemWishlistedActionState());
  }


  FutureOr<void> homeProductWishlistButtonClickedEvent(
      HomeProductWishlistButtonClickedEvent event, Emitter<HomeState> emit) {
    print('homeProductWishlistButtonClickedEvent');

    emit(HomeProductItemWishlistedActionState());
  }

  FutureOr<void> homeProductCartButtonClickedEvent(
      viewPedidoSeleccionado event, Emitter<HomeState> emit) async{
    print('homeProductCartButtonClickedEvent');

    _pedido=event.pedido;
    if (_subscriptionPrenda != null) {
      _subscriptionPrenda!.cancel();
    }
    if (_subscriptionPedido != null) {
      _subscriptionPedido!.cancel();
    }



    _subscriptionPrenda= _dataBasePedidos.getPrendas(_pedido!.id).listen((edido) {
      add(updatePrendaEvent(prendas:edido));
    });


  }

  FutureOr<void> homeWishlistButtonNavigateEvent(
      HomeWishlistButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('homeWishlistButtonNavigateEvent');
    emit(HomeNavigateToWishlistPageActionState());
  }
  FutureOr<void> enterNewOrder(
      enterNewOrderEvent event, Emitter<HomeState> emit) {
    print('enterNewOrder');
    if(prendasIngresar.isNotEmpty && nombrePedido.text!=''){
      print('object-----'+nombrePedido.text);
      _dataBasePedidos.insertPedido(new Pedido(
          id: '',
          nombre: nombrePedido.text,
          tipo: tipo.text,
          descripcion: descripcion.text,
          fotoLista: '',
          estado: 'DISEÑO',
          fecha: Timestamp.fromDate(DateTime.now()) ,
          link3D: ''
      ),prendasIngresar).then((_) {
          prendasIngresar.clear();
          nombrePedido.text='';
          descripcion.text='';
          add(homeTransicionNavigateEvent());
        }
      );

    }

  }
  FutureOr<void> homeCartButtonNavigateEvent(
      HomeCartButtonNavigateEvent event, Emitter<HomeState> emit) {
    print('homeCartButtonNavigateEvent');
    emit(HomeNavigateToCartPageActionState());
  }

  FutureOr<void> homeChangeTransicionNavigateEvent(
      homeTransicionNavigateEvent event, Emitter<HomeState> emit) async{
    emit(HomeLoadingState());
    print('--------------homeChangeTransicionNavigateEvent');
    if (_subscriptionPrenda != null) {
      _subscriptionPrenda!.cancel();
    }
    if (_subscriptionPedido != null) {
      _subscriptionPedido!.cancel();
    }
    emit(homeTransicionNavigateState());
  }

  FutureOr<void> listenJustOneTall(
      listenPerTallaEvent event, Emitter<HomeState> emit) async{
    emit(HomeLoadingState());
    print('--------------listenJustOneTall');
    _isActivateTall=event.isActivate;
    _isActivateName=false;
    _tall= event.talla;
    add(viewPedidoSeleccionado(pedido: _pedido!));
  }
  FutureOr<void> listenJustOnNameTall(
      listenPerNameEvent event, Emitter<HomeState> emit) async{
    //emit(HomeLoadingState());
    print('--------------listenJustOnNameTall');
    _isActivateName=event.isActivate;
    _nama= event.name;
    add(viewPedidoSeleccionado(pedido: _pedido!));
  }
  FutureOr<void> homeChangeLoadOrders(
      updatePedidoEvent event, Emitter<HomeState> emit) async{
    emit(HomeLoadingState());
    print('--------------homeChangeLoadOrders');
    List<Pedido> _pe=event.pedido.where((pedido) => pedido.estado == _estadoVer).toList();
    emit(HomeLoadedSuccessState(pedido: _pe));
  }
  FutureOr<void> homeChangeLoadPrenda(
      updatePrendaEvent event, Emitter<HomeState> emit) async{
    //emit(HomeLoadingState());
    Map<String, int> cantidadPorTalla = {};
    List<Prenda> prendasOrdenadas = event.prendas;
    print('--------------homeChangeLoadPrenda');
    if (_isActivateTall) {
      print("tall------------"+_tall);
      prendasOrdenadas = event.prendas.where((prenda) => prenda.talla == _tall).toList();
    }else if(_isActivateName){
      prendasOrdenadas = event.prendas.where((prenda) => prenda.nombres.any((nombre) => nombre == _nama)).toList();
    }
    List<String> tallasDisponibles = ["M", "L", "S", "XL", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"];
    for (Prenda prenda in event.prendas) {
      String talla = prenda.talla;

      if (tallasDisponibles.contains(talla)) {
        cantidadPorTalla[talla] = (cantidadPorTalla[talla] ?? 0) + 1;
      }
    }
    prendasOrdenadas = ordenarPrendas(prendasOrdenadas);

    List<String> listaTallasCantidad = cantidadPorTalla.entries
        .where((entry) => entry.value > 0)
        .map((entry) => '${entry.key}: ${entry.value}')
        .toList();
    emit(viewOrderPrendasAll(Prendas:prendasOrdenadas,tallas: listaTallasCantidad,pedido: _pedido!));
  }


  FutureOr<void> homeChangeEnterOrderEvent(
      HomeInitialEnterOrdersEvent event, Emitter<HomeState> emit) async{
    emit(HomeLoadingState());
    print('-----------------------homeChangeEnterOrderEvent');
    emit(homeChangeEnterOrderState());
    //emit(compleEnterPrendaToList(_prendasIngresar));

  }
  @override
  Future<void> close() {
    nombrePedido.dispose();
    _subscriptionPedido?.cancel();
    _subscriptionPrenda?.cancel();
    return super.close();
  }
  List<Prenda> ordenarPrendas(List<Prenda> prendas) {
    prendas.sort((a, b) {
      // Si a.echo y b.echo son iguales, mantener el orden actual
      if (a.echo == b.echo) {
        return 0;
      }

      // Si a.echo es falso, a es menor que b
      if (!a.echo) {
        return -1;
      }

      // Si b.echo es falso, b es menor que a
      if (!b.echo) {
        return 1;
      }

      // Ambos tienen echo=true, mantener el orden actual
      return 0;
    });

    return prendas;
  }
}
