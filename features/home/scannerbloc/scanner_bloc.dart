import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../util/pedido.dart';
import '../../../util/image_crop_class.dart';
import '../../../util/prenda.dart';


part 'scanner_event.dart';
part 'scanner_state.dart';
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  late ModelObjectDetection _objectModel;
   List<ResultObjectDetection?> _objDetect = [];
  File? _image;
  final List<List<String?>> _letterList = [];
  final List<Prenda> prendas=[];
  final TextEditingController controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  int _prendaModificar=0;
  Prenda? prendaModificar;
  ScannerBloc() :super(initialScannerState()) {
    on<startScannerList>(workScanning);
    on<LoadModels>(initialLoadModels);
    on<loadWithImage>(emitterImageScan);
    on<editarPrenda>(editarPrendaGenerate);
    on<actualizarPrendaEvent>(actualizarPrenda);
  }
  FutureOr<void> initialLoadModels(
      LoadModels event, Emitter<ScannerState> emit) async{
    print("-----initialLoadModels");

    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    try {
      _objectModel = await FlutterPytorch.loadObjectDetectionModel(
          pathObjectDetectionModel, 1, 640, 640,
          labelPath: "assets/labels/labels.txt");
    } catch (e) {
      if (e is PlatformException) {
        print("-only supported for android, Error is $e");
      } else {
        print("-Error is $e");
      }
    }
  }
  FutureOr<void> actualizarPrenda(
      actualizarPrendaEvent event, Emitter<ScannerState> emit) async{
    print('------------actualizarPrenda');

    prendas[_prendaModificar]= event.prenda;
    emit(loadGenerate(prendas));
  }
  FutureOr<void> editarPrendaGenerate(
      editarPrenda event, Emitter<ScannerState> emit) async{
    print('------------editarPrendaGenerate');
    prendaModificar=event.prenda;
    _prendaModificar=event.numero;
    emit(editateState());
  }
  FutureOr<void> emitterImageScan(
      loadWithImage event, Emitter<ScannerState> emit) async{

    print('------------emitterImageScan');
    prendas.clear();
    await processImage().whenComplete(() {
      prendas.removeAt(0);
      emit(loadGenerate(prendas));
    });

  }
  FutureOr<void> workScanning(
      startScannerList event, Emitter<ScannerState> emit) async{
    await runObjectDetection().whenComplete(() {
      print('Completado------------');
      emit(scanListComplete(_objectModel.renderBoxesOnImage(_image!, _objDetect)));
      //add(loadWithImage());
    });

  }

  Future runObjectDetection() async {

    //pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    _objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.1);
    _objDetect.forEach((element) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    });
    _image = File(image.path);

  }

  Future processImage() async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);



    final imageFile = File(_image!.path);
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    final widtht = decodedImage.width;
    final height= decodedImage.height;

    final cropImage crop=cropImage();

// Ordenar la lista objDetect por el atributo 'top' de forma ascendente
    _objDetect.sort((a, b) {
      final topA = a!.rect.top*height;
      final topB = b!.rect.top*height;

      if (topA < topB) {
        return -1;
      } else if (topA > topB) {
        return 1;
      } else {
        return 0;
      }
    });
    List<List<ResultObjectDetection?>> groupedLists = [];
    int index = 0;

    while (index < _objDetect.length) {
      List<ResultObjectDetection?> group = _objDetect.sublist(index, index + 5);
      group.sort((a, b) {
        final leftA = a!.rect.left*widtht;
        final leftB = b!.rect.left*widtht;
        if (leftA < leftB) {
          return -1;
        } else if (leftA > leftB) {
          return 1;
        } else {
          return 0;
        }
      });

      groupedLists.add(group);
      index += 5;
    }
    int contador=0;
    emit(loadingGenerate('${contador}/${groupedLists.length}'));

// Imprimir los grupos ordenados
    for (List<ResultObjectDetection?> group in groupedLists) {
      List<String> listaMenor=[];
      String problema='0';
      for (ResultObjectDetection? detection in group) {
        final left = (detection!.rect.left*widtht).toInt();
        final top = (detection.rect.top*height).toInt();
        final width=(detection.rect.width*widtht).toInt();
        final heigh=(detection.rect.height*height).toInt();

        final InputImage imo=await crop.processImage(_image!.path,left,top,width,heigh);
        final RecognizedText recognizedText = await textRecognizer.processImage(imo);
        String textoIngresar;
        if(recognizedText.text.isEmpty){
          textoIngresar='??';
          problema='1';
        }else{
          textoIngresar=recognizedText.text;
        }
        listaMenor.add(textoIngresar);
        controller.text +='-$textoIngresar';
      }
      // 0 si no tiene algun problema y 1 si lo tiene
      final prenIngresar=Prenda(id: problema, echo: false, nombres: listaMenor[0].split(' '), numero: listaMenor[1], sexo: listaMenor[3], talla: listaMenor[2], tipo: listaMenor[4]);
      prendas.add(prenIngresar);
      emit(loadingGenerate('${contador}/${groupedLists.length}'));
      contador++;
      controller.text += '\n';
      _letterList.add(listaMenor);

    }



  }

}