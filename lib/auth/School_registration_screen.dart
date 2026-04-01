import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchoolRegistrationPage extends StatefulWidget {
  const SchoolRegistrationPage({Key? key}) : super(key: key);

  @override
  State<SchoolRegistrationPage> createState() => _SchoolRegistrationPageState();
}

class _SchoolRegistrationPageState extends State<SchoolRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _npsnController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color bgLightGrey = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGreyLabel = Color(0xFF475569);
  static const Color textGreyHint = Color(0xFF94A3B8);
  static const Color inputBgColor = Color(0xFFF1F5F9);

  @override
  void dispose() {
    _nameController.dispose();
    _npsnController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerSchool() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registrasi Berhasil!')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: bgLightGrey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: primaryBlue,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Attend',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register New School',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Fill in the details to create your school\nadministrator account.',
                            style: TextStyle(
                              fontSize: 14,
                              color: textGreyHint,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          CustomInputField(
                            label: 'SCHOOL NAME',
                            hintText: 'Enter school name',
                            icon: Icons.school_outlined,
                            controller: _nameController,
                            validator: (value) => value!.isEmpty
                                ? 'School name is required'
                                : null,
                          ),
                          CustomInputField(
                            label: 'NPSN',
                            hintText: '8-digit NPSN number',
                            icon: Icons.looks_outlined,
                            keyboardType: TextInputType.number,
                            controller: _npsnController,
                            validator: (value) {
                              if (value!.isEmpty) return 'NPSN is required';
                              if (value.length != 8)
                                return 'Must be exactly 8 digits';
                              return null;
                            },
                          ),
                          CustomInputField(
                            label: 'COMPLETE ADDRESS',
                            hintText: 'Full school street address',
                            icon: Icons.location_on_outlined,
                            controller: _addressController,
                            maxLines: 2,
                            validator: (value) =>
                                value!.isEmpty ? 'Address is required' : null,
                          ),
                          CustomInputField(
                            label: 'EMAIL ADDRESS',
                            hintText: 'admin@school.edu',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty) return 'Email is required';
                              if (!value.contains('@'))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                          CustomInputField(
                            label: 'PHONE NUMBER',
                            hintText: '+62 800 0000 000',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            validator: (value) => value!.isEmpty
                                ? 'Phone number is required'
                                : null,
                          ),
                          CustomInputField(
                            label: 'PASSWORD',
                            hintText: '••••••••',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: textGreyHint,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            validator: (value) => value!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                          ),
                          CustomInputField(
                            label: 'CONFIRM PASSWORD',
                            hintText: '••••••••',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            controller: _confirmPasswordController,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: textGreyHint,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                            ),
                            validator: (value) =>
                                value != _passwordController.text
                                ? 'Passwords do not match'
                                : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _registerSchool,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Register School',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: textGreyLabel, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _SchoolRegistrationPageState.textGreyLabel,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 15,
              color: _SchoolRegistrationPageState.textDark,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: _SchoolRegistrationPageState.textGreyHint,
                fontSize: 15,
              ),
              filled: true,
              fillColor: _SchoolRegistrationPageState.inputBgColor,
              prefixIcon: Icon(
                icon,
                color: _SchoolRegistrationPageState.primaryBlue,
                size: 22,
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: _SchoolRegistrationPageState.primaryBlue,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
