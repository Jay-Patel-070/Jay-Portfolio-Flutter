import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/data/models/user_model.dart';
import '../../features/skills/data/models/skill_model.dart';
import '../../features/projects/data/models/project_model.dart';
import '../../features/experience/data/models/experience_model.dart';
import '../../features/achievements/data/models/achievement_model.dart';
import '../../features/contact/data/models/contact_model.dart';
import 'portfolio_repository.dart';

class FirebasePortfolioRepository implements PortfolioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> getUser() async {
    final doc = await _firestore.collection('portfolio').doc('user').get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!);
    }
    throw Exception('Firebase: User data not found. Please create collection "portfolio" and document "user".');
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    final snapshot = await _firestore.collection('skills').get();
    return snapshot.docs.map((doc) => SkillModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final snapshot = await _firestore.collection('projects').get();
    return snapshot.docs.map((doc) => ProjectModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<ExperienceModel>> getExperience() async {
    final snapshot = await _firestore.collection('experience').orderBy('order').get(); 
    return snapshot.docs.map((doc) => ExperienceModel.fromJson(doc.data())).toList();
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final snapshot = await _firestore.collection('achievements').get();
    return snapshot.docs.map((doc) => AchievementModel.fromJson(doc.data())).toList();
  }

  @override
  Future<ContactModel> getContactInfo() async {
    final doc = await _firestore.collection('portfolio').doc('contact').get();
    if (doc.exists && doc.data() != null) {
      return ContactModel.fromJson(doc.data()!);
    }
    throw Exception('Firebase: Contact data not found. Please create collection "portfolio" and document "contact".');
  }
}
