import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../repository/data_base_pedido.dart';
import '../../../../util/pedido.dart';


part 'wishlist_event.dart';
part 'wishlist_state.dart';
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  DataBasePedidos _dataBasePedidos = new DataBasePedidos();
  StreamSubscription? _subscriptionPedidoEspecifico;
  final Pedido _pedido;

  WishlistBloc(this._pedido) :
        super(WishlistInitial(_pedido.colorDelEstadoPedido())) {
    on<enterNewPedido>(changeState);
    on<changeOrderStateEvent>(changeStateOrder);
    on<changeOrderStateEventWishlist>(initialListen);
  }
  FutureOr<void> initialListen(
      changeOrderStateEventWishlist event, Emitter<WishlistState> emit) {
    print('initialListen');
    if (_subscriptionPedidoEspecifico != null) {
      _subscriptionPedidoEspecifico!.cancel();
    }

    _subscriptionPedidoEspecifico = _dataBasePedidos
        .datosPedidoEspecifico(_pedido.id)
        .listen((pedido) {
      add(enterNewPedido(pedido));
      // Aquí puedes realizar las operaciones necesarias con los datos del pedido específico
    });
    //emit(WishlistInitial(event.pedido.colorDelEstadoPedido()));
  }
  FutureOr<void> changeStateOrder(
      changeOrderStateEvent event, Emitter<WishlistState> emit) {
    String estadoSiguiente = siguienteEstado(_pedido.estado);

    if (estadoSiguiente != _pedido.estado) {
      _pedido.estado=estadoSiguiente;
      _dataBasePedidos.actualizarAtributoEstado(_pedido.id, estadoSiguiente);
    }else{
      print("NOTHING");
    }
    //emit(HomeProductItemWishlistedActionState());
  }
  @override
  Future<void> close() {
    _subscriptionPedidoEspecifico?.cancel();
    return super.close();
  }
  String siguienteEstado(String estadoActual) {
    List<String> estados = [
      "DISEÑO",
      "IMPRESIÓN",
      "PLANCHADO",
      "COSIDO",
      "EMPAQUETADO",
      "ENTREGADO"
    ];

    int indiceEstadoActual = estados.indexOf(estadoActual);

    // Verificar si el estado actual existe en la lista
    if (indiceEstadoActual != -1) {
      // Verificar si no es el último estado de la lista
      if (indiceEstadoActual < estados.length - 1) {
        return estados[indiceEstadoActual + 1];
      } else {
        // Es el último estado, retornar el mismo estado
        return estadoActual;
      }
    } else {
      // El estado actual no está en la lista, retornar null o algún valor indicativo de error
      return '';
    }
  }
  FutureOr<void> changeState(
      enterNewPedido event, Emitter<WishlistState> emit) {
    print('changeState');
    emit(WishlistInitial(event.pedido.colorDelEstadoPedido()));
  }


}