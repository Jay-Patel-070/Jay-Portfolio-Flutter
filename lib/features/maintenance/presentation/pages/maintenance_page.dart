import 'package:flutter/material.dart';
import '../../../../shared/animations/hover_animation.dart';
import '../../../../shared/animations/scroll_reveal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({Key? key}) : super(key: key);

  @override
  _MaintenancePageState createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> with SingleTickerProviderStateMixin {
  late AnimationController _gridController;
  String? _resumeLink;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 10),
    )..repeat();
    _fetchResumeLink();
  }

  Future<void> _fetchResumeLink() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('portfolio').doc('user').get();
      if (doc.exists && doc.data() != null) {
        if (mounted) {
          setState(() {
            _resumeLink = doc.data()!['resumeLink'] as String?;
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch resume link: $e");
    }
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
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
                     color: Colors.redAccent.withOpacity(0.05),
                  ),
                );
              },
            ),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScrollReveal(
                    delay: 0.2,
                    slideOffset: const Offset(0, 50),
                    child: HoverAnimation(
                      scaleTarget: 1.1,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5), 
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.2),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.engineering,
                          size: 80,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  ScrollReveal(
                    delay: 0.4,
                    slideOffset: const Offset(0, 30),
                    child: Text(
                      "UNDER MAINTENANCE",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
                        shadows: [
                          Shadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 20)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ScrollReveal(
                    delay: 0.6,
                    slideOffset: const Offset(0, 30),
                    child: Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 10)
                        ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ScrollReveal(
                    delay: 0.8,
                    slideOffset: const Offset(0, 30),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        "The system is currently undergoing scheduled upgrades to deploy futuristic web experiences.\n\nWhile protocols are temporarily offline, my secure databanks remain open. View my resume below.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                          fontSize: 16,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  if (_resumeLink != null && _resumeLink!.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    ScrollReveal(
                      delay: 1.0,
                      slideOffset: const Offset(0, 30),
                      child: HoverAnimation(
                        scaleTarget: 1.05,
                        child: ElevatedButton.icon(
                          onPressed: () => _launchURL(_resumeLink!),
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
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
