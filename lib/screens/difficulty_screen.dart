import 'package:flutter/material.dart';
import 'package:hangman_final_appln/screens/game_screen.dart';
import 'package:hangman_final_appln/ui/widget/glass_card.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Select Difficulty"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF020617),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Choose Level",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF3B82F6), // blue accent
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Keep difficulty colors same
                  buildButton(context, "Beginner", 4, 6,
                      Icons.sentiment_satisfied, Colors.green),

                  buildButton(context, "Medium", 6, 8,
                      Icons.sentiment_neutral, Colors.orange),

                  buildButton(context, "Hard", 8, 12,
                      Icons.sentiment_very_dissatisfied, Colors.redAccent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String title, int min, int max,
      IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(minLength: min, maxLength: max),
              ),
            );
          },
          icon: Icon(icon),
          label: Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}