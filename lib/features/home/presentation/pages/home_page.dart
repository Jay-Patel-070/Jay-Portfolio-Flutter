import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/repositories/mock_portfolio_repository.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../shared/widgets/app_bar/navigation_bar.dart';

// Import All Feature Sections
import '../widgets/hero_section.dart';
import '../../../skills/presentation/widgets/skills_orbit.dart';
import '../../../projects/presentation/widgets/project_card.dart';
import '../../../experience/presentation/widgets/timeline.dart';
import '../../../achievements/presentation/widgets/stats_section.dart';
import '../../../contact/presentation/widgets/contact_section.dart';

// Providers
final userProfileProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getUser());
final skillsProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getSkills());
final projectsProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getProjects());
final experienceProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getExperience());
final achievementsProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getAchievements());
final contactProvider = FutureProvider((ref) => ref.read(portfolioRepositoryProvider).getContactInfo());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _achievementsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  late final Map<String, GlobalKey> sectionKeys;

  @override
  void initState() {
    super.initState();
    sectionKeys = {
      'Home': _heroKey,
      'Skills': _skillsKey,
      'Projects': _projectsKey,
      'Experience': _experienceKey,
      'Achievements': _achievementsKey,
      'Contact': _contactKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomNavigationBar(sectionKeys: sectionKeys),
      drawer: !isDesktop ? MobileDrawer(sectionKeys: sectionKeys) : null,
      body: userAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
        ),
        error: (err, stack) => Center(child: Text('Error Booting System: $err')),
        data: (user) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HeroSection(key: _heroKey, user: user),
              ),
              _buildSectionHeader(context, "CORE_COMPETENCIES", _skillsKey),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: ref.watch(skillsProvider).when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(child: Text('Error: $e')),
                        data: (skills) => SkillsOrbit(skills: skills),
                      ),
                ),
              ),
              _buildSectionHeader(context, "DATA_ARCHIVES // PROJECTS", _projectsKey),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                sliver: ref.watch(projectsProvider).when(
                      loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                      error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
                      data: (projects) {
                        return SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveLayout.isMobile(context)
                                ? 1
                                : ResponsiveLayout.isTablet(context)
                                    ? 2
                                    : 3,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 32,
                            mainAxisSpacing: 32,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProjectCard(project: projects[index]),
                            childCount: projects.length,
                          ),
                        );
                      },
                    ),
              ),
              _buildSectionHeader(context, "TIMELINE_LOGS", _experienceKey),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: ref.watch(experienceProvider).when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, s) => Center(child: Text('Error: $e')),
                            data: (exp) => TimelineSection(experienceList: exp),
                          ),
                    ),
                  ),
                ),
              ),
              _buildSectionHeader(context, "ACHIEVEMENT_METRICS", _achievementsKey),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: ref.watch(achievementsProvider).when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(child: Text('Error: $e')),
                        data: (stats) => StatsSection(achievements: stats),
                      ),
                ),
              ),
              _buildSectionHeader(context, "COMM_LINK", _contactKey),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: ref.watch(contactProvider).when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, s) => Center(child: Text('Error: $e')),
                            data: (contactInfo) => ContactSection(contact: contactInfo),
                          ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, GlobalKey key) {
    return SliverToBoxAdapter(
      child: Container(
        key: key,
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), blurRadius: 10)
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
