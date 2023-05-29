part of 'scanner_bloc.dart';

@immutable
abstract class ScannerState {}
class initialScannerState extends ScannerState {
}
abstract class ActionStateScanner extends ScannerState {}
abstract class ActionStateGenerator extends ScannerState {}
class scanListComplete extends ActionStateScanner {
  final Widget render;
  scanListComplete(this.render);
}
class LoadScanner extends ActionStateScanner {}
class loadGenerate extends ActionStateGenerator{
    final List<Prenda> listaPrendasGeneradas;

  loadGenerate(this.listaPrendasGeneradas);

}

class loadingGenerate extends ActionStateGenerator{

  final String cantidad;

  loadingGenerate(this.cantidad);
}


class editateState extends ActionStateGenerator{

}