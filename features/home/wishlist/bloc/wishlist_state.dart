part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistState {}

class WishlistInitial extends WishlistState {

  final Color colors;
  WishlistInitial(this.colors);
}
