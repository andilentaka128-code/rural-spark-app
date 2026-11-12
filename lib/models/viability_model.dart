import 'package:cloud_firestore/cloud_firestore.dart';

class ViabilityModel {
  final String id;
  final String userId;
  final int demandScore;
  final int customerScore;
  final int competitionScore;
  final int skillsScore;
  final int financeScore;
  final int totalScore;
  final String recommendation;
  final DateTime createdAt;

  const ViabilityModel({
    required this.id,
    required this.userId,
    required this.demandScore,
    required this.customerScore,
    required this.competitionScore,
    required this.skillsScore,
    required this.financeScore,
    required this.totalScore,
    required this.recommendation,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'demandScore': demandScore,
      'customerScore': customerScore,
      'competitionScore': competitionScore,
      'skillsScore': skillsScore,
      'financeScore': financeScore,
      'totalScore': totalScore,
      'recommendation': recommendation,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ViabilityModel.fromMap(String id, Map<String, dynamic> map) {
    return ViabilityModel(
      id: id,
      userId: map['userId'] ?? '',
      demandScore: map['demandScore'] ?? 0,
      customerScore: map['customerScore'] ?? 0,
      competitionScore: map['competitionScore'] ?? 0,
      skillsScore: map['skillsScore'] ?? 0,
      financeScore: map['financeScore'] ?? 0,
      totalScore: map['totalScore'] ?? 0,
      recommendation: map['recommendation'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
