import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // =========================================================
  // CURRENT USER
  // =========================================================

  String get uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user.');
    }

    return user.uid;
  }

  // =========================================================
  // USER PROFILE
  // =========================================================

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final document = await _db.collection('users').doc(uid).get();

    return document.data();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userProfileStream() {
    return _db.collection('users').doc(uid).snapshots();
  }

  Future<void> updateEntrepreneurProfile({
    required String location,
    required String qualification,
    required String businessIdea,
    required String industry,
    required String businessStage,
  }) async {
    await _db.collection('users').doc(uid).update({
      'location': location.trim(),
      'qualification': qualification.trim(),
      'businessIdea': businessIdea.trim(),
      'industry': industry.trim(),
      'businessStage': businessStage.trim(),
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // BUSINESS IDEA VIABILITY
  // =========================================================

  Future<void> saveViabilityAssessment({
    required int demandScore,
    required int customerScore,
    required int competitionScore,
    required int skillsScore,
    required int financeScore,
    required int totalScore,
    required String recommendation,
  }) async {
    await _db.collection('viability_assessments').add({
      'userId': uid,
      'demandScore': demandScore,
      'customerScore': customerScore,
      'competitionScore': competitionScore,
      'skillsScore': skillsScore,
      'financeScore': financeScore,
      'totalScore': totalScore,
      'recommendation': recommendation,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(uid).update({
      'viabilityCompleted': true,
      'latestViabilityScore': totalScore,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // BUSINESS PLAN
  // =========================================================

  Future<void> saveBusinessPlan({
    required String businessName,
    required String businessDescription,
    required String problemSolved,
    required String productsServices,
    required String targetCustomers,
    required String customerNeeds,
    required String competitors,
    required String competitiveAdvantage,
    required String marketingStrategy,
    required String salesStrategy,
    required double startupCost,
    required double expectedMonthlyIncome,
    required double expectedMonthlyExpenses,
  }) async {
    await _db.collection('business_plans').doc(uid).set({
      'userId': uid,
      'businessName': businessName.trim(),
      'businessDescription': businessDescription.trim(),
      'problemSolved': problemSolved.trim(),
      'productsServices': productsServices.trim(),
      'targetCustomers': targetCustomers.trim(),
      'customerNeeds': customerNeeds.trim(),
      'competitors': competitors.trim(),
      'competitiveAdvantage': competitiveAdvantage.trim(),
      'marketingStrategy': marketingStrategy.trim(),
      'salesStrategy': salesStrategy.trim(),
      'startupCost': startupCost,
      'expectedMonthlyIncome': expectedMonthlyIncome,
      'expectedMonthlyExpenses': expectedMonthlyExpenses,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db.collection('users').doc(uid).update({
      'businessPlanCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getBusinessPlan() async {
    final document = await _db.collection('business_plans').doc(uid).get();

    return document.data();
  }

  // =========================================================
  // BUSINESS REGISTRATION
  // =========================================================

  Future<void> completeRegistrationChecklist() async {
    await _db.collection('users').doc(uid).update({
      'registrationCompleted': true,
      'registrationCompletedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================================================
  // BUSINESS GOALS
  // =========================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> goalsStream() {
    return _db.collection('goals').where('userId', isEqualTo: uid).snapshots();
  }

  Future<void> addGoal({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    await _db.collection('goals').add({
      'userId': uid,
      'title': title.trim(),
      'description': description.trim(),
      'dueDate': Timestamp.fromDate(dueDate),
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(uid).update({
      'goalsCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateGoalStatus({
    required String goalId,
    required bool completed,
  }) async {
    await _db.collection('goals').doc(goalId).update({
      'completed': completed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteGoal(String goalId) async {
    await _db.collection('goals').doc(goalId).delete();
  }
}
