part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistEvent {}

class changeOrderStateEventWishlist extends WishlistEvent{
}

class enterNewPedido extends WishlistEvent{
  final Pedido pedido;

  enterNewPedido(this.pedido);
}
class changeOrderStateEvent extends WishlistEvent{

}