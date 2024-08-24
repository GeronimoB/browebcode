import 'dart:io' as io;
import 'package:bro_app_to/Screens/lista_afiliados.dart';
import 'package:bro_app_to/components/custom_text_button.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:bro_app_to/utils/current_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/user_provider.dart';
import '../utils/api_constants.dart';

class UploadInvoice extends StatefulWidget {
  final double total;
  final String banco;
  final String cuenta;
  final String titular;
  const UploadInvoice({
    required this.total,
    required this.banco,
    required this.cuenta,
    required this.titular,
    super.key,
  });

  @override
  UploadInvoiceState createState() => UploadInvoiceState();
}

class UploadInvoiceState extends State<UploadInvoice> {
  String fileName = "Sin archivo seleccionado";
  String filePath = "";
  double iva = 0;
  double subtotal = 0;

  Future<void> _openGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      final pickedFile = result.files.single;
      setState(() {
        filePath = pickedFile.path!;
        fileName = pickedFile.name;
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    iva = widget.total * 0.21;
    subtotal = widget.total + iva;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(35),
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
              translations!["uploadInvoice"],
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff00E050),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${translations!["nameBro"]}\n${translations!["dniBro"]}\n${translations!["addressBro"]}',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              "${translations!["subTotal"]}: $subtotal €",
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              "${translations!["vat21"]}: $iva €",
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              "${translations!["total"]}: ${widget.total} €",
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              label: translations!["PDFInvoice"],
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextButton(
                  onTap: () => Navigator.of(context).pop(),
                  text: translations!["skip"],
                  buttonPrimary: false,
                  width: 90,
                  height: 27,
                ),
                CustomTextButton(
                  onTap: () async {
                    try {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      final usuario = userProvider.getCurrentUser();
                      String userId = usuario.userId.toString();

                      const url =
                          '${ApiConstants.baseUrl}/auth/create-withdrawal';
                      var request =
                          http.MultipartRequest('POST', Uri.parse(url));

                      if (filePath.isNotEmpty) {
                        if (fileName.toLowerCase().endsWith('.pdf')) {
                          request.files.add(await http.MultipartFile.fromPath(
                              "factura", filePath));
                        } else {
                          showErrorSnackBar(
                              context, translations!['please_upload_pdf']);
                          return;
                        }
                      } else {
                        showErrorSnackBar(
                            context, translations!['please_upload_all_files']);
                        return;
                      }

                      request.fields["userId"] = userId;
                      request.fields["banco"] = widget.banco;
                      request.fields["titular"] = widget.titular;
                      request.fields["cuenta"] = widget.cuenta;
                      request.fields["cantidad"] = subtotal.toString();
                      var response = await request.send();

                      if (response.statusCode == 200) {
                        Navigator.of(context).pop();
                        showSucessSnackBar(
                            context, translations!['widthdrawal_request']);

                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ListaReferidosScreen()),
                        );
                      } else {
                        showErrorSnackBar(
                            context, translations!['error_try_again']);
                      }
                    } catch (e) {
                      showErrorSnackBar(
                          context, translations!['error_try_again']);
                    }
                  },
                  text: translations!['send'],
                  buttonPrimary: true,
                  width: 90,
                  height: 27,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              height: 1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 210,
                child: Text(
                  fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF00E050),
                  size: 20,
                ),
                onPressed: () {
                  _openGallery();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showUploadInvoice(BuildContext context, String banco, String titular,
    String cuenta, double total) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.7),
    builder: (BuildContext context) {
      return UploadInvoice(
        total: total,
        banco: banco,
        cuenta: cuenta,
        titular: titular,
      );
    },
  );
}
