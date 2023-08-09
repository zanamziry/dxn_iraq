// ignore_for_file: non_constant_identifier_names,file_names

import 'dart:ffi';

import 'package:dxn_iraq/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Product>> products = fetchData();

  static Future<List<Product>> fetchData() async {
    var url = Uri.parse("https://zanamziry.pythonanywhere.com/api/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  double GetDollarDinarValue() {
    var value = double.tryParse(dollarValueController.text);
    if (value == null) return 0.0;
    return value;
  }

  Widget buildList(List<Product> products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final Product = products[index];
          //Text(Product.name_ar, style: GoogleFonts.cairo(),)
          return SizedBox(
              height: 75,
              child: Container(
                  child: Row(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Product.name_ar,
                              softWrap: true,
                              style: TextStyle(
                                  fontFamily: GoogleFonts.cairo().fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Text(Product.name, style: GoogleFonts.cairo()),
                        ],
                      )),
                  SizedBox(
                    width: 75,
                    child: Text(
                        (Product.price * GetDollarDinarValue())
                            .round()
                            .toString(),
                        style: GoogleFonts.cairo(),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(Product.pv.toString(),
                        style: GoogleFonts.cairo(),
                        textAlign: TextAlign.center),
                  )
                ],
              )));
        },
      );
  @override
  void dispose() {
    dollarValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("DXN IRAQ"),
        centerTitle: true,
      ),
      body: Column(children: [
        buildTextfield(),
        buildListView(),
      ]));

  Widget buildListView() => Expanded(
          child: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final finalproducts = snapshot.data!;
            return buildList(finalproducts);
          } else {
            return const Text("No Products Found!");
          }
        },
      ));
  final dollarValueController = TextEditingController();
  String? _errorText() {
    if (dollarValueController.text.isNotEmpty &&
        !RegExp(r"^\d*(\.\d+)?$").hasMatch(dollarValueController.text)) {
      return 'Only Numbers are allowed';
    }
    return null;
  }

  Widget buildTextfield() => TextField(
        controller: dollarValueController,
        keyboardType: TextInputType.number,
        onChanged: (text) => setState(() => dollarValueController.text),
        decoration: InputDecoration(
            hintText: '1532.5',
            labelText: 'سعر الصرف',
            prefixIcon: const Icon(Icons.money),
            errorText: _errorText(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => dollarValueController.clear(),
            )),
      );
}
