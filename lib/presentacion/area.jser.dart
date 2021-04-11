// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$PuntoJsonSerializer implements Serializer<Punto> {
  @override
  Map<String, dynamic> toMap(Punto model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'getX', model.getX);
    setMapValue(ret, 'getY', model.getY);
    return ret;
  }

  @override
  Punto fromMap(Map map) {
    if (map == null) return null;
    final obj = Punto(getJserDefault('_x'), getJserDefault('_y'));
    return obj;
  }
}

abstract class _$PoligonoJsonSerializer implements Serializer<Poligono> {
  @override
  Map<String, dynamic> toMap(Poligono model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'getColor', model.getColor);
    setMapValue(ret, 'getTipo', model.getTipo);
    return ret;
  }

  @override
  Poligono fromMap(Map map) {
    if (map == null) return null;
    final obj = Poligono();
    return obj;
  }
}

abstract class _$ObjetoJsonSerializer implements Serializer<Objeto> {
  @override
  Map<String, dynamic> toMap(Objeto model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'getNombre', model.getNombre);
    setMapValue(ret, 'getTipo', model.getTipo);
    return ret;
  }

  @override
  Objeto fromMap(Map map) {
    if (map == null) return null;
    final obj = Objeto();
    return obj;
  }
}

abstract class _$EscenarioJsonSerializer implements Serializer<Escenario> {
  @override
  Map<String, dynamic> toMap(Escenario model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    return ret;
  }

  @override
  Escenario fromMap(Map map) {
    if (map == null) return null;
    final obj = Escenario();
    return obj;
  }
}

abstract class _$ControladorJsonSerializer implements Serializer<Controlador> {
  Serializer<Escenario> __escenarioJsonSerializer;
  Serializer<Escenario> get _escenarioJsonSerializer =>
      __escenarioJsonSerializer ??= EscenarioJsonSerializer();
  Serializer<Objeto> __objetoJsonSerializer;
  Serializer<Objeto> get _objetoJsonSerializer =>
      __objetoJsonSerializer ??= ObjetoJsonSerializer();
  Serializer<Poligono> __poligonoJsonSerializer;
  Serializer<Poligono> get _poligonoJsonSerializer =>
      __poligonoJsonSerializer ??= PoligonoJsonSerializer();
  @override
  Map<String, dynamic> toMap(Controlador model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'escenario', _escenarioJsonSerializer.toMap(model.escenario));
    setMapValue(ret, 'objeto', _objetoJsonSerializer.toMap(model.objeto));
    setMapValue(ret, 'poligono', _poligonoJsonSerializer.toMap(model.poligono));
    setMapValue(ret, 'asignarPrimerPunto', model.asignarPrimerPunto);
    setMapValue(ret, 'width', model.width);
    setMapValue(ret, 'height', model.height);
    setMapValue(
        ret,
        'marcado',
        codeIterable(model.marcado,
            (val) => _poligonoJsonSerializer.toMap(val as Poligono)));
    return ret;
  }

  @override
  Controlador fromMap(Map map) {
    if (map == null) return null;
    final obj = Controlador();
    obj.escenario = _escenarioJsonSerializer.fromMap(map['escenario'] as Map);
    obj.objeto = _objetoJsonSerializer.fromMap(map['objeto'] as Map);
    obj.poligono = _poligonoJsonSerializer.fromMap(map['poligono'] as Map);
    obj.asignarPrimerPunto = map['asignarPrimerPunto'] as bool;
    obj.width = map['width'] as double;
    obj.height = map['height'] as double;
    obj.marcado = codeIterable<Poligono>(map['marcado'] as Iterable,
        (val) => _poligonoJsonSerializer.fromMap(val as Map));
    return obj;
  }
}
