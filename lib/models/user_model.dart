class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String location;
  final String qualification;
  final String businessIdea;
  final String industry;
  final String businessStage;
  final bool profileCompleted;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.location = '',
    this.qualification = '',
    this.businessIdea = '',
    this.industry = '',
    this.businessStage = '',
    this.profileCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'location': location,
      'qualification': qualification,
      'businessIdea': businessIdea,
      'industry': industry,
      'businessStage': businessStage,
      'profileCompleted': profileCompleted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      qualification: map['qualification'] ?? '',
      businessIdea: map['businessIdea'] ?? '',
      industry: map['industry'] ?? '',
      businessStage: map['businessStage'] ?? '',
      profileCompleted: map['profileCompleted'] ?? false,
    );
  }
}
