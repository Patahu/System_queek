part of 'scanner_bloc.dart';

@immutable
abstract class ScannerEvent {}

class LoadModels extends ScannerEvent{
}

class enterNewPedido extends ScannerEvent{
}
class startScannerList extends ScannerEvent{

}
class loadWithImage extends ScannerEvent{

}

class editarPrenda extends ScannerEvent{
  final Prenda prenda;
  final int numero;
  editarPrenda(this.prenda,this.numero);
}


class actualizarPrendaEvent extends ScannerEvent{
  final Prenda prenda;
  actualizarPrendaEvent(this.prenda);
}