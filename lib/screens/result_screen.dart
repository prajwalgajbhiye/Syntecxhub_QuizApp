import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;

  const ResultScreen({super.key, required this.score});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {

  int highScore = 0;

  @override
  void initState() {
    super.initState();
    loadScore();
  }

  void loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt("highscore") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isNewHigh = widget.score >= highScore;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// Result Icon
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.indigo.shade100,
                child: Icon(
                  isNewHigh ? Icons.emoji_events : Icons.check_circle,
                  size: 70,
                  color: Colors.indigo,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Quiz Finished",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              /// Score Card
              Container(
                padding: const EdgeInsets.all(25),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    const Text(
                      "Your Score",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${widget.score}",
                      style: const TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Divider(),

                    const SizedBox(height: 10),

                    Text(
                      "High Score: $highScore",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (isNewHigh)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "🎉 New High Score!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// Restart Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Play Again",
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}