import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question_option.dart';
import 'package:attend/features/teacher/presentation/screens/exam/create_exam_step3_screen.dart';

class CreateExamStep2Screen extends StatefulWidget {
  final Map<String, dynamic> examInfo; // From Step 1
  final List<Question>? existingQuestions; // For back navigation

  const CreateExamStep2Screen({
    super.key,
    required this.examInfo,
    this.existingQuestions,
  });

  @override
  State<CreateExamStep2Screen> createState() => _CreateExamStep2ScreenState();
}

class _CreateExamStep2ScreenState extends State<CreateExamStep2Screen> {
  final List<Question> _questions = [];
  final List<TextEditingController> _weightControllers = [];
  int _defaultOptionCount = 4; // Smart feature: remember last option count
  int _totalWeight = 0;
  final int _maxWeight = 100;

  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBadge = Color(0xFFE8EEFF);
  static const Color greenCheck = Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    // Load existing questions if available (back navigation)
    if (widget.existingQuestions != null && widget.existingQuestions!.isNotEmpty) {
      _questions.addAll(widget.existingQuestions!);
      for (var q in _questions) {
        _weightControllers.add(TextEditingController(text: q.weight.toString()));
      }
      _updateTotalWeight();
      // Update default option count from last multiple choice question
      final lastMultipleChoice = _questions.lastWhere(
        (q) => q.type == QuestionType.multipleChoice,
        orElse: () => _questions.first,
      );
      if (lastMultipleChoice.type == QuestionType.multipleChoice) {
        _defaultOptionCount = lastMultipleChoice.options.length;
      }
    } else {
      // Add first question by default
      _addQuestion();
    }
  }

  @override
  void dispose() {
    for (var controller in _weightControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    // Calculate smart default weight
    int defaultWeight;
    if (_questions.isEmpty) {
      defaultWeight = 100; // First question gets all weight
    } else {
      final remainingWeight = 100 - _totalWeight;
      if (remainingWeight > 0) {
        defaultWeight = remainingWeight > 10 ? 10 : remainingWeight;
      } else {
        defaultWeight = 10; // Will be adjusted
      }
    }
    
    final newQuestion = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: _questions.length + 1,
      type: QuestionType.multipleChoice,
      questionText: '',
      weight: defaultWeight,
      options: _createDefaultOptions(_defaultOptionCount),
    );

    setState(() {
      _questions.add(newQuestion);
      _weightControllers.add(TextEditingController(text: newQuestion.weight.toString()));
      
      // Auto-adjust if more than 1 question
      if (_questions.length > 1) {
        final newIndex = _questions.length - 1;
        _autoAdjustWeights(newIndex, 0, defaultWeight);
        
        for (int i = 0; i < _questions.length; i++) {
          _weightControllers[i].text = _questions[i].weight.toString();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '✓ Soal baru ditambahkan. Bobot soal lain disesuaikan otomatis',
            ),
            backgroundColor: primaryBlue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      _updateTotalWeight();
    });
  }

  List<QuestionOption> _createDefaultOptions(int count) {
    final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    return List.generate(
      count,
      (index) => QuestionOption(
        id: '${DateTime.now().millisecondsSinceEpoch}_$index',
        label: labels[index],
        text: '',
        isCorrect: index == 0, // First option is correct by default
      ),
    );
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _weightControllers[index].dispose();
      _weightControllers.removeAt(index);
      _renumberQuestions();
      _updateTotalWeight();
    });
  }

  void _copyQuestion(int index) {
    final original = _questions[index];
    final copied = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: _questions.length + 1,
      type: original.type,
      questionText: original.questionText,
      weight: original.weight,
      options: original.options
          .map((o) => QuestionOption(
                id: '${DateTime.now().millisecondsSinceEpoch}_${o.label}',
                label: o.label,
                text: o.text,
                isCorrect: o.isCorrect,
              ))
          .toList(),
      referenceAnswer: original.referenceAnswer,
    );

    setState(() {
      _questions.add(copied);
      _weightControllers.add(TextEditingController(text: copied.weight.toString()));
      
      // Auto-adjust weights
      if (_questions.length > 1) {
        final newIndex = _questions.length - 1;
        _autoAdjustWeights(newIndex, 0, copied.weight);
        
        for (int i = 0; i < _questions.length; i++) {
          _weightControllers[i].text = _questions[i].weight.toString();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '✓ Soal berhasil dicopy. Bobot soal lain disesuaikan otomatis',
            ),
            backgroundColor: primaryBlue,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      _updateTotalWeight();
    });
  }

  void _renumberQuestions() {
    for (int i = 0; i < _questions.length; i++) {
      _questions[i].number = i + 1;
    }
  }

  void _updateTotalWeight() {
    _totalWeight = _questions.fold(0, (sum, q) => sum + q.weight);
  }

  int _calculateMaxAllowedWeight(int questionIndex) {
    final otherQuestionsCount = _questions.length - 1;
    if (otherQuestionsCount == 0) return 100; // Only 1 question
    return 100 - otherQuestionsCount; // Each other question min 1
  }

  void _autoAdjustWeights(int changedQuestionIndex, int oldWeight, int newWeight) {
    final delta = newWeight - oldWeight;
    
    if (delta == 0) return; // No change
    
    // Get other questions indices (exclude current)
    final otherQuestions = <int>[];
    for (int i = 0; i < _questions.length; i++) {
      if (i != changedQuestionIndex) {
        otherQuestions.add(i);
      }
    }
    
    if (otherQuestions.isEmpty) return; // Only 1 question
    
    // Calculate adjustment per question
    final adjustPerQuestion = delta / otherQuestions.length;
    
    // Apply adjustment
    for (int i in otherQuestions) {
      final currentWeight = _questions[i].weight;
      final newQuestionWeight = currentWeight - adjustPerQuestion;
      
      // Round to integer
      final roundedWeight = newQuestionWeight.round();
      
      // Ensure minimum 1
      final finalWeight = roundedWeight < 1 ? 1 : roundedWeight;
      
      _questions[i] = _questions[i].copyWith(weight: finalWeight);
    }
    
    // Handle rounding remainder to ensure total = 100
    _distributeRemainder(changedQuestionIndex);
  }

  void _distributeRemainder(int excludeIndex) {
    _updateTotalWeight();
    final remainder = 100 - _totalWeight;
    
    if (remainder == 0) return;
    
    // Sort questions by weight (descending), exclude current
    final sortedIndices = <int>[];
    for (int i = 0; i < _questions.length; i++) {
      if (i != excludeIndex) {
        sortedIndices.add(i);
      }
    }
    sortedIndices.sort((a, b) => 
      _questions[b].weight.compareTo(_questions[a].weight)
    );
    
    // Distribute remainder to questions with highest weight
    int distributed = 0;
    for (int i in sortedIndices) {
      if (distributed >= remainder.abs()) break;
      
      if (remainder > 0) {
        _questions[i] = _questions[i].copyWith(
          weight: _questions[i].weight + 1
        );
        distributed++;
      } else {
        if (_questions[i].weight > 1) {
          _questions[i] = _questions[i].copyWith(
            weight: _questions[i].weight - 1
          );
          distributed++;
        }
      }
    }
    
    _updateTotalWeight();
  }

  int _calculateTotalWeight() {
    return _questions.fold(0, (sum, question) => sum + question.weight);
  }

  Widget _buildTotalWeightInfo() {
    final totalWeight = _calculateTotalWeight();
    final isValid = totalWeight == 100;
    final totalQuestions = _questions.length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isValid ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.warning,
                color: isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total: $totalQuestions Soal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isValid ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Total Bobot: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isValid ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                          ),
                        ),
                        Text(
                          '$totalWeight/100',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                    if (!isValid) ...[
                      const SizedBox(height: 4),
                      Text(
                        totalWeight > 100 
                            ? 'Bobot melebihi 100! Kurangi ${totalWeight - 100} poin'
                            : 'Bobot kurang dari 100! Tambah ${100 - totalWeight} poin',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Auto-adjust info badge
        if (totalQuestions > 1) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFDEEAFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-adjust: Aktif',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bobot soal lain akan menyesuaikan otomatis',
                        style: TextStyle(
                          fontSize: 11,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _changeQuestionType(int index, QuestionType newType) {
    setState(() {
      _questions[index].type = newType;
      
      if (newType == QuestionType.multipleChoice) {
        // Switch to multiple choice: create default options
        _questions[index].options = _createDefaultOptions(_defaultOptionCount);
        _questions[index].referenceAnswer = null;
      } else {
        // Switch to essay: clear options
        _questions[index].options = [];
        _questions[index].referenceAnswer = '';
      }
    });
  }

  void _addOption(int questionIndex) {
    final question = _questions[questionIndex];
    final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    final nextLabel = labels[question.options.length];

    setState(() {
      question.options.add(QuestionOption(
        id: '${DateTime.now().millisecondsSinceEpoch}_${nextLabel}',
        label: nextLabel,
        text: '',
        isCorrect: false,
      ));
      
      // Update default option count for next multiple choice question
      _defaultOptionCount = question.options.length;
    });
  }

  void _deleteOption(int questionIndex, int optionIndex) {
    setState(() {
      _questions[questionIndex].options.removeAt(optionIndex);
      // Re-label options
      final labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
      for (int i = 0; i < _questions[questionIndex].options.length; i++) {
        _questions[questionIndex].options[i].label = labels[i];
      }
      
      // Update default option count
      _defaultOptionCount = _questions[questionIndex].options.length;
    });
  }

  void _setCorrectAnswer(int questionIndex, int optionIndex) {
    setState(() {
      // Set all to false first
      for (var option in _questions[questionIndex].options) {
        option.isCorrect = false;
      }
      // Set selected to true
      _questions[questionIndex].options[optionIndex].isCorrect = true;
    });
  }

  bool _validateQuestions() {
    if (_questions.isEmpty) {
      _showError('Minimal harus ada 1 soal');
      return false;
    }

    // No need to validate total weight - auto-adjust ensures it's always 100

    for (var question in _questions) {
      if (question.questionText.trim().isEmpty) {
        _showError('Soal No. ${question.number}: Pertanyaan harus diisi');
        return false;
      }

      if (question.weight <= 0) {
        _showError('Soal No. ${question.number}: Bobot harus > 0');
        return false;
      }

      if (question.type == QuestionType.multipleChoice) {
        if (question.options.length < 2) {
          _showError('Soal No. ${question.number}: Minimal 2 opsi jawaban');
          return false;
        }

        if (!question.options.any((o) => o.isCorrect)) {
          _showError('Soal No. ${question.number}: Pilih jawaban yang benar');
          return false;
        }

        for (var option in question.options) {
          if (option.text.trim().isEmpty) {
            _showError('Soal No. ${question.number}: Semua opsi harus diisi');
            return false;
          }
        }
      }
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleNext() async {
    if (_validateQuestions()) {
      // Navigate to Step 3
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateExamStep3Screen(
            examInfo: widget.examInfo,
            questions: _questions,
          ),
        ),
      );
      // When Step 3 pops, this screen should also pop
      // This allows the result to bubble up to Step 1
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

          // Info Badges
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildInfoBadge(
                    Icons.format_list_numbered,
                    'Total Soal: ${_questions.length}',
                  ),
                  const SizedBox(width: 12),
                  _buildInfoBadge(
                    Icons.scale,
                    'Total Bobot: $_totalWeight/$_maxWeight',
                  ),
                ],
              ),
            ),
          ),

          // Questions List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Total Weight Info with Auto-adjust badge
                  _buildTotalWeightInfo(),
                  const SizedBox(height: 20),
                  
                  ..._questions.asMap().entries.map((entry) {
                    return _buildQuestionCard(entry.key);
                  }),
                  
                  const SizedBox(height: 16),
                  
                  // Add Card Button
                  _buildAddCardButton(),
                  
                  const SizedBox(height: 32),
                ],
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
                    'Simpan & Lanjut',
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
        _buildStep(1, 'DETAIL', true, isComplete: true),
        _buildStepConnector(true),
        _buildStep(2, 'SUSUN SOAL', true),
        _buildStepConnector(false),
        _buildStep(3, 'SELESAI', false),
      ],
    );
  }

  Widget _buildStep(int number, String label, bool isActive, {bool isComplete = false}) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isComplete 
                ? greenCheck 
                : isActive 
                    ? primaryBlue 
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : Text(
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

  Widget _buildInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: lightBlueBadge,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryBlue, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = _questions[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal No. ${question.number}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              Row(
                children: [
                  Text(
                    'BOBOT',
                    style: TextStyle(
                      fontSize: 12,
                      color: textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _weightControllers[index],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                      ),
                      onChanged: (value) {
                        final newWeight = int.tryParse(value) ?? 0;
                        if (newWeight < 1) return; // Minimum 1
                        
                        // Check max allowed
                        final maxAllowed = _calculateMaxAllowedWeight(index);
                        if (_questions.length > 1 && newWeight > maxAllowed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bobot maksimal: $maxAllowed pts'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        
                        // For single question, must be 100
                        if (_questions.length == 1 && newWeight != 100) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bobot harus 100 pts (hanya 1 soal)'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        
                        final oldWeight = question.weight;
                        setState(() {
                          question.weight = newWeight;
                          
                          // Auto-adjust other questions
                          if (_questions.length > 1 && oldWeight != newWeight) {
                            _autoAdjustWeights(index, oldWeight, newWeight);
                            
                            for (int i = 0; i < _questions.length; i++) {
                              if (i != index) {
                                _weightControllers[i].text = _questions[i].weight.toString();
                              }
                            }
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '✓ Bobot disesuaikan: ${_questions.length - 1} soal lain',
                                ),
                                backgroundColor: primaryBlue,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          
                          _updateTotalWeight();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question Type Dropdown
          _buildQuestionTypeDropdown(index),
          const SizedBox(height: 16),

          // Question Text
          _buildQuestionTextField(index),
          const SizedBox(height: 16),

          // Type-specific content
          if (question.type == QuestionType.multipleChoice)
            _buildMultipleChoiceOptions(index)
          else
            _buildEssayReferenceAnswer(index),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.content_copy, size: 20),
                color: textGrey,
                onPressed: () => _copyQuestion(index),
                tooltip: 'Duplikat soal',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red,
                onPressed: () => _deleteQuestion(index),
                tooltip: 'Hapus soal',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeDropdown(int index) {
    final question = _questions[index];
    
    return DropdownButtonFormField<QuestionType>(
      value: question.type,
      items: [
        DropdownMenuItem(
          value: QuestionType.multipleChoice,
          child: Row(
            children: [
              Icon(Icons.radio_button_checked, color: primaryBlue, size: 20),
              const SizedBox(width: 12),
              const Text('Pilihan Ganda'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: QuestionType.essay,
          child: Row(
            children: [
              Icon(Icons.subject, color: primaryBlue, size: 20),
              const SizedBox(width: 12),
              const Text('Essay'),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          _changeQuestionType(index, value);
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: textGrey),
    );
  }

  Widget _buildQuestionTextField(int index) {
    final question = _questions[index];
    
    return TextFormField(
      initialValue: question.questionText,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Tulis pertanyaan di sini...',
        hintStyle: TextStyle(
          color: textGrey.withOpacity(0.5),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined, size: 20),
              color: textGrey,
              onPressed: () {
                // TODO: Add image
              },
            ),
            if (question.type == QuestionType.multipleChoice)
              IconButton(
                icon: const Icon(Icons.functions, size: 20),
                color: textGrey,
                onPressed: () {
                  // TODO: Add formula
                },
              ),
          ],
        ),
      ),
      onChanged: (value) {
        question.questionText = value;
      },
    );
  }

  Widget _buildMultipleChoiceOptions(int index) {
    final question = _questions[index];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPSI JAWABAN',
          style: TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        ...question.options.asMap().entries.map((entry) {
          final optionIndex = entry.key;
          final option = entry.value;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Radio button
                Radio<int>(
                  value: optionIndex,
                  groupValue: question.options.indexWhere((o) => o.isCorrect),
                  onChanged: (value) {
                    if (value != null) {
                      _setCorrectAnswer(index, value);
                    }
                  },
                  activeColor: primaryBlue,
                ),
                
                // Label
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      option.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Option text field
                Expanded(
                  child: TextFormField(
                    initialValue: option.text,
                    decoration: InputDecoration(
                      hintText: 'Opsi Jawaban ${option.label}',
                      hintStyle: TextStyle(
                        color: textGrey.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      option.text = value;
                    },
                  ),
                ),
                
                // Delete option button (only if more than 2 options)
                if (question.options.length > 2)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: Colors.red,
                    onPressed: () => _deleteOption(index, optionIndex),
                  ),
              ],
            ),
          );
        }),
        
        // Add Option Button
        if (question.options.length < 8)
          TextButton.icon(
            onPressed: () => _addOption(index),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Opsi'),
            style: TextButton.styleFrom(
              foregroundColor: primaryBlue,
            ),
          ),
      ],
    );
  }

  Widget _buildEssayReferenceAnswer(int index) {
    final question = _questions[index];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFERENSI JAWABAN/RUBRIK',
          style: TextStyle(
            fontSize: 12,
            color: textGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        
        TextFormField(
          initialValue: question.referenceAnswer ?? '',
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Tuliskan poin-poin penting yang harus ada dalam jawaban siswa agar guru mudah mengoreksi.',
            hintStyle: TextStyle(
              color: textGrey.withOpacity(0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) {
            question.referenceAnswer = value;
          },
        ),
      ],
    );
  }

  Widget _buildAddCardButton() {
    return Center(
      child: InkWell(
        onTap: _addQuestion,
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: primaryBlue,
            strokeWidth: 2,
            dashWidth: 8,
            dashSpace: 4,
            borderRadius: 20,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryBlue,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tambah Card Soal',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter untuk membuat dashed border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashWidth : dashSpace;
        if (distance + length > metric.length) {
          if (draw) {
            dashedPath.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        }
        if (draw) {
          dashedPath.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
