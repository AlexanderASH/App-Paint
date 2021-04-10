import 'objeto.dart';

class Escenario {

  List<Objeto> objetos;
  
  Escenario() {
    objetos = [];
  }

  void insertarObjeto(Objeto objeto) => objetos.add(objeto);

  int getLengthObjetos() {
    return this.objetos.length;
  }

  Objeto getObjeto(int index) {
    return this.objetos[index];
  }

  void eliminarObjeto(int index) {
    this.objetos.removeAt(index);
  }

  void eliminarObjetoValue(Objeto objeto) {
    this.objetos.remove(objeto);
  }
  
  //Donde se dibujan los poligonos que no pertenecen a ningun objeto
  Objeto getObjetoBase() {
    return this.objetos[0];
  }
}
