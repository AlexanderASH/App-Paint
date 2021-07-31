import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plottertopicos/utils/archive.dart';
import 'package:plottertopicos/utils/validator.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:plottertopicos/modelos/Escenario.dart';
import 'package:plottertopicos/negocio/controlador.dart';
import 'package:plottertopicos/negocio/dibujador.dart';
import 'package:flutter_colorpicker/material_picker.dart';
class AreaPage extends StatefulWidget {

  _AreaPageState createState() => _AreaPageState();
}

typedef void OnTap();
class _AreaPageState extends State<AreaPage> {
  Controlador controller;
  bool select;
  bool selectPoint;
  Color currentColor;
  TapPosition position;
  TextEditingController fileNameController;
  TextEditingController pictureNameController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() { 
    super.initState();
    this.controller = Controlador();
    this.select = true;
    this.selectPoint = true;
    this.currentColor = Colors.amber;
    this.position = TapPosition(Offset.zero, Offset.zero);
    this.fileNameController = TextEditingController();
    this.pictureNameController = TextEditingController();
  }

  @override
  void dispose() { 
    this.fileNameController.dispose();
    this.pictureNameController.dispose();
    super.dispose();
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
          itemBuilder: (context) => this.getOptions(),
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
    await Archive.save(this.controller.escenario.toJson(), nombre);
  }

  void abrirArchivo() async {
    try {
      Map<String, dynamic> data = await Archive.open();
      this.controller.escenario = Escenario.fromJson(data);
      setState(() {
        this.controller.restablecerArea();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(e.message)
        )
      );
    }
  }

  void _guardarDibujo() {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0)
        )
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height * 0.40,
          child: Form(
            key: this._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.save),
                  title: Text('Guardar Como'),
                ),
                TextFormField(
                  validator: Validator.validateInput,
                  controller: this.fileNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      primary: Colors.pink
                    ),
                    child: Text('Guardar'),
                    onPressed: () {
                      if (this._formKey.currentState.validate()) {
                        guardarArchivo(this.fileNameController.text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          title: Text("Crear Objeto"),
          content: Form(
            key: this._formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  validator: Validator.validateInput,
                  controller: this.pictureNameController,
                  decoration:InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      primary: Colors.pink
                    ),
                    child: Text('Guardar'),
                    onPressed: () {
                      if (this._formKey.currentState.validate()) {
                        this.controller.crearObjeto(this.pictureNameController.text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  List<PopupMenuEntry<dynamic>> getOptions() {
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
            this._guardarDibujo();
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