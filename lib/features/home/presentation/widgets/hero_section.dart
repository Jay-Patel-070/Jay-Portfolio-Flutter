import 'package:flutter/material.dart';
import '../../../../shared/animations/scroll_reveal.dart';
import '../../../../shared/animations/hover_animation.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends ConsumerStatefulWidget {
  final UserModel user;

  const HeroSection({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _gridController;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    // Dynamic Image Avatar Builder
    Widget _buildAvatar() {
      return HoverAnimation(
        scaleTarget: 1.05,
        tiltTarget: 0.1,
        child: Container(
          width: isMobile ? 300 : (isTablet ? 350 : 500),
          height: isMobile ? 300 : (isTablet ? 350 : 500),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5), 
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(
                widget.user.profileImage.isNotEmpty 
                    ? widget.user.profileImage 
                    : 'https://via.placeholder.com/350', // Fallback URL
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // Dynamic Text Builder
    Widget _buildTextContent() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            delay: 0.2,
            slideOffset: const Offset(0, 30),
            child: Text(
              "SYSTEM READY // PROTOCOL ENGAGED",
              style: TextStyle(
                fontSize: isMobile ? 12 : 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ScrollReveal(
            delay: 0.4,
            slideOffset: const Offset(0, 30),
            child: Text(
              widget.user.name.toUpperCase(),
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isMobile ? 50 : (isTablet ? 80 : 120),
                fontWeight: FontWeight.w900,
                height: 0.9,
                letterSpacing: -2,
                shadows: [
                  Shadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), blurRadius: 30)
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ScrollReveal(
            delay: 0.6,
            slideOffset: const Offset(0, 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                   width: 12, 
                   height: 12, 
                   decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).colorScheme.secondary, blurRadius: 10)
                      ],
                   ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    widget.user.title,
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: isMobile ? 18 : 32,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ScrollReveal(
            delay: 0.8,
            slideOffset: const Offset(0, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                widget.user.bio,
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (widget.user.resumeLink.isNotEmpty)
            ScrollReveal(
              delay: 1.0,
              slideOffset: const Offset(0, 30),
              child: HoverAnimation(
                scaleTarget: 1.05,
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(widget.user.resumeLink),
                  icon: Icon(
                    Icons.download, 
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                  ),
                  label: Text(
                    "DOWNLOAD RESUME",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: EdgeInsets.only(
        left: isMobile ? 24.0 : 48.0, 
        right: isMobile ? 24.0 : 48.0,
        top: kToolbarHeight + 48.0,
        bottom: 48.0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cyberpunk Grid Background Simulation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, _) {
                return CustomPaint(
                  painter: GridPainter(
                     offset: _gridController.value,
                     color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ),
                );
              },
            ),
          ),

          // Content Wrapper
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isMobile) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScrollReveal(
                        delay: 0.1,
                        slideOffset: const Offset(0, 50),
                        child: _buildAvatar(),
                      ),
                      const SizedBox(height: 48),
                      _buildTextContent(),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextContent(),
                          ),
                          const SizedBox(width: 48),
                          ScrollReveal(
                            delay: 0.3,
                            slideOffset: const Offset(50, 0),
                            child: _buildAvatar(),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double offset;
  final Color color;

  GridPainter({required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final cellWidth = 50.0;
    
    // Vertical lines moving left
    final startX = -(offset * cellWidth);
    for (double i = startX; i < size.width; i += cellWidth) {
      if (i > 0) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    // Horizontal lines moving up
    final startY = -(offset * cellWidth);
    for (double i = startY; i < size.height; i += cellWidth) {
      if (i > 0) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => true;
}
