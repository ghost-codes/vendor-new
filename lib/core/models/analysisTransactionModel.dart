// To parse this JSON data, do
//
//     final analysisTransactionModel = analysisTransactionModelFromJson(jsonString);

import 'dart:convert';

AnalysisTransactionModel analysisTransactionModelFromJson(String str) =>
    AnalysisTransactionModel.fromJson(json.decode(str));

String analysisTransactionModelToJson(AnalysisTransactionModel data) =>
    json.encode(data.toJson());

class AnalysisTransactionModel {
  AnalysisTransactionModel({
    this.netTransactions,
    this.sales,
    this.deposits,
    this.debits,
    this.credits,
    this.refunds,
    this.expenses,
    this.orders,
  });

  Credits netTransactions;
  Credits sales;
  Credits deposits;
  Credits debits;
  Credits credits;
  Credits refunds;
  Credits expenses;
  Credits orders;

  factory AnalysisTransactionModel.fromJson(Map<String, dynamic> json) =>
      AnalysisTransactionModel(
        netTransactions: Credits.fromJson(json["net_transactions"]),
        sales: Credits.fromJson(json["sales"]),
        deposits: Credits.fromJson(json["deposits"]),
        debits: Credits.fromJson(json["debits"]),
        credits: Credits.fromJson(json["credits"]),
        refunds: Credits.fromJson(json["refunds"]),
        expenses: Credits.fromJson(json["expenses"]),
        orders: Credits.fromJson(json["orders"]),
      );

  Map<String, dynamic> toJson() => {
        "net_transactions": netTransactions.toJson(),
        "sales": sales.toJson(),
        "deposits": deposits.toJson(),
        "debits": debits.toJson(),
        "credits": credits.toJson(),
        "refunds": refunds.toJson(),
        "expenses": expenses.toJson(),
        "orders": orders.toJson(),
      };
}

class Credits {
  Credits({
    this.amount,
    this.quantity,
  });

  String amount;
  int quantity;

  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
        amount: json["amount"] == null ? null : json["amount"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "quantity": quantity,
      };
}
