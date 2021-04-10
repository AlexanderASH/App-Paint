import 'punto.dart';

class Poligono {

  List<Punto> _puntos;
  bool _tipo;
  int _color;//solo por demostracion

  Poligono() {
    _puntos = [];
    _tipo=true;
    _color= 0xff000000;
  }

  void setTipo(bool value) => this._tipo = value;

  void setColor(int color) {
    this._color = color;
  }

  int get getColor => this._color;

  bool get getTipo => this._tipo;

  void insertarPunto(Punto punto) => this._puntos.add(punto);

  //Funcion para obtener Punto en el caso de poligono cerrado
  Punto getPrimerPunto() => this._puntos[0];

  void eliminarLastPunto() {
    this._puntos.removeLast();
  }

  int getLengthPuntos() {
    return this._puntos.length;
  }

  Punto getPunto(int index) {
    return this._puntos[index];
  }

  void eliminarPunto(int index) {
    this._puntos.removeAt(index);
  }

}
