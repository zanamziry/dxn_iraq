// ignore_for_file: non_constant_identifier_names,file_names

import 'package:dxn_iraq/models/Currency.dart';
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
  late Future<List<Product>> products;
  Currency? currencyNow;
  double sarf = 0.0;

  @override
  void initState() {
    super.initState();
    products = fetchData();
    fetchCurrencyData().then((c) {
      currencyNow = c;
      sarf = GetDollarVal();
    });
  }

  //Fetching Product List as json from the server
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

  //Fetching Currency Data as json from the server
  static Future<Currency> fetchCurrencyData() async {
    var url = Uri.parse(
        "https://smarttraderiq.com:2096/grouped_currency_forclient?lang=en");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      return Currency.fromJson(jsonResponse);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  double GetDollarVal() {
    var iqdusd = double.tryParse(dollarValueController.text);
    if (iqdusd == null) {
      if (currencyNow == null ||
          currencyNow!.data == null ||
          currencyNow!.data![0].oppositeCurrencyPrice == null) {
        return 0.0;
      }
      iqdusd = double.tryParse(currencyNow!.data![0].oppositeCurrencyPrice![0]);
      if (iqdusd == null) {
        return 0.0;
      } else {
        return iqdusd / 100;
      }
    }
    return iqdusd;
  }

  @override
  void dispose() {
    dollarValueController.dispose();
    super.dispose();
  }

  // Product Template View
  Widget ItemsTemplate(Product productObj, double dollarv) => SizedBox(
      height: 75,
      child: Container(
          color: Colors.white,
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(productObj.name_ar,
                          softWrap: true,
                          style: TextStyle(
                              fontFamily: GoogleFonts.cairo().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      Text(productObj.name, style: GoogleFonts.cairo()),
                    ],
                  )),
              SizedBox(
                width: 75,
                child: Text((dollarv * productObj.price).round().toString(),
                    style: GoogleFonts.cairo(), textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 50,
                child: Text(productObj.pv.toString(),
                    style: GoogleFonts.cairo(), textAlign: TextAlign.center),
              )
            ],
          )));

  //Main Build Function
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title:
            const Image(image: AssetImage('assets/RK_logo.ico'), height: 100),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              child: buildDollarfield(),
            ),
            Expanded(
              child: buildSearchfield(),
            ),
          ],
        ),
        buildListView(),
      ]));

  //Build List Function
  Widget buildList(List<Product> products) {
    sarf = GetDollarVal();
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prdct = products[index];
        return ItemsTemplate(prdct, sarf);
      },
    );
  }

  //Call BuildList when the data is available, if not Return Error
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

  //Show Error if the users types something other than numbers
  String? _errorText() {
    if (dollarValueController.text.isNotEmpty &&
        !RegExp(r"^\d*(\.\d+)?$").hasMatch(dollarValueController.text)) {
      return 'Only Numbers are allowed';
    }
    return null;
  }

  final dollarValueController = TextEditingController();
  Widget buildDollarfield() => TextField(
        controller: dollarValueController,
        keyboardType: TextInputType.number,
        cursorRadius: const Radius.circular(10),
        onChanged: (text) => setState(() => dollarValueController.text),
        decoration: InputDecoration(
            hintText: GetDollarVal().toString(),
            labelText: 'سعر الصرف',
            prefixIcon: const Icon(Icons.attach_money_rounded),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            errorText: _errorText(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => dollarValueController.clear(),
            )),
      );

  final SearchController = TextEditingController();
  Widget buildSearchfield() => TextField(
        controller: SearchController,
        keyboardType: TextInputType.text,
        cursorRadius: const Radius.circular(10),
        onChanged: (text) => setState(() => SearchController.text),
        decoration: InputDecoration(
            hintText: "معجون الاسنان",
            labelText: 'بحث عن منتج',
            prefixIcon: const Icon(Icons.search_rounded),
            errorText: _errorText(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () => dollarValueController.clear(),
            )),
      );
}
