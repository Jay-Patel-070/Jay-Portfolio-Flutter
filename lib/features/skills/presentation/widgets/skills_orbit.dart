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
    final double radius = screenWidth < 600 ? 120 : 250;
    
    // For safety, only map up to 12 skills around a circle
    final itemCount = widget.skills.length > 12 ? 12 : widget.skills.length;
    final skillsToDisplay = widget.skills.take(itemCount).toList();

    return ScrollReveal(
      delay: 0.2,
      child: Center(
        child: Container(
          height: radius * 2.5,
          width: radius * 2.5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Orbit rings
              Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1),
                ),
              ),
              Container(
                width: radius * 1.3,
                height: radius * 1.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.15), width: 1),
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
                      final double angle = (2 * math.pi / skillsToDisplay.length) * index;
                      final double currentAngle = angle + (_controller.value * 2 * math.pi);
                      
                      final double x = radius * math.cos(currentAngle);
                      final double y = radius * math.sin(currentAngle);

                      return Transform.translate(
                        offset: Offset(x, y),
                        child: MouseRegion(
                          onEnter: (_) => _onHoverEnter(skillsToDisplay[index]),
                          onExit: (_) => _onHoverExit(),
                          child: GestureDetector(
                            onTap: () => _onHoverEnter(skillsToDisplay[index]),
                            child: HoverAnimation(
                              scaleTarget: 1.2,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _hoveredSkill == skillsToDisplay[index] 
                                        ? Theme.of(context).colorScheme.primary 
                                        : Colors.white24,
                                    width: 2,
                                  ),
                                  boxShadow: _hoveredSkill == skillsToDisplay[index] ? [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                      blurRadius: 15,
                                    )
                                  ] : [],
                                ),
                                child: Text(
                                  skillsToDisplay[index].skillName.substring(0, 1), // Initial letter as mock icon
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _hoveredSkill == skillsToDisplay[index] ? Theme.of(context).colorScheme.primary : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
