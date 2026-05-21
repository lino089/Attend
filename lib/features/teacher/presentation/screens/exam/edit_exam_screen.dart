import 'package:flutter/material.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/exam.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question_option.dart';
import 'package:attend/features/teacher/presentation/screens/exam/models/question_backup.dart';

class EditExamScreen extends StatefulWidget {
  final Exam exam;

  const EditExamScreen({super.key, required this.exam});

  @override
  State<EditExamScreen> createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  static const Color primaryBlue = Color(0xFF335CFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color lightBlueBadge = Color(0xFFE8EEFF);

  late List<Question> _questions;
  late int _currentQuestionIndex;
  final Map<int, QuestionBackup> _questionBackups = {};
  bool _hasUnsavedChanges = false;

  // Controllers
  late TextEditingController _questionTextController;
  late TextEditingController _weightController;
  late TextEditingController _essayRubricController;
  final List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.exam.questions);
    _currentQuestionIndex = 0;
    _initializeControllers();
  }

  void _initializeControllers() {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    _questionTextController = TextEditingController(text: currentQuestion.questionText);
    _weightController = TextEditingController(text: currentQuestion.weight.toString());
    _essayRubricController = TextEditingController(text: currentQuestion.referenceAnswer ?? '');

    // Initialize option controllers for multiple choice
    _optionControllers.clear();
    for (var option in currentQuestion.options) {
      _optionControllers.add(TextEditingController(text: option.text));
    }
  }

  void _disposeControllers() {
    _questionTextController.dispose();
    _weightController.dispose();
    _essayRubricController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _optionControllers.clear();
  }

  int _calculateTotalWeight() {
    return _questions.fold(0, (sum, question) => sum + question.weight);
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
    final currentTotal = _calculateTotalWeight();
    final remainder = 100 - currentTotal;
    
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
  }

  void _showAutoAdjustFeedback(BuildContext dialogContext, int delta, int affectedCount) {
    final adjustPerQuestion = (delta / affectedCount).abs().round();
    
    // Use root context, not dialog context
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ Bobot disesuaikan: $affectedCount soal ${delta > 0 ? '-' : '+'}$adjustPerQuestion pts',
        ),
        backgroundColor: primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _saveCurrentQuestion() {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    _questions[_currentQuestionIndex] = currentQuestion.copyWith(
      questionText: _questionTextController.text,
      weight: int.tryParse(_weightController.text) ?? currentQuestion.weight,
      options: currentQuestion.type == QuestionType.multipleChoice
          ? _buildOptionsFromControllers()
          : currentQuestion.options,
      referenceAnswer: currentQuestion.type == QuestionType.essay
          ? _essayRubricController.text
          : null,
    );

    _hasUnsavedChanges = true;
  }

  List<QuestionOption> _buildOptionsFromControllers() {
    final currentQuestion = _questions[_currentQuestionIndex];
    List<QuestionOption> options = [];
    
    for (int i = 0; i < _optionControllers.length; i++) {
      options.add(QuestionOption(
        id: currentQuestion.options.length > i 
            ? currentQuestion.options[i].id 
            : DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
        label: String.fromCharCode(65 + i), // A, B, C, D...
        text: _optionControllers[i].text,
        isCorrect: currentQuestion.options.length > i 
            ? currentQuestion.options[i].isCorrect 
            : false,
      ));
    }
    
    return options;
  }

  void _changeQuestionType(QuestionType newType) {
    final currentQuestion = _questions[_currentQuestionIndex];
    
    if (currentQuestion.type == newType) return;

    // Save current data to backup
    if (!_questionBackups.containsKey(_currentQuestionIndex)) {
      _questionBackups[_currentQuestionIndex] = QuestionBackup();
    }

    if (currentQuestion.type == QuestionType.multipleChoice) {
      // Backup multiple choice data
      _questionBackups[_currentQuestionIndex] = _questionBackups[_currentQuestionIndex]!.copyWith(
        multipleChoiceOptions: List.from(currentQuestion.options),
        multipleChoiceCorrectAnswer: currentQuestion.options
            .firstWhere((o) => o.isCorrect, orElse: () => currentQuestion.options.first)
            .label,
      );
    } else {
      // Backup essay data
      _questionBackups[_currentQuestionIndex] = _questionBackups[_currentQuestionIndex]!.copyWith(
        essayRubric: currentQuestion.referenceAnswer,
      );
    }

    // Change type and restore backup if exists
    if (newType == QuestionType.multipleChoice) {
      final backup = _questionBackups[_currentQuestionIndex];
      _questions[_currentQuestionIndex] = currentQuestion.copyWith(
        type: newType,
        options: backup?.multipleChoiceOptions ?? _createDefaultOptions(),
        referenceAnswer: null,
      );
    } else {
      final backup = _questionBackups[_currentQuestionIndex];
      _questions[_currentQuestionIndex] = currentQuestion.copyWith(
        type: newType,
        options: [], // Essay tidak punya options
        referenceAnswer: backup?.essayRubric ?? '',
      );
    }

    _hasUnsavedChanges = true;
    _disposeControllers();
    _initializeControllers();
    setState(() {});
  }

  List<QuestionOption> _createDefaultOptions() {
    return [
      QuestionOption(
        id: '${DateTime.now().millisecondsSinceEpoch}_0',
        label: 'A',
        text: '',
        isCorrect: false,
      ),
      QuestionOption(
        id: '${DateTime.now().millisecondsSinceEpoch}_1',
        label: 'B',
        text: '',
        isCorrect: false,
      ),
    ];
  }

  void _navigateToQuestion(int index) {
    if (index < 0 || index >= _questions.length) return;
    
    _saveCurrentQuestion();
    _disposeControllers();
    _currentQuestionIndex = index;
    _initializeControllers();
    setState(() {});
  }

  void _addNewQuestion() {
    _saveCurrentQuestion();
    
    // Calculate remaining weight
    final currentTotalWeight = _questions.fold(0, (sum, q) => sum + q.weight);
    final remainingWeight = 100 - currentTotalWeight;
    
    // Determine default weight for new question
    int defaultWeight;
    if (_questions.isEmpty) {
      defaultWeight = 100; // First question gets all weight
    } else if (remainingWeight > 0) {
      defaultWeight = remainingWeight > 5 ? 5 : remainingWeight;
    } else {
      // No remaining weight, need to adjust other questions
      defaultWeight = 5;
    }
    
    final newQuestion = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: _questions.length + 1,
      type: QuestionType.multipleChoice,
      questionText: '',
      weight: defaultWeight,
      options: _createDefaultOptions(),
    );

    _questions.add(newQuestion);
    
    // Auto-adjust if total > 100
    if (_questions.length > 1) {
      final newIndex = _questions.length - 1;
      _autoAdjustWeights(newIndex, 0, defaultWeight);
      
      // FIX: Sinkronisasi nilai controller yang sedang aktif sebelum ter-overwrite oleh _saveCurrentQuestion di _navigateToQuestion
      _weightController.text = _questions[_currentQuestionIndex].weight.toString();
      
      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Soal baru ditambahkan. Bobot soal lain disesuaikan otomatis',
          ),
          backgroundColor: primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    _navigateToQuestion(_questions.length - 1);
  }

  void _showAllQuestionsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAllQuestionsModal(),
    );
  }

  Widget _buildAllQuestionsModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Nomor Soal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: textGrey),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Grid of question numbers
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final isActive = index == _currentQuestionIndex;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _navigateToQuestion(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isActive ? primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? primaryBlue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : textDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Add new question button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _addNewQuestion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightBlueBadge,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: primaryBlue, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Tambah Soal Baru',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Perubahan Belum Disimpan'),
        content: const Text('Apakah Anda yakin ingin keluar tanpa menyimpan perubahan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveExam() {
    _saveCurrentQuestion();

    // Validate total weight strictly equals 100
    final totalWeight = _calculateTotalWeight();
    if (totalWeight != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: Total bobot harus tepat 100! (Saat ini: $totalWeight)'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Validate all questions
    for (var question in _questions) {
      if (question.questionText.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Soal ${question.number}: Pertanyaan tidak boleh kosong'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (question.type == QuestionType.multipleChoice) {
        if (question.options.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Soal ${question.number}: Minimal 2 opsi jawaban'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!question.options.any((o) => o.isCorrect)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Soal ${question.number}: Pilih jawaban yang benar'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    // Create updated exam
    final updatedExam = widget.exam.copyWith(questions: _questions);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ujian berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, updatedExam);
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textDark),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Edit Soal ${currentQuestion.number.toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: textDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _saveExam,
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTotalWeightInfo(),
                    const SizedBox(height: 16),
                    _buildTypeAndWeightSection(currentQuestion),
                    const SizedBox(height: 20),
                    _buildQuestionSection(),
                    const SizedBox(height: 20),
                    currentQuestion.type == QuestionType.multipleChoice
                        ? _buildMultipleChoiceSection(currentQuestion)
                        : _buildEssaySection(),
                  ],
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
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
        
      ],
    );
  }

  Widget _buildTypeAndWeightSection(Question question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Type dropdown
          Expanded(
            child: DropdownButtonFormField<QuestionType>(
              value: question.type,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: const [
                DropdownMenuItem(
                  value: QuestionType.multipleChoice,
                  child: Text('Pilihan Ganda'),
                ),
                DropdownMenuItem(
                  value: QuestionType.essay,
                  child: Text('Essay'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _changeQuestionType(value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          // Weight
          Row(
            children: [
              Text(
                'Bobot: ${question.weight} pts',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textDark,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showWeightDialog(),
                child: const Icon(Icons.edit, size: 18, color: textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWeightDialog() {
    final maxAllowed = _calculateMaxAllowedWeight(_currentQuestionIndex);
    
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _weightController.text);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Bobot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bobot (pts)',
                  helperText: _questions.length > 1 
                      ? 'Maksimal: $maxAllowed pts'
                      : 'Harus: 100 pts',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newWeight = int.tryParse(controller.text);
                final dialogContext = context; // Save dialog context
                
                if (newWeight == null || newWeight < 1) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Bobot harus minimal 1 pts'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // Check max allowed
                if (_questions.length > 1 && newWeight > maxAllowed) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Bobot maksimal: $maxAllowed pts'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                // For single question, must be 100
                if (_questions.length == 1 && newWeight != 100) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Bobot harus 100 pts (hanya 1 soal)'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final oldWeight = _questions[_currentQuestionIndex].weight;
                
                // Close dialog first
                Navigator.pop(dialogContext);
                
                // Update current question
                _questions[_currentQuestionIndex] = 
                    _questions[_currentQuestionIndex].copyWith(weight: newWeight);
                
                // Auto-adjust other questions
                if (_questions.length > 1) {
                  _autoAdjustWeights(_currentQuestionIndex, oldWeight, newWeight);
                  _showAutoAdjustFeedback(
                    dialogContext,
                    newWeight - oldWeight, 
                    _questions.length - 1
                  );
                }
                
                _weightController.text = controller.text;
                _hasUnsavedChanges = true;
                setState(() {});
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERTANYAAN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              TextField(
                controller: _questionTextController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tulis pertanyaan di sini...',
                ),
                style: const TextStyle(fontSize: 16),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.image_outlined, color: textGrey),
                  onPressed: () {
                    // TODO: Implement image upload
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceSection(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OPSI JAWABAN',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _optionControllers.length,
          itemBuilder: (context, index) {
            final option = question.options[index];
            return _buildOptionItem(option, index);
          },
        ),
        const SizedBox(height: 16),
        _buildAddOptionButton(),
      ],
    );
  }

  Widget _buildOptionItem(QuestionOption option, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Set this option as correct
          for (int i = 0; i < _questions[_currentQuestionIndex].options.length; i++) {
            _questions[_currentQuestionIndex].options[i] = 
                _questions[_currentQuestionIndex].options[i].copyWith(isCorrect: i == index);
          }
          _hasUnsavedChanges = true;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: option.isCorrect ? primaryBlue : Colors.grey.shade300,
            width: option.isCorrect ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: option.isCorrect ? primaryBlue : Colors.grey.shade400,
                  width: 2,
                ),
                color: option.isCorrect ? primaryBlue : Colors.transparent,
              ),
              child: option.isCorrect
                  ? const Icon(Icons.circle, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: option.isCorrect ? primaryBlue : textDark,
                        ),
                      ),
                      if (option.isCorrect) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(Benar)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _optionControllers[index],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tulis opsi jawaban...',
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOptionButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          final newLabel = String.fromCharCode(65 + _optionControllers.length);
          final newOption = QuestionOption(
            id: '${DateTime.now().millisecondsSinceEpoch}_${_optionControllers.length}',
            label: newLabel,
            text: '',
            isCorrect: false,
          );
          
          _questions[_currentQuestionIndex].options.add(newOption);
          _optionControllers.add(TextEditingController());
          _hasUnsavedChanges = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryBlue, width: 2, style: BorderStyle.solid),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: primaryBlue, size: 20),
            SizedBox(width: 8),
            Text(
              'Tambah Opsi',
              style: TextStyle(
                color: primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEssaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REFERENSI JAWABAN/RUBRIK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: textGrey,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              TextField(
                controller: _essayRubricController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tuliskan poin-poin penting yang harus ada dalam jawaban siswa agar guru mudah mengoreksi.',
                ),
                style: const TextStyle(fontSize: 14),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.image_outlined, color: textGrey),
                  onPressed: () {
                    // TODO: Implement image upload
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous button
            GestureDetector(
              onTap: _currentQuestionIndex > 0
                  ? () => _navigateToQuestion(_currentQuestionIndex - 1)
                  : null,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: _currentQuestionIndex > 0 ? textGrey : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'SOAL\n${(_currentQuestionIndex).toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _currentQuestionIndex > 0 ? textGrey : Colors.grey.shade300,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // All questions button
            GestureDetector(
              onTap: _showAllQuestionsModal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view, color: primaryBlue, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    'SEMUA SOAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            // Next button
            GestureDetector(
              onTap: _currentQuestionIndex < _questions.length - 1
                  ? () => _navigateToQuestion(_currentQuestionIndex + 1)
                  : null,
              child: Row(
                children: [
                  Text(
                    'SOAL\n${(_currentQuestionIndex + 2).toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _currentQuestionIndex < _questions.length - 1
                          ? textGrey
                          : Colors.grey.shade300,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: _currentQuestionIndex < _questions.length - 1
                        ? textGrey
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
