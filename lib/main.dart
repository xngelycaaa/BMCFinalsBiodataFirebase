
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BioDataApp());
}

class BioDataApp extends StatelessWidget {
  const BioDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bio Data',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BioDataScreen(),
    );
  }
}

class BioDataScreen extends StatefulWidget {
  const BioDataScreen({super.key});

  @override
  State<BioDataScreen> createState() => _BioDataScreenState();
}

class _BioDataScreenState extends State<BioDataScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  // Personal Details
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();

  // Educational Background
  final _elemController = TextEditingController();
  final _jhsController = TextEditingController();
  final _shsController = TextEditingController();
  final _collegeController = TextEditingController();

  // Family Background
  final _fatherController = TextEditingController();
  final _motherController = TextEditingController();
  final _siblingsController = TextEditingController();

  // Character References
  final _ref1NameController = TextEditingController();
  final _ref1ContactController = TextEditingController();
  final _ref2NameController = TextEditingController();
  final _ref2ContactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _genderController.dispose();

    _elemController.dispose();
    _jhsController.dispose();
    _shsController.dispose();
    _collegeController.dispose();

    _fatherController.dispose();
    _motherController.dispose();
    _siblingsController.dispose();

    _ref1NameController.dispose();
    _ref1ContactController.dispose();
    _ref2NameController.dispose();
    _ref2ContactController.dispose();

    super.dispose();
  }

  Future<void> _submitBioData() async {
    if (_formKey.currentState == null ||
        !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'gender': _genderController.text.trim(),

        'elementary': _elemController.text.trim(),
        'juniorHighSchool': _jhsController.text.trim(),
        'seniorHighSchool': _shsController.text.trim(),
        'college': _collegeController.text.trim(),

        'father': _fatherController.text.trim(),
        'mother': _motherController.text.trim(),
        'siblings': _siblingsController.text.trim(),

        'reference1Name': _ref1NameController.text.trim(),
        'reference1Contact': _ref1ContactController.text.trim(),
        'reference2Name': _ref2NameController.text.trim(),
        'reference2Contact': _ref2ContactController.text.trim(),

        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bio data saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Bio Data Submitted'),
          content: const Text(
            'Your bio data has been saved to Firebase successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save bio data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C5E64),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        validator: requiredField
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio Data'),
        backgroundColor: const Color(0xFF2C5E64),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionTitle('Personal Details'),

                  _textField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                    requiredField: true,
                  ),
                  _textField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    requiredField: true,
                  ),
                  _textField(
                    controller: _phoneController,
                    label: 'Contact Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _textField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.home,
                  ),
                  _textField(
                    controller: _dobController,
                    label: 'Date of Birth (DD/MM/YYYY)',
                    icon: Icons.calendar_today,
                  ),
                  _textField(
                    controller: _genderController,
                    label: 'Gender',
                    icon: Icons.people,
                  ),

                  _sectionTitle('Educational Background'),

                  _textField(
                    controller: _elemController,
                    label: 'Elementary School',
                    icon: Icons.school,
                  ),
                  _textField(
                    controller: _jhsController,
                    label: 'Junior High School',
                    icon: Icons.school,
                  ),
                  _textField(
                    controller: _shsController,
                    label: 'Senior High School (Track/Strand)',
                    icon: Icons.school,
                  ),
                  _textField(
                    controller: _collegeController,
                    label: 'College / Course',
                    icon: Icons.school,
                  ),

                  _sectionTitle('Family Background'),

                  _textField(
                    controller: _fatherController,
                    label: "Father's Name & Occupation",
                    icon: Icons.family_restroom,
                  ),
                  _textField(
                    controller: _motherController,
                    label: "Mother's Name & Occupation",
                    icon: Icons.family_restroom,
                  ),
                  _textField(
                    controller: _siblingsController,
                    label: 'Sibling(s) Name(s)',
                    icon: Icons.group,
                    maxLines: 2,
                  ),

                  _sectionTitle('Character References'),

                  _textField(
                    controller: _ref1NameController,
                    label: 'Reference 1 (Name & Position)',
                    icon: Icons.person_outline,
                  ),
                  _textField(
                    controller: _ref1ContactController,
                    label: 'Reference 1 Contact Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  _textField(
                    controller: _ref2NameController,
                    label: 'Reference 2 (Name & Position)',
                    icon: Icons.person_outline,
                  ),
                  _textField(
                    controller: _ref2ContactController,
                    label: 'Reference 2 Contact Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: _isSaving ? null : _submitBioData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5E64),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit Bio Data',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}