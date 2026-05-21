import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/exam_info.dart';
import 'package:attend/features/teacher/presentation/screens/exam/create_exam_step2_screen.dart';

class CreateExamStep1Screen extends StatefulWidget {
  final Map<String, dynamic>? existingExamInfo; // For back navigation

  const CreateExamStep1Screen({
    super.key,
    this.existingExamInfo,
  });

  @override
  State<CreateExamStep1Screen> createState() => _CreateExamStep1ScreenState();
}

class _CreateExamStep1ScreenState extends State<CreateExamStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kkmController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  
  // Selected subject
  String? _selectedSubject;
  
  // Subject list - TODO: Fetch from database
  final List<String> _subjects = [
    'Fisika',
    'Matematika',
    'Biologi',
    'Kimia',
    'Bahasa Indonesia',
    'Bahasa Inggris',
  ];

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  @override
  void dispose() {
    _nameController.dispose();
    _kkmController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load existing data if available (back navigation)
    if (widget.existingExamInfo != null) {
      _nameController.text = widget.existingExamInfo!['name'] ?? '';
      _selectedSubject = widget.existingExamInfo!['subject'];
      _kkmController.text = widget.existingExamInfo!['targetKKM']?.toString() ?? '';
      _durationController.text = widget.existingExamInfo!['duration']?.toString() ?? '';
      _instructionsController.text = widget.existingExamInfo!['instructions'] ?? '';
    }
  }

  void _handleNext() async {
    if (_formKey.currentState!.validate()) {
      // Create exam info object
      final examInfo = ExamInfo(
        name: _nameController.text.trim(),
        subject: _selectedSubject!,
        targetKKM: int.parse(_kkmController.text),
        duration: int.parse(_durationController.text),
        instructions: _instructionsController.text.trim(),
      );

      // Navigate to Step 2
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateExamStep2Screen(
            examInfo: examInfo.toJson(),
          ),
        ),
      );
      // When Step 2 pops (after Step 3 saves), this screen should also pop
      // This allows the Exam result to bubble up to Exam List
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Exam',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stepper
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: _buildStepper(),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Ujian
                    _buildLabel('NAMA UJIAN'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Ulangan Harian 1',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama ujian harus diisi';
                        }
                        if (value.length < 3) {
                          return 'Nama ujian minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Mata Pelajaran
                    _buildLabel('MATA PELAJARAN'),
                    const SizedBox(height: 8),
                    _buildDropdown(),
                    const SizedBox(height: 20),

                    // Target KKM & Durasi
                    Row(
                      children: [
                        // Target KKM
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('TARGET KKM'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _kkmController,
                                hint: '75',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'KKM harus diisi';
                                  }
                                  final kkm = int.tryParse(value);
                                  if (kkm == null || kkm < 0 || kkm > 100) {
                                    return 'KKM 0-100';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Durasi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('DURASI (MENIT)'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _durationController,
                                hint: '60',
                                keyboardType: TextInputType.number,
                                prefixIcon: Icons.access_time,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Durasi harus diisi';
                                  }
                                  final duration = int.tryParse(value);
                                  if (duration == null || duration <= 0) {
                                    return 'Durasi > 0';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Instruksi Ujian
                    _buildLabel('INSTRUKSI UJIAN'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _instructionsController,
                      hint: 'Kerjakan dengan jujur, jangan lupa berdoa!',
                      maxLines: 5,
                      validator: null, // Optional field
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lanjut Ke Soal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(1, 'INFO DASAR', true),
        _buildStepConnector(false),
        _buildStep(2, 'SUSUN SOAL', false),
        _buildStepConnector(false),
        _buildStep(3, 'SELESAI', false),
      ],
    );
  }

  Widget _buildStep(int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? primaryBlue : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? primaryBlue : textGrey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 28),
      color: isActive ? primaryBlue : Colors.grey.shade300,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: textGrey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: textGrey.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: textGrey, size: 20)
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSubject,
      hint: Text(
        'Pilih mata pelajaran',
        style: TextStyle(
          color: textGrey.withOpacity(0.5),
          fontSize: 14,
        ),
      ),
      items: _subjects.map((subject) {
        return DropdownMenuItem(
          value: subject,
          child: Text(subject),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSubject = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Mata pelajaran harus dipilih';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: textGrey),
      dropdownColor: Colors.white,
    );
  }
}
