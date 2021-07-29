import 'package:plottertopicos/modelos/poligono.dart';

class Objeto {

  List<Poligono> _poligonos;
  String _nombre;
  bool _tipo;
  
  Objeto() {
    _poligonos = [];
    _tipo = false;
  }

  void setNombre(String nombre) {
    this._nombre = nombre;
  }

  String get getNombre => this._nombre;

  bool get getTipo => this._tipo;

  void setTipo(bool tipo) {
    this._tipo = tipo;
  }

  void insertarPoligono(Poligono poligono) => this._poligonos.add(poligono);

  Poligono getLastPoligono() => this._poligonos[this._poligonos.length - 1];

  int getLengthPoligonos() {
    return this._poligonos.length;
  }

  Poligono getPoligono(int index) {
    return this._poligonos[index];
  }

  void eliminarPoligono(Poligono poligono) {
    this._poligonos.remove(poligono);
  }

  bool existePoligono(Poligono poligono) {
    return this._poligonos.contains(poligono);
  }

  void eliminarPoligonoAux() {
    this._poligonos.removeLast();
  }

  void insertarPoligonoAux() {
    this._poligonos.add(new Poligono());
  }
}