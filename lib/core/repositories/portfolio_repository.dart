import '../../features/home/data/models/user_model.dart';
import '../../features/skills/data/models/skill_model.dart';
import '../../features/projects/data/models/project_model.dart';
import '../../features/experience/data/models/experience_model.dart';
import '../../features/achievements/data/models/achievement_model.dart';
import '../../features/contact/data/models/contact_model.dart';

abstract class PortfolioRepository {
  Future<UserModel> getUser();
  Future<List<SkillModel>> getSkills();
  Future<List<ProjectModel>> getProjects();
  Future<List<ExperienceModel>> getExperience();
  Future<List<AchievementModel>> getAchievements();
  Future<ContactModel> getContactInfo();
}
