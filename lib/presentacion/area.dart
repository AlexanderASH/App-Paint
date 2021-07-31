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
  Controlador controller;
  bool select;
  bool selectPoint;
  Color currentColor;
  ControladorJsonSerializer jsonSerializer;
  TapPosition position;
  TextEditingController fileNameController;
  TextEditingController pictureNameController;
  
  String _fileName;
  String _path;

  List<String> _extension = ['odt'];

  FileType _pickingType = FileType.custom;

  @override
  void initState() { 
    super.initState();
    this.controller = Controlador();
    this.select = true;
    this.selectPoint = true;
    this.currentColor = Colors.amber;
    this.jsonSerializer = ControladorJsonSerializer();
    this.position = TapPosition(Offset.zero, Offset.zero);
    this.fileNameController = TextEditingController();
    this.pictureNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    this.controller.width = size.width;
    this.controller.height = size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
            PositionedTapDetector(
              onTap: this._onTap,
              onDoubleTap: this._onDoubleTap,
              onLongPress: this._onLongPress,
              child: CustomPaint(
                size: Size(size.width, size.height),
                painter: Dibujo(
                  this.controller.escenario, 
                  this.controller.asignarPrimerPunto,
                  this.controller.marcado
                ),
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
          itemBuilder: (context) => this.listOption(),
        ),
      ),
    );
  }

  Future _onTap(TapPosition position) async {
    if (this.select) {
        this.controller.insertarPunto(position.global.dx, position.global.dy);
    } else {
      if (this.selectPoint) {
        this.controller.selectPoligono(position.global.dx, position.global.dy);
      } else {
        setState(() {
          this.controller.eliminarPuntoSelect(position.global.dx, position.global.dy);
        });
      }
    }
    this._updateState('gesture', position);
  }

  void _onDoubleTap(TapPosition position) {
    this.controller.insertarPunto(position.global.dx, position.global.dy);
    this.controller.cerrarPoligono();
    this.controller.nuevoPoligono();
    this._updateState('gesture', position);
  }

  void _onLongPress(TapPosition position) {
    this.controller.nuevoPoligono();
    this._updateState('long press', position);
  }

  void _updateState(String gesture, TapPosition position) {
    setState(() {
      this.position = position;
    });
  }

  void guardarArchivo(String nombre) async {
    final Map map = this.jsonSerializer.toMap(this.controller);
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
    Controlador decoded = this.jsonSerializer.fromMap(map);
    setState(() {
      this.controller = decoded;
      this.controller.restablecerArea();
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
        TextField( controller: this.fileNameController,),
        ElevatedButton(
          child: Text('Guardar Archivo'),
          onPressed: () {
            guardarArchivo(this.fileNameController.text);
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
                  controller: this.pictureNameController,
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
                this.pictureNameController.text = "";
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                this.controller.crearObjeto(this.pictureNameController.text);
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
            this.selectPoint = true;
            Navigator.pop(context);
          });
        }
      ),
      _createPopupMenuItem(
        title: 'Limpiar area',
        iconData: Icons.delete_forever,
        onTap: () {
          setState(() {
            this.controller.limpiarArea();
            Navigator.pop(context);
          });
        }
      ),
      if (this.controller.marcado.length == 1 && !this.controller.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Eliminar ultimo punto',
        iconData: Icons.delete_outline,
        onTap: () {
          setState(() {
            this.controller.eliminarLastPunto();
            Navigator.pop(context);
          });
        }
      ),
      if (this.controller.marcado.length == 1 && !this.controller.objeto.getTipo)
      _createPopupMenuItem(
        title: (this.selectPoint) ? 'Activar eliminacion de punto' : 'Desactivar eliminacion de punto',
        iconData: Icons.delete_outline,
        onTap: () {
          setState(() {
            this.selectPoint =! this.selectPoint;
            Navigator.pop(context);
          });
        }
      ),
      if (this.controller.marcado.length >= 1)
      _createPopupMenuItem(
        title: 'Eliminar seleccionados',
        iconData: Icons.delete_sweep,
        onTap: () {
          setState(() {
            this.controller.eliminarSeleccionados();
            Navigator.pop(context);
          });
        }
      ),
      if (this.controller.marcado.length >= 1 && !this.controller.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Crear objeto',
        iconData: Icons.add_circle,
        onTap: () {
          this._mostrarAlerta(context);
        }
      ),
      if (this.controller.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Disolver objeto',
        iconData: Icons.add_circle,
        onTap: () {
          this.controller.disolverObjeto();
          Navigator.pop(context);
        }
      ),
      if (this.controller.objeto.getTipo)
      _createPopupMenuItem(
        title: 'Fusionar objeto',
        iconData: Icons.add_box,
        onTap: () {
          this.controller.fusionarObjeto();
          Navigator.pop(context);
        }
      ),
      _createPopupMenuItem(
        title: 'Abrir',
        iconData: Icons.open_in_browser,
        onTap: () async {
          setState(() {
            this.abrirArchivo();
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
            this._modalGuardar();
          });
        }
      ),
      if (this.controller.marcado.length > 0)
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
    this.controller.cambiarColor(this.currentColor.value);
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