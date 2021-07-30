import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:plottertopicos/modelos/punto.dart';
import 'package:plottertopicos/modelos/poligono.dart';
import 'package:plottertopicos/modelos/Escenario.dart';
import 'package:plottertopicos/modelos/objeto.dart';
import 'package:plottertopicos/negocio/controlador.dart';
import 'package:plottertopicos/negocio/dibujador.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_colorpicker/material_picker.dart';
part 'area.jser.dart';

@GenSerializer()
class PuntoJsonSerializer extends Serializer<Punto> with _$PuntoJsonSerializer {
}

@GenSerializer()
class PoligonoJsonSerializer extends Serializer<Poligono>
    with _$PoligonoJsonSerializer {}

@GenSerializer()
class ObjetoJsonSerializer extends Serializer<Objeto>
    with _$ObjetoJsonSerializer {}

@GenSerializer()
class EscenarioJsonSerializer extends Serializer<Escenario>
    with _$EscenarioJsonSerializer {}

@GenSerializer()
class ControladorJsonSerializer extends Serializer<Controlador>
    with _$ControladorJsonSerializer {}

class AreaPage extends StatefulWidget {

  _AreaPageState createState() => _AreaPageState();
}

typedef void OnTap();
class _AreaPageState extends State<AreaPage> {
  Controlador c = new Controlador();
  bool select = true;
  bool selectPunto = true;
  Color currentColor = Colors.amber;
  ControladorJsonSerializer clse = new ControladorJsonSerializer();
  TapPosition _position = TapPosition(Offset.zero, Offset.zero);
  TextEditingController nombreControler = new TextEditingController();
  TextEditingController nombreObjeto = new TextEditingController();
  
  String _fileName;
  String _path;

  List<String> _extension = ['odt'];

  FileType _pickingType = FileType.custom;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    c.width = size.width;
    c.height = size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
            PositionedTapDetector(
              onTap: _onTap,
              onDoubleTap: _onDoubleTap,
              onLongPress: _onLongPress,
              child: CustomPaint(
                size: Size(size.width, size.height),
                painter: Dibujo(c.escenario, c.asignarPrimerPunto,c.marcado),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: PopupMenuButton(
          color: Colors.grey[700],
          tooltip: 'Opciones',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          itemBuilder: (context) => listOption(),
        ),
      ),
    );
  }

  Future _onTap(TapPosition position) async {
    if (this.select) {
        c.insertarPunto(position.global.dx, position.global.dy);
    } else {
      if (this.selectPunto) {
        c.selectPoligono(position.global.dx, position.global.dy);
      } else {
        setState(() {
          c.eliminarPuntoSelect(position.global.dx, position.global.dy);
        });
      }
    }
    _updateState('gesture', position);
  }

  void _onDoubleTap(TapPosition position) {
    c.insertarPunto(position.global.dx, position.global.dy);
    c.cerrarPoligono();
    c.nuevoPoligono();
    _updateState('gesture', position);
  }

  void _onLongPress(TapPosition position) {
    c.nuevoPoligono();
    _updateState('long press', position);
  }

  void _updateState(String gesture, TapPosition position) {
    setState(() {
      _position = position;
    });
  }

  void guardarArchivo(String nombre) async {
    final Map map = clse.toMap(c);
    final file = File('/storage/emulated/0/Download/$nombre.odt');
    await file.writeAsString(json.encode(map));
  }

  void abrirArchivo() async {
    _path = (await FilePicker.platform.pickFiles(
      type: _pickingType, 
      allowedExtensions: _extension)
    ).toString();
    final file = File(_path);
    String text = await file.readAsString();
    Map<String, dynamic> map = json.decode(text);
    Controlador decoded = clse.fromMap(map);
    setState(() {
      c = decoded;
      c.restablecerArea();
    });

    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : '...';
    });
  }

  void _modalGuardar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.green,
          height: 400,
          child: Container(
            child: _cuerpoModal(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              )
            ),
          ),
        );
      }
    );
  }
  Column _cuerpoModal() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.save),
          title: Text('Guardar Como'),
          onTap: () {
          },
        ),
        TextField( controller: nombreControler,),
        ElevatedButton(
          child: Text('Guardar Archivo'),
          onPressed: (){
            guardarArchivo(nombreControler.text);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _mostrarAlerta(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Nuevo Objeto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: TextField(
                  controller: nombreObjeto,
                  decoration:InputDecoration(
                    labelText: 'Nombre del Objeto',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                this.nombreObjeto.text = "";
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                c.crearObjeto(nombreObjeto.text);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      }
    );
  }

  List<PopupMenuEntry<dynamic>> listOption() {
    return <PopupMenuEntry>[
      _createPopupMenuItem(
        title: this.select ? 'Activar Seleccion' : 'Desactivar Seleccion',
        iconData: Icons.select_all,
        onTap: () {
          setState(() {
            this.select = !this.select;
            this.selectPunto = true;
            Navigator.pop(context);
          });
        }
      ),
      _createPopupMenuItem(
        title: 'Limpiar area',
        iconData: Icons.delete_forever,
        onTap: () {
          setState(() {
            c.limpiarArea();
            Navigator.pop(context);
          });
        }
      ),
      if (c.marcado.length == 1 && !c.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Eliminar ultimo punto',
        iconData: Icons.delete_outline,
        onTap: () {
          setState(() {
            c.eliminarLastPunto();
            Navigator.pop(context);
          });
        }
      ),
      if (c.marcado.length == 1 && !c.objeto.getTipo)
      _createPopupMenuItem(
        title: (this.selectPunto) ? 'Activar eliminacion de punto' : 'Desactivar eliminacion de punto',
        iconData: Icons.delete_outline,
        onTap: () {
          setState(() {
            this.selectPunto =! this.selectPunto;
            Navigator.pop(context);
          });
        }
      ),
      if (c.marcado.length >= 1)
      _createPopupMenuItem(
        title: 'Eliminar seleccionados',
        iconData: Icons.delete_sweep,
        onTap: () {
          setState(() {
            c.eliminarSeleccionados();
            Navigator.pop(context);
          });
        }
      ),
      if (c.marcado.length >= 1 && !c.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Crear objeto',
        iconData: Icons.add_circle,
        onTap: () {
          _mostrarAlerta(context);
        }
      ),
      if (c.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Disolver objeto',
        iconData: Icons.add_circle,
        onTap: () {
          c.disolverObjeto();
          Navigator.pop(context);
        }
      ),
      if (c.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Fusionar objeto',
        iconData: Icons.add_box,
        onTap: () {
          c.fusionarObjeto();
          Navigator.pop(context);
        }
      ),
      _createPopupMenuItem(
        title: 'Abrir',
        iconData: Icons.open_in_browser,
        onTap: () {
          setState(() {
            abrirArchivo();
            Navigator.pop(context);
          });
        }
      ),
      _createPopupMenuItem(
        title: 'Guardar',
        iconData: Icons.save,
        onTap: () {
          setState(() {
            Navigator.pop(context);
            _modalGuardar();
          });
        }
      ),
      if (c.marcado.length > 0)
      _createPopupMenuItem(
        title: 'Color',
        iconData: Icons.color_lens,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titlePadding: const EdgeInsets.all(0.0),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: MaterialPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                    enableLabel: true,
                  ),
                ),
              );
            },
          );
        }
      ),
    ];
  }
  
  void changeColor(Color color){
    setState(() => currentColor = color);
    c.cambiarColor(this.currentColor.value);
    Navigator.pop(context);
  }

  PopupMenuItem _createPopupMenuItem({String title, IconData iconData, OnTap onTap}) {
    return PopupMenuItem(
      child: ListTile(
        title: Text(
          title, 
          style: TextStyle(
            color: Colors.white, 
            fontSize: 15.0,
            fontWeight: FontWeight.bold
          )
        ),
        leading: Icon(iconData, color: Colors.yellowAccent,),
        onTap: onTap,
      ),
    );
  }
}