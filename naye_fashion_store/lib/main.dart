import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const urlApi = String.fromEnvironment(
  'URL_API',
  defaultValue: 'http://10.0.2.2:3000',
);
const tokenJwt = String.fromEnvironment('TOKEN_JWT');

void main() => runApp(const AplicacionNaye());

class AplicacionNaye extends StatelessWidget {
  const AplicacionNaye({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naye Fashion Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ProductosPagina(),
    );
  }
}

class MyApp extends AplicacionNaye {
  const MyApp({super.key});
}

class ProductosPagina extends StatefulWidget {
  const ProductosPagina({super.key});

  @override
  State<ProductosPagina> createState() => _ProductosPaginaState();
}

class _ProductosPaginaState extends State<ProductosPagina> {
  late Future<List<Map<String, dynamic>>> productos;

  @override
  void initState() {
    super.initState();
    productos = cargarProductos();
  }

  Future<List<Map<String, dynamic>>> cargarProductos() async {
    if (tokenJwt.isEmpty) throw Exception('Falta TOKEN_JWT');
    final respuesta = await http.get(
      Uri.parse('$urlApi/api/productos'),
      headers: {'Authorization': 'Bearer $tokenJwt'},
    );
    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los productos');
    }
    final contenido = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(
      (contenido['datos'] as List).map(
        (producto) => Map<String, dynamic>.from(producto as Map),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: productos,
        builder: (context, estado) {
          if (estado.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (estado.hasError) {
            return Center(child: Text(estado.error.toString()));
          }
          final datos = estado.data ?? [];
          return ListView.builder(
            itemCount: datos.length,
            itemBuilder: (context, indice) {
              final producto = datos[indice];
              return ListTile(
                title: Text(producto['nombre'] as String),
                subtitle: Text('${producto['talla']} | ${producto['color']}'),
                trailing: Text('\$${producto['precio']}'),
              );
            },
          );
        },
      ),
    );
  }
}
