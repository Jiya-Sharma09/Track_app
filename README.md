# 🚀 Trackster

Trackster is an AI-powered productivity and task management application built with Flutter. It helps users stay organized, improve productivity, and maintain motivation through intelligent task analysis, progress tracking, and inspirational content.

## ✨ Features

### 📋 Task Management
- Create, edit, and delete tasks
- Mark tasks as completed or pending
- Organize tasks by date
- Navigate through tasks using an integrated weekly calendar
- View and manage tasks for any selected day

### 🤖 AI Productivity Coach
Powered by **Google Gemini (gemini-2.5-flash)**.

The AI coach can:
- Analyze daily task lists
- Generate personalized productivity summaries
- Calculate task completion progress
- Suggest actionable productivity strategies
- Recommend techniques such as:
  - Eat the Frog
  - Pomodoro Technique
  - Task Prioritization
- Answer follow-up productivity questions through an integrated chat interface

### 📊 Productivity Analytics
Track your progress with visual insights:
- Today's completion percentage
- Number of completed and remaining tasks
- Last 7 days productivity overview
- Interactive pie charts and statistics

### 💡 Inspire
Stay motivated throughout the day:
- Fetches inspirational and motivational quotes
- Integrated with a public quotes API
- Refresh quotes with a single tap

### 🔐 Authentication
- User registration
- User login
- JWT-based authentication
- Secure token storage using Flutter Secure Storage

### 🌙 Theme Support
- Light Mode
- Dark Mode
- Material 3 Design

---

## 📱 Screenshots

### Authentication

| Login | Sign Up |
|---------|---------|
| (<img width="" height="100" alt="image" src="https://github.com/user-attachments/assets/f219b0da-1987-40bb-b0cd-49b1e8861a30" />
) | (<img width="" height="100" alt="image" src="https://github.com/user-attachments/assets/7d29429a-e9a9-4fdf-9496-77b599ca14bf" />
) |

### Tasks Dashboard

| Tasks Screen |
|---------|
| !(<img width="" height="100" alt="image" src="https://github.com/user-attachments/assets/c250f954-b9ac-44f2-9d29-f87aca50ed64" />
) |

### AI Productivity Coach

| AI Coach |
|---------|
| (<img width="" height="100" alt="image" src="https://github.com/user-attachments/assets/45990be8-089e-427c-8f99-63e3ab71c089" />
) |

### Productivity Statistics

| Stats |
|---------|
| ![Stats](screenshots/stats.png) |

### Inspire

| Inspire |
|---------|
| ![Inspire](screenshots/inspire.png) |

---

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart
- Material 3
- Provider

### AI Integration
- Google Gemini API
- Gemini 2.5 Flash

### Backend
- Spring Boot REST API

### Authentication & Security
- JWT Authentication
- Flutter Secure Storage

### APIs
- Custom Backend APIs
- Public Motivational Quotes API

---

## 📂 Project Structure

```text
lib/
├── model/
├── providers/
├── screens/
├── service/
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have:

- Flutter SDK installed
- Android Studio or VS Code
- Android Emulator or Physical Device

Verify Flutter installation:

```bash
flutter doctor
```

### Installation

Clone the repository:

```bash
git clone https://github.com/<your-username>/trackster.git
```

Navigate to the project folder:

```bash
cd trackster
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

---

## ⚙️ Configuration

Create a configuration file for your API endpoints and credentials.

Example:

```dart
const String baseUrl = "YOUR_BACKEND_URL";


// lib/service/gemini_key.dart  (already in .gitignore)
class GeminiConfig {
  static const apiKey = "YOUR_GEMINI_API_KEY";
}
```

> Never commit API keys, JWT secrets, or sensitive credentials to GitHub.

---

## 🎯 What I Learned

Through building Trackster, I gained practical experience with:

- Flutter application development
- State management using Provider
- REST API integration
- JWT authentication
- Secure credential storage
- AI integration using Google Gemini
- Building scalable mobile applications
- Team collaboration using Git and GitHub

---

## 🔮 Future Enhancements

- Task priorities
- Task categories and tags
- Push notifications
- Habit tracking
- Goal setting
- Productivity streaks
- Cloud synchronization
- AI-generated daily schedules
- Cross-platform support
- Integrated timers and reminders for each task
---

## 🤝 Collaboration

Trackster was developed as a collaborative project.

- **Frontend:** Flutter Mobile Application
- **Backend:** Custom Spring Boot REST API
- **AI:** Google Gemini Integration

---

## ⭐ Support

If you found this project interesting, consider giving it a star on GitHub!

---

Made with ❤️ using Flutter, Gemini AI, and Spring Boot.
