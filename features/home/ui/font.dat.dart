import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class withFond extends StatelessWidget {
  const withFond({
    super.key,
    required this.result,

  });

  final Widget result;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.9), // Fondo oscuro con opacidad del 20%
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  Colors.yellow.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 2 - 50,
          left: 10,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  Colors.red.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.7,
                colors: [
                  Colors.blue.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        result,
      ],
    );
  }
}
