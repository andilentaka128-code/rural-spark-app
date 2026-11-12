import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessPlanModel {
  final String id;
  final String userId;
  final String businessName;
  final String businessDescription;
  final String problemSolved;
  final String productsServices;
  final String targetCustomers;
  final String customerNeeds;
  final String competitors;
  final String competitiveAdvantage;
  final String marketingStrategy;
  final String salesStrategy;
  final double startupCost;
  final double expectedMonthlyIncome;
  final double expectedMonthlyExpenses;
  final DateTime updatedAt;

  const BusinessPlanModel({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessDescription,
    required this.problemSolved,
    required this.productsServices,
    required this.targetCustomers,
    required this.customerNeeds,
    required this.competitors,
    required this.competitiveAdvantage,
    required this.marketingStrategy,
    required this.salesStrategy,
    required this.startupCost,
    required this.expectedMonthlyIncome,
    required this.expectedMonthlyExpenses,
    required this.updatedAt,
  });

  double get expectedMonthlyProfit =>
      expectedMonthlyIncome - expectedMonthlyExpenses;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'problemSolved': problemSolved,
      'productsServices': productsServices,
      'targetCustomers': targetCustomers,
      'customerNeeds': customerNeeds,
      'competitors': competitors,
      'competitiveAdvantage': competitiveAdvantage,
      'marketingStrategy': marketingStrategy,
      'salesStrategy': salesStrategy,
      'startupCost': startupCost,
      'expectedMonthlyIncome': expectedMonthlyIncome,
      'expectedMonthlyExpenses': expectedMonthlyExpenses,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory BusinessPlanModel.fromMap(String id, Map<String, dynamic> map) {
    return BusinessPlanModel(
      id: id,
      userId: map['userId'] ?? '',
      businessName: map['businessName'] ?? '',
      businessDescription: map['businessDescription'] ?? '',
      problemSolved: map['problemSolved'] ?? '',
      productsServices: map['productsServices'] ?? '',
      targetCustomers: map['targetCustomers'] ?? '',
      customerNeeds: map['customerNeeds'] ?? '',
      competitors: map['competitors'] ?? '',
      competitiveAdvantage: map['competitiveAdvantage'] ?? '',
      marketingStrategy: map['marketingStrategy'] ?? '',
      salesStrategy: map['salesStrategy'] ?? '',
      startupCost: (map['startupCost'] as num?)?.toDouble() ?? 0,
      expectedMonthlyIncome:
          (map['expectedMonthlyIncome'] as num?)?.toDouble() ?? 0,
      expectedMonthlyExpenses:
          (map['expectedMonthlyExpenses'] as num?)?.toDouble() ?? 0,
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
