import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {

  MapboxMapController mapController;
  final center = LatLng(-33.426917, -70.616569);
  String selectedStyle = 'mapbox://styles/kzelly/ckhw0q62q0q2c19s2fhqp3yrp';
  final oscuroStyle = 'mapbox://styles/kzelly/ckhw0ogvj0wee19ny8g4iji7h';
  final streetStyle = 'mapbox://styles/kzelly/ckhw0q62q0q2c19s2fhqp3yrp';
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

    /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget> [

        //Simbolos
        FloatingActionButton(
          child: Icon( Icons.sentiment_very_dissatisfied ),
          onPressed: () {
            mapController.addSymbol( SymbolOptions(
              geometry: center,
              // iconSize: 3,
              iconImage: 'networkImage',
              textField: 'Montaña creada aqui',
              textOffset: Offset(0, 2)
            ));
          }
        
        ),
        SizedBox(height: 5),

        //ZoomIn
        FloatingActionButton(
          child: Icon( Icons.zoom_in ),
          onPressed: () {
            mapController.animateCamera( CameraUpdate.zoomIn() );
          }
        
        ),
        SizedBox(height: 5),
        //ZoomOut
        FloatingActionButton(
          child: Icon( Icons.zoom_out ),
          onPressed: () {
            mapController.animateCamera( CameraUpdate.zoomOut() );
          }
        
        ),
        SizedBox(height: 5),

        // Cambiar estilo
        FloatingActionButton(
          child: Icon( Icons.add_to_home_screen ),
          onPressed: () {
            if ( selectedStyle == oscuroStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = oscuroStyle;
            }
            _onStyleLoaded();
            setState(() {});
          }
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
    styleString: selectedStyle,
    onMapCreated: _onMapCreated,
    initialCameraPosition:
    CameraPosition(
      target: center,
      zoom: 14
    ),
    );
  }
}