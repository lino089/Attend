import 'package:attend/admin/admin_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SchoolLoginScreen extends StatefulWidget {
  const SchoolLoginScreen({super.key});

  @override
  State<SchoolLoginScreen> createState() => _SchoolLoginScreen();
}

class _SchoolLoginScreen extends State<SchoolLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _npsnController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obsecurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color bgLightGrey = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGreyLabel = Color(0xFF475569);
  static const Color textGreyHint = Color(0xFF94A3B8);
  static const Color inputBgColor = Color(0xFFF1F5F9);

  @override
  void dispose() {
    _npsnController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Berhasil')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Page : ${e.toString()}')));
      } finally {
        if (!mounted) setState(() => false);
      }
    }
  }

  Future<void> _loginWithLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Google Sign-In Dipanggil')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Fitur Forgot Password disiapkan!')));
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
              height: 300,
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
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
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
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          offset: const Offset(0, 4),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'School Admin Portal',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Enter your credentials to acces your\naccount',
                            style: TextStyle(
                              fontSize: 14,
                              color: textGreyHint,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),

                          CustomInputField(
                            label: 'USER NPSN',
                            icon: Icons.person_outline,
                            hintText: 'Enter School NPSN',
                            controller: _npsnController,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'NPSN is required' : null,
                          ),

                          CustomInputField(
                            label: "PASSWORD",
                            icon: Icons.lock_outlined,
                            hintText: '*******',
                            obsecureText: _obsecurePassword,
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obsecurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: textGreyHint,
                              ),
                              onPressed: () => setState(
                                () => _obsecurePassword = !_obsecurePassword,
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Password is required' : null,
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _forgotPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: /*_isLoading || _isGoogleLoading
                                  ? null
                                  : _login*/ () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminMainScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: textGreyHint,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _isLoading || _isGoogleLoading
                                  ? null
                                  : _loginWithLogin,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isGoogleLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: primaryBlue,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.g_mobiledata,
                                          color: Colors.blue,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            color: textDark,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
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
                        "Don't have an account ",
                        style: TextStyle(color: textGreyLabel, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign up',
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
  final bool obsecureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.icon,
    required this.hintText,
    this.obsecureText = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
  });

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
              color: _SchoolLoginScreen.textGreyLabel,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obsecureText,
            validator: validator,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              color: _SchoolLoginScreen.textGreyHint,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: _SchoolLoginScreen.textGreyHint,
                fontSize: 15,
              ),
              filled: true,
              fillColor: _SchoolLoginScreen.inputBgColor,
              prefixIcon: Icon(
                icon,
                color: _SchoolLoginScreen.textGreyHint,
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
                  color: _SchoolLoginScreen.primaryBlue,
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
