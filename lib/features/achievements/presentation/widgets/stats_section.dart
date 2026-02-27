import 'package:flutter/material.dart';
import '../../data/models/achievement_model.dart';
import '../../../../shared/animations/scroll_reveal.dart';
import '../../../../shared/animations/hover_animation.dart';

class StatsSection extends StatelessWidget {
  final List<AchievementModel> achievements;

  const StatsSection({Key? key, required this.achievements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      delay: 0.2,
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: achievements.map((ach) {
          // Attempt to extract numeric values for animated counting if possible. 
          // For simplicity, we create a floating statistic card here out of the title/description.
          return HoverAnimation(
            scaleTarget: 1.1,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: -10,
                  )
                ],
              ),
              child: Column(
                children: [
                  // Animated Counter logic could go here, for now title serves as the main stat:
                  Text(
                    ach.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ach.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ach.date,
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
