import 'package:flutter/material.dart';
import '../../../../shared/animations/hover_animation.dart';
import '../../data/models/contact_form_model.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isSuccess = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    final formData = ContactFormModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    // Simulate sending to Firebase
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      
      // Reset success state after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _isSuccess = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "SEND DIRECT MESSAGE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 500) {
                  return Row(
                    children: [
                      Expanded(child: _buildTextField(_nameController, "Full Name", Icons.person)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(_emailController, "Email Address", Icons.email, isEmail: true)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTextField(_nameController, "Full Name", Icons.person),
                      const SizedBox(height: 16),
                      _buildTextField(_emailController, "Email Address", Icons.email, isEmail: true),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(_subjectController, "Subject", Icons.subject),
            const SizedBox(height: 16),
            _buildTextField(_messageController, "Message", Icons.message, maxLines: 5),
            const SizedBox(height: 32),
            HoverAnimation(
              scaleTarget: 1.05,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSuccess 
                      ? Colors.green 
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black, // Dark text on cyan background
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 24, 
                        width: 24, 
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3)
                      )
                    : Text(
                        _isSuccess ? "MESSAGE TRANSMITTED" : "INITIALIZE TRANSMISSION",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {bool isEmail = false, int maxLines = 1}
  ) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (isEmail) {
          final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!regex.hasMatch(value)) return 'Enter a valid email';
        }
        return null;
      },
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}
