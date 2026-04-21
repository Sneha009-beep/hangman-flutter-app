import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:hangman_final_appln/services/wordnik_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hangman_final_appln/utils/game.dart';
import 'package:hangman_final_appln/ui/widget/letter.dart';
import 'package:hangman_final_appln/ui/widget/figure.dart';
import 'package:hangman_final_appln/screens/scoreboard_screen.dart';

class GameScreen extends StatefulWidget {
  final int minLength;
  final int maxLength;

  const GameScreen({super.key, required this.minLength, required this.maxLength});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String word = "";
  bool isLoading = true;
  final String alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  int streak = 0;
  int hintsUsed = 0;
  String? hintDefinition;
  bool isFetchingHint = false;
  final List<String> hintRevealedLetters = [];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    Game.resetGame();
    _fetchWord();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchWord() async {
    final fetchedWord = await WordnikService.getRandomWord(
        minLength: widget.minLength, maxLength: widget.maxLength);
    setState(() {
      word = fetchedWord?.toUpperCase() ?? "FLUTTER";
      isLoading = false;
    });
  }

  Future<void> _useHint() async {
    if (hintsUsed >= 3) return;
    final nextHint = hintsUsed + 1;

    if (nextHint == 1) {
      setState(() => isFetchingHint = true);
      final def = await WordnikService.getDefinition(word);
      setState(() {
        hintDefinition = def ?? "No definition available.";
        hintsUsed = 1;
        isFetchingHint = false;
      });
      _showHintDialog("📖 Hint", hintDefinition!);
    } else {
      final unrevealed = word
          .split('')
          .toSet()
          .where((c) =>
      !Game.selectedChar.contains(c) &&
          !hintRevealedLetters.contains(c))
          .toList();

      if (unrevealed.isEmpty) return;

      final randomLetter = unrevealed[Random().nextInt(unrevealed.length)];

      setState(() {
        hintsUsed = nextHint;
        hintRevealedLetters.add(randomLetter);
        Game.selectedChar.add(randomLetter);
      });

      _showHintDialog("💡 Letter Hint", "Letter \"$randomLetter\" is in the word!");
      _checkGameStatus();
    }
  }

  void _showHintDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: const TextStyle(color: Color(0xFFA78BFA))), // purple
        content: Text(message,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA78BFA),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void onLetterPressed(String letter) {
    if (Game.selectedChar.contains(letter)) return;
    setState(() {
      Game.selectedChar.add(letter);
      if (!word.contains(letter)) Game.tries++;
    });
    _checkGameStatus();
  }

  void _checkGameStatus() {
    bool hasWon = word.split('').every((c) => Game.selectedChar.contains(c));
    if (hasWon) {
      _endGame(true);
    } else if (Game.tries >= 6) {
      _endGame(false);
    }
  }

  Future<void> _endGame(bool isWin) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    int score = 0;
    if (isWin) {
      score = (word.length * 10) + ((6 - Game.tries) * 5) - (hintsUsed * 5);
      if (score < 0) score = 0;
    }
    if (isWin) {
      streak++;
    } else {
      streak = 0;
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() ?? {};

      int highestScore = data['highestScore'] ?? 0;
      int totalScore = data['totalScore'] ?? 0;
      int gamesPlayed = data['gamesPlayed'] ?? 0;
      int gamesWon = data['gamesWon'] ?? 0;
      int gamesLost = data['gamesLost'] ?? 0;
      int currentStreak = data['streak'] ?? 0;
      int bestStreak = data['bestStreak'] ?? 0;

      gamesPlayed += 1;

      if (isWin) {
        gamesWon++;
        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else {
        gamesLost++;
        currentStreak = 0;
      }

      if (score > highestScore) highestScore = score;
      totalScore += score;
      if (score > highestScore) highestScore = score;
      totalScore += score;

      transaction.set(docRef, {
        'uid': uid,
        'highestScore': highestScore,
        'totalScore': totalScore,
        'gamesPlayed': gamesPlayed,
        'gamesWon': gamesWon,
        'gamesLost': gamesLost,
        'streak': currentStreak,
        'bestStreak': bestStreak,
      }, SetOptions(merge: true));
    });

    if (isWin) {
      _confettiController.play();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isWin ? "🏆 You Won!" : "💀 Game Over",
            style: const TextStyle(color: Color(0xFF3B82F6))),
        content: Text(
          isWin ? "Score: $score" : "The word was: $word",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              Game.resetGame();              // reset tries + selected chars
              hintsUsed = 0;                 // reset hints
              hintDefinition = null;
              hintRevealedLetters.clear();
              isLoading = true;              // show loader while fetching
              });
            _confettiController.stop();      // stop confetti if running
            _fetchWord();                    // fetch new word
            },
            child: const Text("Play Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Change Level"),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHintButton() {
    final remaining = 3 - hintsUsed;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: _useHint,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFA78BFA).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFA78BFA)),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb,
                  color: Color(0xFFA78BFA), size: 16),
              const SizedBox(width: 5),
              Text("Hint ($remaining)",
                  style: const TextStyle(
                      color: Color(0xFFA78BFA),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hangman"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildHintButton(),

          IconButton(
            icon: const Icon(Icons.bar_chart, color: Color(0xFF3B82F6)),
            tooltip: "Leaderboard",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ScoreboardScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF020617),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  const SizedBox(height: 10),

                  // 🔹 Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _infoBox("Tries", "${Game.tries}"),
                      _infoBox("Hints", "${3 - hintsUsed}"),
                      _infoBox("🔥 Streak", "$streak"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // 🔹 Hangman (slightly reduced)
                  SizedBox(
                    height: 160,
                    child: Center(
                      child: Stack(
                        children: [
                          figure(Game.tries >= 0, "assets/hang.png"),
                          figure(Game.tries >= 1, "assets/head.png"),
                          figure(Game.tries >= 2, "assets/body.png"),
                          figure(Game.tries >= 3, "assets/ra.png"),
                          figure(Game.tries >= 4, "assets/la.png"),
                          figure(Game.tries >= 5, "assets/rl.png"),
                          figure(Game.tries >= 6, "assets/ll.png"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 WORD (NO FIXED HEIGHT ❌)
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: word.split('').map((e) {
                          bool isHidden = !Game.selectedChar.contains(e);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 40,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isHidden
                                  ? Colors.transparent
                                  : const Color(0xFF3B82F6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFF3B82F6),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              isHidden ? "" : e,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: word.length > 8 ? 20 : 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 KEYBOARD (ALWAYS SAFE)
                  Flexible(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 7,
                        runSpacing: 6,
                        alignment: WrapAlignment.center,
                        children: alphabets.split('').map((e) {
                          bool isSelected = Game.selectedChar.contains(e);

                          Color bgColor = Colors.white10;

                          if (isSelected) {
                            bgColor = word.contains(e)
                                ? Colors.green
                                : Colors.red;
                          }

                          return GestureDetector(
                            onTap: () => onLetterPressed(e),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 36,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  )
                                ],
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.orange,
                Colors.pink,
                Colors.yellow,
                Colors.white,
                Colors.cyan,
                Colors.red,
                Colors.teal
              ],
            ),
          ),
        ],
      ),
    );
  }
}