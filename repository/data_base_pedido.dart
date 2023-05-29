



import 'package:cloud_firestore/cloud_firestore.dart';

import '../util/pedido.dart';
import '../util/prenda.dart';

class DataBasePedidos {
  final FirebaseFirestore _firebaseFirestore;

  DataBasePedidos({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Pedido>> datosPedido() {
    return _firebaseFirestore
        .collection("Pedido")
        .orderBy('fechaIngresada', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Pedido> po =
      snapshot.docs.map((doc) => Pedido.fromDB(doc)).toList();
      return po;
    });
  }
  Stream<Pedido> datosPedidoEspecifico(String pedidoId) {
    return _firebaseFirestore
        .collection("Pedido")
        .doc(pedidoId)
        .snapshots()
        .map((snapshot) => Pedido.fromDB(snapshot));
  }
  Stream<List<Prenda>> getPrendas(String id) {
    return _firebaseFirestore
        .collection("Pedido")
        .doc(id)
        .collection("prenda")
        .snapshots()
        .map((snapshot) {
      List<Prenda> prendas =
      snapshot.docs.map((doc) => Prenda.fromDB(doc)).toList();

      return prendas;
    });
  }
  void actualizarAtributoEstado(String pedidoId, String nuevoValor) {
    var pedidoRef = _firebaseFirestore.collection("Pedido").doc(pedidoId);

    pedidoRef.update({"estado": nuevoValor}).then((_) {
      print("Atributo 'estado' actualizado correctamente");
    }).catchError((error) {
      print("Error al actualizar el atributo 'estado': $error");
    });
    var prendaRef = _firebaseFirestore.collection("Pedido").doc(pedidoId).collection("prenda");

    prendaRef.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"echo": false}).then((_) {
          print("Atributo 'echo' actualizado correctamente en la prenda ${doc.id}");
        }).catchError((error) {
          print("Error al actualizar el atributo 'echo' en la prenda ${doc.id}: $error");
        });
      });
    }).catchError((error) {
      print("Error al obtener la colección 'prenda': $error");
    });
  }

  void actualizarAtributoEcho(String pedidoId, String prendaId, bool nuevoValor) {
    var pedidoRef = _firebaseFirestore.collection("Pedido").doc(pedidoId);
    var prendaRef = pedidoRef.collection("prenda").doc(prendaId);

    prendaRef.update({"echo": nuevoValor}).then((_) {
      print("Atributo 'echo' actualizado correctamente");
    }).catchError((error) {
      print("Error al actualizar el atributo 'echo': $error");
    });
  }
  Future<int> obtenerCantidadDocumentos() async {
    QuerySnapshot querySnapshot = await _firebaseFirestore.collection('Pedido').get();
    int cantidadDocumentos = querySnapshot.size;
    return cantidadDocumentos;
  }
  Future<void> insertPedido(Pedido pedido, List<Prenda> prendas) async {
    try {

      // Crea el documento del pedido usando el valor del contador como ID
      int _contador=0;
      int cantidadDocumentos = await obtenerCantidadDocumentos();
      _contador = cantidadDocumentos + 1;
      final pedidoRef = _firebaseFirestore.collection('Pedido').doc('P-$_contador');
      await pedidoRef.set({
        'nombre': pedido.nombre,
        'tipo': pedido.tipo,
        'descripcion': pedido.descripcion,
        'fotoLista': pedido.fotoLista,
        'estado': pedido.estado,
        'fechaIngresada': pedido.fecha,
        'link3D': pedido.link3D,
      });

      // Agregar la colección "Prenda" dentro de "Pedido"
      for (var prenda in prendas) {
        final prendaRef = pedidoRef.collection('prenda').doc();
        await prendaRef.set({
          'id': prenda.id,
          'echo': prenda.echo,
          'nombres': prenda.nombres,
          'numero': prenda.numero,
          'sexo': prenda.sexo,
          'talla': prenda.talla,
          'tipo': prenda.tipo,
        });
      }

      print('Pedido insertado exitosamente. ID: ${pedidoRef.id}, Contador: $_contador');
    } catch (error) {
      print('Error al insertar el pedido: $error');
      throw error;
    }
  }
}
