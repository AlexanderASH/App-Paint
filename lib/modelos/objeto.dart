import 'package:plottertopicos/modelos/poligono.dart';

class Objeto {

  List<Poligono> _poligonos;
  String _nombre;
  bool _tipo;
  
  Objeto() {
    _poligonos = [];
    _tipo = false;
  }

  set poligonos(List<Poligono> poligonos) {
    this._poligonos = poligonos;
  }

  void setNombre(String nombre) {
    this._nombre = nombre;
  }

  void setTipo(bool tipo) {
    this._tipo = tipo;
  }

  String get getNombre => this._nombre;

  bool get getTipo => this._tipo;

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

  Map<String, dynamic> toJson() => {
    'nombre': this._nombre,
    'tipo': this._tipo,
    'poligonos': List<dynamic>.from(this._poligonos.map((poligono) => poligono.toJson()))
  };

  factory Objeto.fromJson(Map<String, dynamic> data) {
    Objeto objeto = Objeto();
    objeto.setNombre(data['nombre']);
    objeto.setTipo(data['tipo']);
    objeto.poligonos = List<Poligono>.from(data['poligonos'].map((poligono) => Poligono.fromJson(poligono)));
    return objeto;
  }
}