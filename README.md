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


<p align="center">
  <img src="https://github.com/user-attachments/assets/28ed22b1-c29c-42ac-a9c0-ad35986015c2" width="180"/>
  <img src="https://github.com/user-attachments/assets/5d76993b-e757-4a9a-8e56-53480da79a10" width="180"/>
  <img src="https://github.com/user-attachments/assets/e7cec89b-2e36-427e-b4d6-4d7d0d3b836e" width="180"/>
  <img src="https://github.com/user-attachments/assets/dab9ffd5-d5a0-469e-9fd6-7f3aa6271c06" width="180"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/44799458-c245-4ebc-8baa-cd45bee40a23" width="180"/>
  <img src="https://github.com/user-attachments/assets/642e80f6-5115-4104-ad17-279bbc732b92" width="180"/>
  <img src="https://github.com/user-attachments/assets/dcc2e30c-071e-44e9-b31b-2055d1dc8788" width="200"/>
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
