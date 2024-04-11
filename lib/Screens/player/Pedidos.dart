import 'dart:convert';

import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/api_client.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  PedidosState createState() => PedidosState();
}

class PedidosState extends State<Pedidos> {
  int _selectedPedido = -1;

  Future<List<PedidosModel>> fetchPedidos() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.getCurrentUser().userId;
    try {
      final pedidos = await ApiClient().get('auth/orders/$userId');
      if (pedidos.statusCode == 200) {
        final jsonData = jsonDecode(pedidos.body);
        final orders = jsonData["orders"];
        return mapListToPedidos(orders).reversed.toList();
      } else {
        debugPrint('Error al obtener los videos.');
        return [];
      }
    } catch (e) {
      debugPrint('Error en la solicitud de videos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF00E050),
            size: 32,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFF121212)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            const Text(
              'PEDIDOS',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<PedidosModel>>(
                future: fetchPedidos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  } else {
                    final orders = snapshot.data ?? [];

                    if (orders.isEmpty) {
                      return const Expanded(
                        child: Center(
                          child: Text(
                            "¡Aun no tienes pedidos!",
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];

                              return _buildPedidoItem(
                                  order, _selectedPedido == index, index);
                            }),
                      ),
                    );
                  }
                }),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 104,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidoItem(PedidosModel pedido, bool isSelected, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPedido = index;
        });
        showOrder(pedido);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? const Color(0xff05FF00) : Colors.transparent,
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [const CustomBoxShadow(color: Color(0xff05FF00), blurRadius: 5)]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  pedido.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '€ ${pedido.amount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right, color: Color(0xff05FF00)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showOrder(PedidosModel pedido) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xff3B3B3B),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(5, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gracias por tu compra",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xff00E050),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Producto: ${pedido.description}",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Fecha y hora de compra: ${pedido.datetime}",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Método de pago: ${pedido.paymentMethod}",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Factura: #${pedido.orderId}",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Center(
                  child: CustomTextButton(
                      text: "Descargar Factura",
                      buttonPrimary: true,
                      width: 164,
                      height: 31),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class PedidosModel {
  String description;
  String amount;
  DateTime datetime;
  String paymentMethod;
  String orderId;

  PedidosModel({
    required this.description,
    required this.amount,
    required this.datetime,
    required this.paymentMethod,
    required this.orderId,
  });

  factory PedidosModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDatetime = DateTime.parse(json['fecha']);

    String formattedOrderId = json['id'].toString().padLeft(6, '0');

    return PedidosModel(
      description: json['description'],
      amount: json['amount'].toString(),
      datetime: parsedDatetime,
      paymentMethod: json['payment_method'],
      orderId: formattedOrderId,
    );
  }
}

List<PedidosModel> mapListToPedidos(List<dynamic> lista) {
  return lista.map((item) => PedidosModel.fromJson(item)).toList();
}
