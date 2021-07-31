import 'punto.dart';

class Poligono {

  List<Punto> _puntos;
  bool _tipo;
  int _color;

  Poligono() {
    _puntos = [];
    _tipo = true;
    _color = 0xff000000;
  }

  set puntos(List<Punto> puntos) {
    this._puntos = puntos;
  }

  void setTipo(bool value) => this._tipo = value;

  void setColor(int color) {
    this._color = color;
  }

  int get getColor => this._color;

  bool get getTipo => this._tipo;

  void insertarPunto(Punto punto) => this._puntos.add(punto);

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

  Map<String, dynamic> toJson() => {
    'tipo': this._tipo,
    'color': this._color,
    'puntos': List<dynamic>.from(this._puntos.map((punto) => punto.toJson()))
  };

  factory Poligono.fromJson(Map<String, dynamic> data) {
    Poligono poligono = Poligono();
    poligono.setTipo(data['tipo']);
    poligono.setColor(data['color']);
    poligono.puntos = List<Punto>.from(data['puntos'].map((punto) => Punto.fromJson(punto)));
    return poligono;
  }

}
