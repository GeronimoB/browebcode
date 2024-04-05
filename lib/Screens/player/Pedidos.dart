import 'package:bro_app_to/components/custom_box_shadow.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:flutter/material.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  String _selectedPedido = ''; // Inicialmente ningún pedido seleccionado

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
            _buildPedidoItem(
                'Pedido 1', '20.00', 'Pedido 1' == _selectedPedido),
            _buildPedidoItem(
                'Pedido 2', '30.00', 'Pedido 2' == _selectedPedido),
            // Agrega más elementos de pedido aquí si es necesario
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

  Widget _buildPedidoItem(String pedido, String precio, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPedido = pedido;
        });
        showOrder();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Color(0xff05FF00) : Colors.transparent,
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
                  pedido,
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
                  '€ $precio',
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

  void showOrder() {
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
            child: const Column(
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
                SizedBox(
                  height: 25,
                ),
                Text(
                  "El producto XXXX",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Fecha y hora de compra XXXXXXX",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Método de pago XXXXXXX",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Factura XXXXXXXX",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Center(
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
