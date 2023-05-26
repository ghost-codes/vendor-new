import 'package:vendoorr/core/models/saleModel.dart';

class SalesQueryResponse {
  SalesQueryResponse({
    this.next,
    this.previous,
    this.results,
  });

  dynamic next;
  dynamic previous;
  List<SaleModel> results;

  factory SalesQueryResponse.fromJson(Map<String, dynamic> json) =>
      SalesQueryResponse(
        next: json["next"],
        previous: json["previous"],
        results: List<SaleModel>.from(
            json["results"].map((x) => SaleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
