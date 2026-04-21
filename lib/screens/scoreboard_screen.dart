import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangman_final_appln/ui/widget/glass_card.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  String formatScore(int score, int streak) {
    return "$score  • 🔥 $streak";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Global Scoreboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Error loading scores: ${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No scores yet!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final users =
          docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          users.sort((a, b) =>
              (b['highestScore'] ?? 0).compareTo(a['highestScore'] ?? 0));

          final topUsers = users.take(50).toList();
          final top3 = topUsers.take(3).toList();
          final others = topUsers.skip(3).toList();

          final currentUid = FirebaseAuth.instance.currentUser?.uid;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🏆 TOP 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(top3.length, (index) {
                    final data = top3[index];

                    final username = data['username'] ?? 'Unknown';
                    final score = data['highestScore'] ?? 0;
                    final bestStreak = data['bestStreak'] ?? 0;

                    final isCurrentUser = data['uid'] == currentUid;

                    Color color;
                    if (index == 0) {
                      color = Colors.yellow.shade800;
                    } else if (index == 1) {
                      color = Colors.grey;
                    } else {
                      color = const Color(0xFFCD7F32);
                    }

                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isCurrentUser
                                ? Border.all(color: Colors.blue, width: 3)
                                : null,
                          ),
                          child: CircleAvatar(
                            radius: index == 0 ? 34 : 28,
                            backgroundColor: color,
                            child: Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          username,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          formatScore(score, bestStreak),
                          style: const TextStyle(
                            color: Color(0xFFA78BFA),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // 📋 OTHERS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: others.length,
                  itemBuilder: (context, index) {
                    final data = others[index];

                    final username = data['username'] ?? 'Unknown';
                    final highestScore = data['highestScore'] ?? 0;
                    final bestStreak = data['bestStreak'] ?? 0;

                    final isCurrentUser = data['uid'] == currentUid;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        child: Container(
                          decoration: BoxDecoration(
                            border: isCurrentUser
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                "#${index + 4}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Score: ${formatScore(highestScore, bestStreak)}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              "#${index + 4}",
                              style: const TextStyle(
                                color: Color(0xFFA78BFA),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}