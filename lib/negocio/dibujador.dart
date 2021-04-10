import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plottertopicos/modelos/poligono.dart';
import 'package:plottertopicos/modelos/punto.dart';
import 'package:plottertopicos/modelos/Escenario.dart';
import 'dart:ui' as ui;

class Dibujo extends CustomPainter {
  //Necesario para dibujar 
  Escenario escenario;
  Punto puntoInicial;
  Punto puntoFinal;
  bool asignarPrimerPunto;
  List<Poligono> marcado;//Nuevo
  bool bandera = false;//Nuevo
  
  Dibujo(this.escenario, this.asignarPrimerPunto, this.marcado);

  @override
  bool shouldRepaint(Dibujo old) {
    return true;
  }

  void paint(Canvas canvas, Size size) {

    final pointMode = ui.PointMode.points;
    //recorrido de objetos class Escenario
    // this.escenario.objetos.forEach((objeto) {
    for(int i = 0; i < this.escenario.getLengthObjetos(); i++) {
      //recorrido de poligonos class Objeto
      // objeto.poligonos.forEach((poligono) {
      for(int j = 0; j < this.escenario.getObjeto(i).getLengthPoligonos(); j++){
        final pincel = Paint()
              ..color = Color(this.escenario.getObjeto(i).getPoligono(j).getColor)
              ..strokeWidth = 4;
        (this.marcado.contains(this.escenario.getObjeto(i).getPoligono(j))) ? bandera = true : bandera = false;
        //recorrido de puntos class Poligono
        // poligono.puntos.forEach((punto) {
        for(int k = 0; k < this.escenario.getObjeto(i).getPoligono(j).getLengthPuntos(); k++){
          if (!this.asignarPrimerPunto) {
            this.puntoFinal = this.convertirAbsoluto(this.escenario.getObjeto(i).getPoligono(j).getPunto(k), size);
            if(this.bandera) {
              this.dibujarSelect(canvas, pointMode, puntoFinal.getX,puntoFinal.getY);
            }
            canvas.drawLine(
                Offset(this.puntoInicial.getX, this.puntoInicial.getY),
                Offset(this.puntoFinal.getX, this.puntoFinal.getY),
                pincel
            );
            this.puntoInicial = this.puntoFinal;
          } else {
            Punto p1 = convertirAbsoluto(this.escenario.getObjeto(i).getPoligono(j).getPunto(k), size);
            canvas.drawPoints(
              pointMode, 
              [Offset(p1.getX,p1.getY)], 
              pincel
            );
            this.puntoInicial = this.convertirAbsoluto(this.escenario.getObjeto(i).getPoligono(j).getPunto(k), size);
            if(this.bandera) {
              this.dibujarSelect(canvas, pointMode, puntoInicial.getX, puntoInicial.getY);
            }
            this.asignarPrimerPunto = false;
          }
        }
        this.asignarPrimerPunto = true;
        //Caso poligono cerrado o abierto
        if (!this.escenario.getObjeto(i).getPoligono(j).getTipo) {
          Punto punto=this.convertirAbsoluto(this.escenario.getObjeto(i).getPoligono(j).getPrimerPunto(), size);
          canvas.drawLine(
              Offset(punto.getX,punto.getY),
              Offset(this.puntoInicial.getX, this.puntoInicial.getY),
              pincel);
        }
      }
    }
  }

  Punto convertirAbsoluto(Punto punto,Size size) {
    double width = size.width / 2;
    double height = size.height / 2;
    double x = punto.getX + width;
    double y = punto.getY - height;
    return new Punto(x, (-1 * y));
  }

  dibujarSelect(Canvas canvas, ui.PointMode pointMode, double x, double y) {
    final pincel2 = Paint()
          ..color = Colors.green
          ..strokeWidth = 15;
          canvas.drawPoints(pointMode, [Offset(x,y)], pincel2);
  }
}
