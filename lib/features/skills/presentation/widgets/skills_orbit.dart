import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/models/skill_model.dart';
import '../../../../shared/animations/hover_animation.dart';
import '../../../../shared/animations/scroll_reveal.dart';

class SkillsOrbit extends StatefulWidget {
  final List<SkillModel> skills;

  const SkillsOrbit({Key? key, required this.skills}) : super(key: key);

  @override
  _SkillsOrbitState createState() => _SkillsOrbitState();
}

class _SkillsOrbitState extends State<SkillsOrbit> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;
  SkillModel? _hoveredSkill;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter(SkillModel skill) {
    setState(() {
      _isHovered = true;
      _hoveredSkill = skill;
    });
    _controller.stop();
  }

  void _onHoverExit() {
    setState(() {
      _isHovered = false;
      _hoveredSkill = null;
    });
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double baseRadius = screenWidth < 600 ? 90 : 250;
    
    // For safety, map up to 30 skills across multiple orbits
    final itemCount = widget.skills.length > 30 ? 30 : widget.skills.length;
    final skillsToDisplay = widget.skills.take(itemCount).toList();

    return ScrollReveal(
      delay: 0.2,
      child: Center(
        child: Container(
          height: baseRadius * 3.5,
          width: baseRadius * 3.5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Orbit rings
              Container(
                width: baseRadius * 1.2,
                height: baseRadius * 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.15), width: 1),
                ),
              ),
              Container(
                width: baseRadius * 2.0,
                height: baseRadius * 2.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.1), width: 1),
                ),
              ),
              Container(
                width: baseRadius * 2.8,
                height: baseRadius * 2.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.05), width: 1),
                ),
              ),
              // Center Avatar / Core
              HoverAnimation(
                scaleTarget: 1.1,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: _hoveredSkill != null 
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${(_hoveredSkill!.proficiency * 100).toInt()}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                _hoveredSkill!.skillName,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : const Icon(Icons.computer, size: 40, color: Colors.white),
                  ),
                ),
              ),
              
              // Animated Orbiting Skills
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(skillsToDisplay.length, (index) {
                      final SkillModel skill = skillsToDisplay[index];
                      // Distribute across 3 orbits
                      double orbitRadius;
                      double angleOffset;
                      int skillsInOrbit;
                      int orbitIndex;
                      
                      if (index < 6) {
                        orbitRadius = baseRadius * 0.6;
                        skillsInOrbit = 6;
                        orbitIndex = index;
                        angleOffset = 0;
                      } else if (index < 18) {
                        orbitRadius = baseRadius * 1.0;
                        skillsInOrbit = 12; // index 6-17
                        orbitIndex = index - 6;
                        angleOffset = math.pi / 6;
                      } else {
                        orbitRadius = baseRadius * 1.4;
                        skillsInOrbit = skillsToDisplay.length - 18;
                        orbitIndex = index - 18;
                        angleOffset = math.pi / 12;
                      }

                      final double angle = angleOffset + (2 * math.pi / skillsInOrbit) * orbitIndex;
                      final double direction = (index < 6) ? -1 : (index < 18) ? 1 : -0.5;
                      final double currentAngle = angle + (_controller.value * 2 * math.pi * direction);
                      
                      final double x = orbitRadius * math.cos(currentAngle);
                      final double y = orbitRadius * math.sin(currentAngle);

                      return Transform.translate(
                        offset: Offset(x, y),
                        child: MouseRegion(
                          onEnter: (_) => _onHoverEnter(skill),
                          onExit: (_) => _onHoverExit(),
                          child: GestureDetector(
                            onTap: () => _onHoverEnter(skill),
                            child: HoverAnimation(
                              scaleTarget: 1.15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _hoveredSkill == skill 
                                        ? Theme.of(context).colorScheme.primary 
                                        : (Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.white24),
                                    width: 1.5,
                                  ),
                                  boxShadow: _hoveredSkill == skill ? [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                      blurRadius: 15,
                                    )
                                  ] : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    skill.iconUrl.isNotEmpty 
                                        ? Image.network(skill.iconUrl, height: 16, width: 16, errorBuilder: (c,e,s) => Icon(Icons.code, size: 16, color: Theme.of(context).colorScheme.primary))
                                        : Icon(Icons.code, size: 16, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      skill.skillName,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: _hoveredSkill == skill 
                                            ? Theme.of(context).colorScheme.primary 
                                            : (Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
