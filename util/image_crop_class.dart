


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:ui' as ui;



class cropImage{
  Future<InputImage> saveImageAndGetInputImage(ui.Image image) async {
    final byteData = await image.toByteData();
    final buffer = byteData!.buffer;
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/cropped_image.png';
    print("sssssssssssssssss------"+filePath);
    // Guardar la imagen recortada en el directorio temporal
    final file = File(filePath);
    await file.writeAsBytes(buffer.asUint8List());

    // Crear un InputImage a partir del archivo guardado
    final inputImage = InputImage.fromFilePath(file.path);

    return inputImage;
  }
  Future<Uint8List> getImageBytes(String filePath) async {

    final file = File(filePath);

    // Leer los bytes del archivo de imagen
    final bytes = await file.readAsBytes();

    // Decodificar la imagen utilizando la biblioteca image
    final decodedImage = img.decodeImage(bytes);

    // Codificar la imagen nuevamente en un formato compatible (por ejemplo, PNG)
    final encodedImage = img.encodePng(decodedImage!);

    // Retornar los bytes de la imagen codificada
    return Uint8List.fromList(encodedImage);
  }

  Future<InputImage> processImage(String filePath,int xs,int ys, int wit, int he) async {
    final objectDetections = /* Obtain the object detection results */ [];

    /*for (var detection in objectDetections) {
      final left = detection.left.toInt();
      final top = detection.top.toInt();
      final width = detection.width.toInt();
      final height = detection.height.toInt();
    }*/

    final imageBytes = await getImageBytes(filePath);
    final byteData = imageBytes.buffer.asUint8List();
    final decodedImage = img.decodeImage(byteData)!;
    img.Image croppedImage;
    if(wit<100){
      croppedImage = img.copyCrop(decodedImage, x: xs, y:ys, width: 100, height: 45);
    }else{
      croppedImage = img.copyCrop(decodedImage, x: xs, y:ys, width: wit, height: 45);
    }

    final File outputFile = File('/data/user/0/com.example.sistemas_queek/cache/output.jpg');
    await outputFile.writeAsBytes(img.encodeJpg(croppedImage));
    final inputImage = InputImage.fromFile(outputFile);
    return inputImage;

    //return await saveImageAndGetInputImage(croppedUiImage);
  }
}