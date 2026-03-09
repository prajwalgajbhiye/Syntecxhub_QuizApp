import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/questions.dart';
import '../model/question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {

  List<Question> quizQuestions = [];
  int currentIndex = 0;
  int score = 0;
  int timeLeft = 100;

  Timer? timer;

  String? selectedAnswer;

  @override
  void initState() {
    super.initState();
    startQuiz();
  }

  void startQuiz() {
    quizQuestions = List.from(questions);
    quizQuestions.shuffle();

    for (var q in quizQuestions) {
      q.options.shuffle();
    }

    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    timeLeft = 100;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;

        if (timeLeft == 0) {
          nextQuestion();
        }
      });
    });
  }

  void nextQuestion() {
    if (selectedAnswer ==
        quizQuestions[currentIndex].correctAnswer) {
      score++;
    }

    selectedAnswer = null;

    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      timer?.cancel();
      saveHighScore();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: score),
        ),
      );
    }
  }

  void saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    int high = prefs.getInt("highscore") ?? 0;

    if (score > high) {
      prefs.setInt("highscore", score);
    }
  }

  @override
  Widget build(BuildContext context) {

    Question q = quizQuestions[currentIndex];

    double progress =
        (currentIndex + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title:  Text(
          "Quiz Challenge",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// progress bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: Colors.indigo,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),

            const SizedBox(height: 25),

            /// timer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "⏱ $timeLeft sec",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Text(
                q.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// options
            Expanded(
              child: ListView(
                children: q.options.map((option) {

                  Color color = Colors.white;

                  if (selectedAnswer != null) {
                    if (option == q.correctAnswer) {
                      color = Colors.green.shade300;
                    } else if (option == selectedAnswer) {
                      color = Colors.red.shade300;
                    }
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        setState(() {
                          selectedAnswer = option;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.indigo.shade200,
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            /// next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                selectedAnswer == null ? null : nextQuestion,
                child: Text(
                  currentIndex == quizQuestions.length - 1
                      ? "Submit Quiz"
                      : "Next Question",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}