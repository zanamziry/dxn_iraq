class Currency {
  bool? status;
  List<Data>? data;
  String? message;

  Currency({this.status, this.data, this.message});

  Currency.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? sId;
  int? order;
  List<String>? currency;
  List<String>? oppositeCurrency;
  List<String>? currencyPrice;
  List<String>? oppositeCurrencyPrice;
  List<String>? date;

  Data(
      {this.sId,
      this.order,
      this.currency,
      this.oppositeCurrency,
      this.currencyPrice,
      this.oppositeCurrencyPrice,
      this.date});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    order = json['order'];
    currency = json['currency'].cast<String>();
    oppositeCurrency = json['opposite_currency'].cast<String>();
    currencyPrice = json['currency_price'].cast<String>();
    oppositeCurrencyPrice = json['opposite_currency_price'].cast<String>();
    date = json['date'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['order'] = this.order;
    data['currency'] = this.currency;
    data['opposite_currency'] = this.oppositeCurrency;
    data['currency_price'] = this.currencyPrice;
    data['opposite_currency_price'] = this.oppositeCurrencyPrice;
    data['date'] = this.date;
    return data;
  }
}
