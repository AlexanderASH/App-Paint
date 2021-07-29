import 'objeto.dart';

class Escenario {

  List<Objeto> _objetos;
  
  Escenario() {
    this._objetos = [];
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
}
