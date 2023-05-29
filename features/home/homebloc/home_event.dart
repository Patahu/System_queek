part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialLoadOrders
 extends HomeEvent {}

class HomeProductWishlistButtonClickedEvent extends HomeEvent {
  final Pedido clickedProduct;
  HomeProductWishlistButtonClickedEvent({
    required this.clickedProduct,
  });
}

class viewPedidoSeleccionado extends HomeEvent {
  final Pedido pedido;
  viewPedidoSeleccionado({
    required this.pedido,
  });
}

class HomeWishlistButtonNavigateEvent extends HomeEvent {}

class HomeCartButtonNavigateEvent extends HomeEvent {}
class homeTransicionNavigateEvent extends HomeEvent{}
class HomeInitialEnterOrdersEvent extends HomeEvent{}

class updatePedidoEvent extends HomeEvent{

  final List<Pedido> pedido;
  updatePedidoEvent({
    required this.pedido,
  });
}
class updatePrendaEvent extends HomeEvent{

  final List<Prenda> prendas;
  updatePrendaEvent({
    required this.prendas,
  });
}

class listenPerTallaEvent extends HomeEvent{

  final String talla;
  final bool isActivate;
  listenPerTallaEvent({
    required this.talla,
    required this.isActivate,
  });
}
class listenPerNameEvent extends HomeEvent{

  final String name;
  final bool isActivate;
  listenPerNameEvent({
    required this.name,
    required this.isActivate,
  });
}

// Evento para actualizar el texto
class TextChangedEvent extends HomeEvent {
  final String text;

  TextChangedEvent(this.text);
}

class enterNewOrderEvent extends HomeEvent{

}
class changeViewPedido extends HomeEvent{
  final String estado;
  changeViewPedido({
    required this.estado,
  });
}


class enterPrendaP extends HomeEvent{}
class changeEchoEvent extends HomeEvent{
  final bool isActivate;
  final String idPrenda;
  changeEchoEvent({
    required this.idPrenda,
    required this.isActivate,
  });
}


class enterPrendaToList extends HomeEvent{
  final Prenda prenda;
  enterPrendaToList(this.prenda);

}
class eventIngresarPrendasDeGenerador extends HomeEvent{
  final List<Prenda> prendas;

  eventIngresarPrendasDeGenerador(this.prendas);


}