import 'dart:math';
import 'package:plottertopicos/modelos/poligono.dart';
import 'package:plottertopicos/modelos/punto.dart';

class PointLocal {
   bool pointInPolygon(Punto punto, Poligono poligono) {
    int interseccion = 0; 

    for (int i = 1; i < poligono.getLengthPuntos(); i++) {
      Punto puntoA = poligono.getPunto(i - 1); 
      Punto puntoB = poligono.getPunto(i);
      // Checar si el punto está en un segmento horizontal
      if (
        puntoA.getY == puntoB.getY && 
        puntoA.getY == punto.getY && 
        punto.getX > min(puntoA.getX, puntoB.getX) && 
        punto.getX < max(puntoA.getX, puntoB.getX)
      ) {
        return true;
      }

      if (
        punto.getY > min(puntoA.getY, puntoB.getY) && 
        punto.getY <= max(puntoA.getY, puntoB.getY) && 
        punto.getX <= max(puntoA.getX, puntoB.getX) && 
        puntoA.getY != puntoB.getY
        ) { 
          double xinters = (punto.getY - puntoA.getY) * (puntoB.getX - puntoA.getX) / (puntoB.getY - puntoA.getY) + puntoA.getX; 
          // Checar si el punto está en un segmento (otro que horizontal)
          if (xinters == punto.getX) { 
            return true;
          }
          
          if (puntoA.getX == puntoB.getX || punto.getX <= xinters) {
            interseccion++; 
          }
      } 
    } 
    // Si el número de intersecciones es impar, el punto está dentro del poligono. 
    if (interseccion % 2 != 0) {
      return true;
    }

    return false;
  }
}
