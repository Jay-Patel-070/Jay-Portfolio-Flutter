import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/contact_model.dart';
import '../../../../shared/animations/scroll_reveal.dart';
import '../../../../shared/animations/hover_animation.dart';
import '../../../../core/responsive/responsive_layout.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_form.dart';

class ContactSection extends StatelessWidget {
  final ContactModel contact;

  const ContactSection({Key? key, required this.contact}) : super(key: key);

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    Widget _buildInfoPanel() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            "INITIATE HANDSHAKE",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "I am open to new futuristic collaborations. Let's build the unseen.",
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7), 
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            children: [
              _buildSocialButton(
                context, 
                icon: FontAwesomeIcons.envelope, 
                url: "mailto:${contact.email}"
              ),
              _buildSocialButton(
                context, 
                icon: FontAwesomeIcons.github, 
                url: "https://${contact.github}"
              ),
              _buildSocialButton(
                context, 
                icon: FontAwesomeIcons.linkedinIn, 
                url: "https://${contact.linkedin}"
              ),
            ],
          )
        ],
      );
    }

    return ScrollReveal(
      delay: 0.3,
      child: isDesktop 
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 64.0),
                child: _buildInfoPanel(),
              ),
            ),
            Expanded(
              flex: 1,
              child: const ContactForm(),
            ),
          ],
        )
      : Column(
          children: [
            _buildInfoPanel(),
            const SizedBox(height: 64),
            const ContactForm(),
          ],
        ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {required IconData icon, required String url}) {
    return HoverAnimation(
      scaleTarget: 1.15,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          ),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 icon, 
                 color: Theme.of(context).textTheme.bodyLarge?.color, 
                 size: 28,
               ),
             ],
          ),
        ),
      ),
    );
  }
}
