part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

abstract class HomeActionState extends HomeState {}

abstract class OrderEnterState extends HomeState{}


class buttonEnterPrenda extends OrderEnterState{}

class compleEnterPrendaToList extends OrderEnterState{
  final List<Prenda> prenda;
  compleEnterPrendaToList(this.prenda);

}

// Estado del Bloc
class validateNameEnter extends OrderEnterState{
  final String isName;

  validateNameEnter(this.isName);

}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<Pedido> pedido;
  HomeLoadedSuccessState({
    required this.pedido,
  });
}

class HomeErrorState extends HomeState {}

class HomeNavigateToWishlistPageActionState extends HomeActionState {}

class HomeNavigateToCartPageActionState extends HomeActionState {}

class HomeProductItemWishlistedActionState extends HomeActionState {}

class viewOrderPrendasAll extends HomeActionState {
    final List<Prenda> Prendas;
    final List<String> tallas;
    final Pedido pedido;
    viewOrderPrendasAll({
      required this.Prendas,
      required this.tallas,
      required this.pedido,
    });
}

class homeTransicionNavigateState extends HomeState{}

class homeChangeEnterOrderState extends HomeState{
}
