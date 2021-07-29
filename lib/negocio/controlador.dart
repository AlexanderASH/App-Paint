import 'dart:math';

import 'package:plottertopicos/modelos/Inside.dart';
import 'package:plottertopicos/modelos/poligono.dart';

import 'package:plottertopicos/modelos/Escenario.dart';
import 'package:plottertopicos/modelos/objeto.dart';
import 'package:plottertopicos/modelos/punto.dart';

class Controlador {

  Escenario escenario;
  Objeto objeto;
  Poligono poligono;
  bool asignarPrimerPunto;
  double width;
  double height;
  List<Poligono> marcado;

  Controlador() {
    escenario = new Escenario();
    objeto = new Objeto();
    poligono = new Poligono();
    asignarPrimerPunto = true;
    marcado = <Poligono>[];
    iniciarArea();
  }

  void restablecerArea() {
    this.objeto = this.escenario.getObjetoBase();
    this.poligono = this.objeto.getLastPoligono();
  }

  void iniciarArea() {
    this.objeto.insertarPoligono(this.poligono);
    this.escenario.insertarObjeto(this.objeto);
  }

  void nuevoPoligono() {
    Poligono newPoligono = new Poligono();
    this.objeto.insertarPoligono(newPoligono);
    this.poligono = newPoligono;
  }

  void cerrarPoligono() {
    poligono.setTipo(false);
  }

  void insertarPunto(double x, double y) {
    x = conversionRelativaX(x);
    y = conversionRelativaY(y);
    this.poligono.insertarPunto(new Punto(x, y));
  }

  double conversionRelativaY(double valor) {
    return this.height - valor;
  }

  double conversionRelativaX(double valor) {
    calcularOrigen();
    return valor - this.width;
  }

  void calcularOrigen() {
    this.width = this.width / 2;
    this.height = this.height / 2;
  }

  Punto convertirAbsoluto(Punto punto) {
    double x = punto.getX + width / 2;
    double y = punto.getY - height / 2;
    return new Punto(x, (-1 * y));
  }

  limpiarArea() {
    escenario = new Escenario();
    objeto = new Objeto();
    poligono = new Poligono();
    asignarPrimerPunto = true;
    iniciarArea();
    this.marcado.clear();
  }

  void selectPoligono(double x, double y) {
    x = conversionRelativaX(x);
    y = conversionRelativaY(y);
    for (int i = 0; i < this.escenario.getLengthObjetos(); i++) {
      for (int j = this.escenario.getObjeto(i).getLengthPoligonos() - 2; j >= 0; j--) {
        bool isWithinPoligono = PointLocal().pointInPolygon(Punto(x,y), this.escenario.getObjeto(i).getPoligono(j));
        if (isWithinPoligono) {
          if (i == 0) {
            if (this.marcado != null && this.marcado.contains(this.escenario.getObjeto(i).getPoligono(j))) {
              this.marcado.remove(this.escenario.getObjeto(i).getPoligono(j));
            } else {
              this.marcado.add(this.escenario.getObjeto(i).getPoligono(j));
            }
            if (this.marcado.length == 1) {
              this.poligono = this.marcado[0];
            } else {
              this.poligono = this.escenario.getObjeto(i).getLastPoligono();
            }
            return;
          } else {
            if (this.marcado != null && this.marcado.contains(this.escenario.getObjeto(i).getPoligono(j))) {
              this.objeto = this.escenario.getObjeto(i);
              deseleccionarObjeto();
              this.objeto = this.escenario.getObjeto(0);
            } else {
              this.objeto = this.escenario.getObjeto(i);
              marcarTodoObject();
            }
            this.poligono = this.objeto.getLastPoligono();
            return;
          }
        }
      }
    }
  }

  cambiarColor(int color) {
    for (int i = 0; i < this.marcado.length; i++) {
      this.marcado[i].setColor(color);
    }
  }

  marcarTodoObject() {
    for (int i = 0; i < this.objeto.getLengthPoligonos() - 1; i++) {
      this.marcado.add(this.objeto.getPoligono(i));
    }
  }

  deseleccionarObjeto() {
    for (int i = 0; i < this.marcado.length; i++) {
      if (this.objeto.existePoligono(this.marcado[i])) {
        this.marcado.removeAt(i);
        i--;
      }
    }
  }
  
  eliminarLastPunto() {
    this.poligono.eliminarLastPunto();
  }

  eliminarPuntoSelect(double x, double y) {
    for (int i = 0; i < this.poligono.getLengthPuntos(); i++) {
      if (estaRango(this.convertirAbsoluto(this.poligono.getPunto(i)), Punto(x, y))) {
        this.poligono.eliminarPunto(i);
        if (this.poligono.getLengthPuntos() == 0) {
          this.objeto.eliminarPoligono(this.poligono);
          this.poligono = this.objeto.getLastPoligono();
        }
        return;
      }
    }
  }

  bool estaRango(Punto a, Punto b) {
    double rango = sqrt((pow((b.getX - a.getX), 2)) + (pow((b.getY - a.getY), 2)));
    return (rango.abs() >= 0 && rango.abs() <= 15);
  }

  eliminarSeleccionados() {
    if (this.escenario.getLengthObjetos() > 1) {
      this.eliminarObjeSelect();
    }
    if (this.marcado.length > 0) {
      this.eliminarPoligSelect();
    }
    this.poligono = this.objeto.getLastPoligono();
  }

  eliminarObjeSelect() {
    for (int i = 1; i < this.escenario.getLengthObjetos(); i++) {
      for (int j = 0; j < this.marcado.length; j++) {
        if (this.escenario.getObjeto(i).existePoligono(this.marcado[j])) {
          int length = this.escenario.getObjeto(i).getLengthPoligonos() - 1;
          this.marcado.removeRange(j, j + length);
          this.escenario.eliminarObjeto(i);
          i--;
          break;
        }
      }
    }
    this.objeto = this.escenario.getObjetoBase();
  }

  eliminarPoligSelect() {
    for (int i = 0; i < this.marcado.length; i++) {
      this.objeto.eliminarPoligono(this.marcado[i]);
      this.marcado.removeAt(i);
      i--;
    }
  }

  void crearObjeto(String nombre) {
    Objeto newObjeto = new Objeto();
    newObjeto.setNombre(nombre);
    newObjeto.setTipo(true);

    eliminarPoligonos(newObjeto);
    
    newObjeto.insertarPoligonoAux();
    
    this.escenario.insertarObjeto(newObjeto);
    this.objeto = newObjeto;
    this.poligono = this.objeto.getLastPoligono();
  }

  eliminarPoligonos(Objeto objetoAux) {
    for (int i = 0; i < this.marcado.length; i++) {
      if (this.objeto.existePoligono(this.marcado[i])) {
        objetoAux.insertarPoligono(this.marcado[i]);
        this.objeto.eliminarPoligono(this.marcado[i]);
      }
    }
  }

  disolverObjeto() {
    this.escenario.getObjetoBase().eliminarPoligonoAux();
    for (int i = 0; i < this.marcado.length; i++) {
      this.escenario.getObjetoBase().insertarPoligono(this.marcado[i]);
    }
    this.escenario.eliminarObjetoValue(this.objeto);
    this.objeto = this.escenario.getObjetoBase();
    this.objeto.insertarPoligonoAux();
  }

  fusionarObjeto() {
    this.objeto.eliminarPoligonoAux();
    for (int i = 0; i < this.marcado.length; i++) {
      if (!this.objeto.existePoligono(this.marcado[i])) {
        this.objeto.insertarPoligono(this.marcado[i]);
        this.escenario.getObjetoBase().eliminarPoligono(this.marcado[i]);
      }
    }
    this.objeto.insertarPoligonoAux();
  }

  eliminarPoligonoVacio() {
    this.objeto.eliminarPoligonoAux();
  }

  addPoligonoVacio() {
    this.objeto.insertarPoligono(new Poligono());
  }
}

