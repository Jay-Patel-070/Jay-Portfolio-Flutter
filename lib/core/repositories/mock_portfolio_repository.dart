import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/data/models/user_model.dart';
import '../../features/projects/data/models/project_model.dart';
import '../../features/skills/data/models/skill_model.dart';
import '../../features/experience/data/models/experience_model.dart';
import '../../features/achievements/data/models/achievement_model.dart';
import '../../features/contact/data/models/contact_model.dart';
import 'portfolio_repository.dart';

// Provider for injecting the repository
final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return MockPortfolioRepository(); // Swap with FirebasePortfolioRepository later
});

class MockPortfolioRepository implements PortfolioRepository {
  @override
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return UserModel(
      name: 'Jay',
      title: 'Full Stack Flutter Developer',
      bio: 'Building futuristic and scalable cross-platform applications.',
      profileImage: 'https://via.placeholder.com/150',
      socialLinks: {
        'github': 'https://github.com',
        'linkedin': 'https://linkedin.com',
      },
    );
  }

  @override
  Future<List<SkillModel>> getSkills() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      SkillModel(skillName: 'Flutter', iconUrl: '', proficiency: 0.9, category: 'Frontend'),
      SkillModel(skillName: 'Firebase', iconUrl: '', proficiency: 0.8, category: 'Backend'),
      SkillModel(skillName: 'Dart', iconUrl: '', proficiency: 0.9, category: 'Language'),
    ];
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return [
      ProjectModel(
        title: 'Project Neo',
        description: 'A futuristic cyber-security dashboard simulator.',
        techStack: ['Flutter', 'Firebase', 'Riverpod'],
        githubUrl: 'https://github.com',
        liveUrl: 'https://example.com',
        images: [],
        featured: true,
      )
    ];
  }

  @override
  Future<List<ExperienceModel>> getExperience() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      ExperienceModel(
        company: 'Tech Corp',
        role: 'Senior Developer',
        duration: '2022 - Present',
        description: 'Lead mobile app development and cross-platform architecture.',
      )
    ];
  }

  @override
  Future<List<AchievementModel>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      AchievementModel(title: 'Top Contributor', description: 'Open source leader', date: '2023')
    ];
  }

  @override
  Future<ContactModel> getContactInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ContactModel(
      email: 'jay@example.com',
      linkedin: 'linkedin.com/in/jay',
      github: 'github.com/jay',
      phone: '+1 234 567 8900',
    );
  }
}
