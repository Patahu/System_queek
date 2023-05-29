import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_pytorch/pigeon.dart';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import 'package:sistemas_queek/features/home/homebloc/home_bloc.dart';
import 'package:sistemas_queek/features/home/ui/prendaWigget.dart';


import '../../../util/image_crop_class.dart';
import '../../../util/prenda.dart';
import '../scannerbloc/scanner_bloc.dart';
import 'YolovScanerLoaderState.dart';
import 'font.dat.dart';


class HomeScreen extends StatefulWidget {
  final HomeBloc homeBloc;
  const HomeScreen({super.key,required this.homeBloc});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScannerBloc scannerBloc=ScannerBloc();

  @override
  void initState() {
    super.initState();
    scannerBloc.add(LoadModels());
    //loadModel();
  }

  /*Future loadModel() async {
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

  void handleTimeout() {
    // callback function
    // Do some work.
    setState(() {
      firststate = true;
    });
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  //running detections on image
  Future runObjectDetection() async {
    setState(() {
      firststate = false;
      message = false;
    });
    //pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.1);
    objDetect.forEach((element) {
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
    scheduleTimeout(5 * 1000);

    setState(() {
      _image = File(image.path);

    });
  }*/

  @override
  Widget build(BuildContext context) {
    return withFond(result:
      Scaffold(
        appBar: AppBar(title: const Text("Scanner de lista",style: TextStyle(color: Colors.black),),backgroundColor: Color(0xFFFFE5A7),iconTheme:IconThemeData(color: Colors.black)),
        backgroundColor: Colors.transparent,
        body: Center(
            child:
            ListView(
          scrollDirection: Axis.vertical,
          children: [

            //Image with Detections....
            BlocBuilder(
                bloc: scannerBloc,
                buildWhen: (previous, current) {
                    return current is ActionStateScanner;
                  },
                builder: (context,state){
                  if(state.runtimeType == LoadScanner){
                    return const LoaderState();
                  }else if(state.runtimeType == scanListComplete){
                    final scan=state as scanListComplete;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 250,
                      child: scan.render,
                    );
                  }
                  return Center(child: Text("Seleccionar foto de lista",style: TextStyle(color: Colors.white),));
                 },
            ),
            BlocBuilder(
              bloc: scannerBloc,
                buildWhen: (previous, current) {
                  return current is ActionStateGenerator;
                },
                builder: (context,state){
                if(state.runtimeType == loadingGenerate){
                  final successState=state as loadingGenerate;
                  return  Center(
                    child: Text('Generando:${successState.cantidad}',style: TextStyle(color: Colors.white),),
                  );
                }else if(state.runtimeType == editateState){
                  return DataInputWidgetGenerate(scannerBloc,scannerBloc.prendaModificar!);
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: scannerBloc.prendas.isEmpty ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/icon/VACIO.png',
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(width: 10), // Espacio entre las imágenes
                          Image.asset(
                            'lib/icon/PRENDALISTA.png',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      Text('Lista de prendas vacía',
                          style:TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold)),
                    ],
                  ):
                  ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: scannerBloc.prendas.length,
                    itemBuilder: (context, index) {
                      final prenda=scannerBloc.prendas[index];
                      return Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color:prenda.id!='1' ? Colors.green:Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Nombres',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              prenda.nombres.join(", "),
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Número',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  prenda.numero,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),

                                Text(
                                  'Sexo',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  prenda.sexo,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),

                                Text(
                                  'Talla',
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  prenda.talla,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),

                            Text(
                              'Tipo',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              prenda.tipo,
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // Lógica para el botón de eliminar
                                    },
                                    icon: Image.asset('lib/icon/ELIMINAR.png'),
                                  ),
                                ),
                                SizedBox(width: 10), // Espacio entre los botones
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // Lógica para el botón de editar
                                      scannerBloc.add(editarPrenda(prenda,index));
                                    },
                                    icon: Image.asset('lib/icon/EDITAR.png'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );

            }),
            //Button to click pic
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    scannerBloc.add(startScannerList());
                    //runObjectDetection();
                  },
                  child: const Icon(Icons.photo),
                ),
                ElevatedButton(
                  onPressed: () {
                    scannerBloc.add(loadWithImage());
                    //processImage();
                  },
                  child: const Icon(Icons.abc_outlined),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.homeBloc.add(eventIngresarPrendasDeGenerador(scannerBloc.prendas));
                    //scannerBloc.add(loadWithImage());
                    //processImage();
                  },
                  child: const Icon(Icons.file_upload),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }

  /*processImage() async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);



    final imageFile = File(_image!.path);
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    final widtht = decodedImage.width;
    final height= decodedImage.height;

    final cropImage crop=cropImage();

// Ordenar la lista objDetect por el atributo 'top' de forma ascendente
    objDetect.sort((a, b) {
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

    while (index < objDetect.length) {
      List<ResultObjectDetection?> group = objDetect.sublist(index, index + 5);
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

// Imprimir los grupos ordenados
    for (List<ResultObjectDetection?> group in groupedLists) {
      List<String> listaMenor=[];
      for (ResultObjectDetection? detection in group) {
        final left = (detection!.rect.left*widtht).toInt();
        final top = (detection.rect.top*height).toInt();
        final width=(detection.rect.width*widtht).toInt();
        final heigh=(detection.rect.height*height).toInt();

        InputImage imo=await crop.processImage(_image!.path,left,top,width,heigh);
        final RecognizedText recognizedText = await textRecognizer.processImage(imo);
        final String textoIngresar=recognizedText.text.isEmpty?'??':recognizedText.text;
        listaMenor.add(textoIngresar);
        controller.text +='-$textoIngresar';
      }
      controller.text += '\n';
      letterList.add(listaMenor);

    }



  }*/
}

class DataInputWidgetGenerate extends StatefulWidget {
  final ScannerBloc scannerBloc;
  final Prenda prenda;
  DataInputWidgetGenerate(this.scannerBloc,this.prenda);
  @override
  _DataInputWidgetState createState() => _DataInputWidgetState();
}

class _DataInputWidgetState extends State<DataInputWidgetGenerate> {
  String _id = '';
  bool _echo = false;
  List<String> _nombres = [];

  String _sexo = 'Varón';
  String _talla = 'M';
  String _tipo = 'M.Larga';
  String _numero='';
  TextEditingController _controllerName=TextEditingController();
  TextEditingController _numeroController=TextEditingController(text:'');
  ScannerBloc get _scannerBloc => widget.scannerBloc;
  Prenda get _prenda => widget.prenda;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_prenda.numero);
    _controllerName.text = _prenda.nombres.join(' ');;
    _numero=_prenda.numero;
    _nombres=_prenda.nombres;
    _numeroController.text = _prenda.numero;
     _sexo = _prenda.sexo!='??'?_prenda.sexo:'Varón';
     _talla =_prenda.talla!='??'?_prenda.talla:'M';
     _tipo = _prenda.tipo!='??'?_prenda.tipo:'M.Larga';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.transparent,

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.lightGreen, // Cambia el color del contenedor aquí
          borderRadius: BorderRadius.circular(10), // Establece el radio de los bordes aquí
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: TextField(
                      controller:_controllerName,
                        decoration: InputDecoration(
                          labelText: _nombres.isEmpty? 'Nombre 1, Nombre2 ':'',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _nombres = value.split(',');
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: TextField(
                        controller: _numeroController,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                        decoration: InputDecoration(
                          labelText: _numero.isEmpty ? 'Número' : '',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _numero = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _sexo,

                        ),
                        value: 'Varón',
                        onChanged: (value) {
                          setState(() {
                            _sexo = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Varón',
                            child: Text('Varón'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Mujer',
                            child: Text('Mujer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _talla,

                        ),
                        value: _talla,
                        onChanged: (value) {
                          setState(() {
                            _talla = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'M',
                            child: Text('M'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'S',
                            child: Text('S'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _tipo,

                        ),
                        value: _tipo,
                        onChanged: (value) {
                          setState(() {
                            _tipo = value!;
                          });

                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'M.Corta',
                            child: Text('M.Corta'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'M.Larga',
                            child: Text('M.Larga'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _scannerBloc.add(actualizarPrendaEvent(Prenda(id: '0', echo: false, nombres: _nombres, numero: _numeroController.text, sexo: _sexo, talla: _talla, tipo: _tipo)));
                // Lógica para el botón "Ingresar Prenda"
              },
              child: Text('Modificar Prenda'),
            ),
          ],
        ),
      ),
    );
  }
}