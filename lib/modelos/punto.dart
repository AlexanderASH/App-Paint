class Punto {
  double _x;
  double _y;

  Punto(this._x, this._y);

  double get getX => this._x;
  double get getY => this._y;

  Map<String, dynamic> toJson() => {
    'x': this._x,
    'y': this._y
  };

  factory Punto.fromJson(Map<String, dynamic> data) => Punto(data['x'], data['y']);
}
 