import 'objeto.dart';

class Escenario {

  List<Objeto> _objetos;
  
  Escenario() {
    this._objetos = [];
  }

  set objetos(List<Objeto> objetos) {
    this._objetos = objetos;
  }

  void insertarObjeto(Objeto objeto) {
    this._objetos.add(objeto);
  }

  int getLengthObjetos() {
    return this._objetos.length;
  }

  Objeto getObjeto(int index) {
    return this._objetos[index];
  }

  void eliminarObjeto(int index) {
    this._objetos.removeAt(index);
  }

  void eliminarObjetoValue(Objeto objeto) {
    this._objetos.remove(objeto);
  }
  
  Objeto getObjetoBase() {
    return this._objetos[0];
  }

  Map<String, dynamic> toJson() => {
    'objetos': List<dynamic>.from(this._objetos.map((objeto) => objeto.toJson()))
  };

  factory Escenario.fromJson(Map<String, dynamic> data) {
    Escenario escenario = Escenario();
    escenario.objetos = List<Objeto>.from(data['objetos'].map((objeto) => Objeto.fromJson(objeto)));
    return escenario;
  }
}
