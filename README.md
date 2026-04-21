# 🎮 Hangman Game App

A modern, feature-rich Hangman game built using **Flutter** with **Firebase integration** and **Wordnik API**.  
This app delivers a smooth, visually appealing gaming experience with real-time leaderboard, hints system, and player statistics.

---

## ✨ Features

### 🔐 Authentication
- User Registration & Login using Firebase Authentication
- Secure user data handling

### 🎮 Gameplay
- Random word generation using Wordnik API
- Interactive letter-based guessing system
- Visual hangman progression
- Maximum 6 incorrect attempts

### 💡 Hint System
- 📖 Definition Hint (Word meaning)
- 🔤 Letter Reveal (up to 2 letters)
- Smart hint limitations (max 3 per game)

### 🧠 Game Mechanics
- Dynamic score calculation
- 🔥 Win Streak tracking
- 🎯 Difficulty Levels (Easy, Medium, Hard)

### 🏆 Leaderboard
- Global leaderboard using Cloud Firestore
- 🥇 Top 3 players highlighted (Gold, Silver, Bronze)
- Player rank display
- Current user highlighted

### 📊 User Stats
- Games played, won, lost
- Highest score
- Total score
- Best streak

### 🎨 UI/UX
- Clean, modern UI with gradient background
- Glassmorphism components
- Responsive layout
- Smooth animations

---

## 🛠️ Tech Stack

| Technology | Purpose |
|-----------|--------|
| Flutter | Cross-platform app development |
| Dart | Programming language |
| Firebase Auth | User authentication |
| Cloud Firestore | Database & leaderboard |
| Wordnik API | Word generation & definitions |
| Git | Version control |

---

## 🎮 Game Rules

- Guess the hidden word letter by letter
- Each incorrect guess draws part of the hangman
- Maximum **6 wrong attempts**
- Use hints wisely (max 3)

---

## 📊 Score Calculation


Score = (Word Length × 10)
+ (Remaining Tries × 5)
− (Hints Used × 5)


---

## 🚀 Getting Started

### 1. Clone the repository
git clone https://github.com/yourusername/hangman-flutter-app.git

### 2. Navigate to the project
cd hangman-flutter-app

### 3. Install dependencies
flutter pub get

### 4. Firebase Setup
- Add your Firebase config file:
android/app/google-services.json

### 5. Run the app
flutter run


---


## 📸 Screenshots

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/85af149e-ef5f-40d9-a147-aa90c6999ddb" width="180"/>
  <img src="https://github.com/user-attachments/assets/634ab3bf-9590-488b-a7d4-e8aed5d130ab" width="180"/>
  <img src="https://github.com/user-attachments/assets/9803d266-0cf2-44f6-9d39-ad6145c0092f" width="180"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/a222e961-20f1-4f8f-94dc-bd676bc169ed" width="180"/>
  <img src="https://github.com/user-attachments/assets/acd91314-d379-4bbc-90fe-55e33347c96f" width="180"/>
  <img src="https://github.com/user-attachments/assets/f1489b5f-5b53-431a-a64a-a6baf9532f29" width="180"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/226e4d87-4af2-4c82-8d82-9b3335656bd5" width="200"/>
</p>


---


## 🧩 Project Structure


lib/
├── screens/
│ ├── login_screen.dart
│ ├── register_screen.dart
│ ├── game_screen.dart
│ ├── scoreboard_screen.dart
│ ├── profile_screen.dart
│
├── services/
│ ├── wordnik_service.dart
│
├── utils/
│ ├── game.dart
│
├── ui/
│ ├── widgets/


---


## 🚧 Future Enhancements

- ⏱️ Timer Mode
- 🧟 Survival Mode
- 🔊 Sound Effects
- 🌐 Offline Mode
- 🎯 Daily Challenges


---


## 👩‍💻 Author
**Sneha Das**  
Flutter Developer


---


## ⭐ Support

If you like this project, consider giving it a ⭐ on GitHub!
