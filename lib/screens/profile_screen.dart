import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangman_final_appln/ui/widget/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: uid == null
          ? const Center(child: Text("Not logged in", style: TextStyle(color: Colors.white)))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final username = data['username'] ?? 'Unknown';
                final highestScore = data['highestScore'] ?? 0;
                final totalScore = data['totalScore'] ?? 0;
                final gamesPlayed = data['gamesPlayed'] ?? 0;
                final gamesWon = data['gamesWon'] ?? 0;
                final gamesLost = data['gamesLost'] ?? 0;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFA78BFA),
                          child: Icon(Icons.person, size: 40, color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA78BFA)),
                        ),
                        const SizedBox(height: 20),
                        _buildStatRow("Highest Score", highestScore.toString()),
                        _buildStatRow("Total Score", totalScore.toString()),
                        _buildStatRow("Games Played", gamesPlayed.toString()),
                        _buildStatRow("Wins", gamesWon.toString()),
                        _buildStatRow("Losses", gamesLost.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 18)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
