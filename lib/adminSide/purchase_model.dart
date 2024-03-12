import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModelFields {
  static const String purchaseTime = "purchaseTime";
  static const String premiumExpiry = "premiumExpiry";
  static const String paidAmount = "paidAmount";
}

class PurchaseModel {
  Timestamp purchaseTime;
  Timestamp premiumExpiry;
  double paidAmount;

  PurchaseModel({required this.purchaseTime,
    required this.premiumExpiry,
    required this.paidAmount});

  toMap() =>
      {
        PurchaseModelFields.paidAmount: paidAmount,
        PurchaseModelFields.premiumExpiry: premiumExpiry,
        PurchaseModelFields.purchaseTime: purchaseTime
      };

  factory PurchaseModel.fromJson(Map<String, dynamic> json)=>
      PurchaseModel(
          purchaseTime: json[PurchaseModelFields.purchaseTime],
          premiumExpiry: json[PurchaseModelFields.premiumExpiry],
          paidAmount: json[PurchaseModelFields.paidAmount]);


}
