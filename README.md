Collaborative Todo App with Chat Functionality

A Flutter-based mobile application that allows users to manage their tasks collaboratively and engage in real-time chat conversations. The app is built with Firebase for authentication, real-time database management, and notifications. It also supports offline functionality and background services to ensure seamless task management and communication.
Features

    Authentication: Users can sign up, log in, and manage their accounts.
    Collaborative Todo Lists: Create, update, and share todo lists with other users in real time.
    Chat Functionality: Users can chat with team members in real-time to discuss todos and collaborate on tasks.
    Push Notifications: Receive notifications for new messages, todos, and task updates.
    Background Sync: Automatically syncs todos and messages while in the background.
    Offline Mode: Users can work offline and their data will sync once they’re back online.

Project Structure

The project follows a Feature-First structure, where the codebase is organized by app features rather than by type (e.g., models, services). This structure keeps the project modular, scalable, and easy to maintain.
Folder Structure

bash

lib/
│
├── features/
│   ├── auth/
│   │   ├── data/                   # Firebase auth services
│   │   ├── presentation/           # UI for login, signup
│   │   └── domain/                 # User model
│   ├── todo/
│   │   ├── data/                   # Firebase todo services
│   │   ├── presentation/           # UI for todo list, detail views
│   │   └── domain/                 # Todo model
│   ├── chat/
│   │   ├── data/                   # Firebase chat services
│   │   ├── presentation/           # UI for chat list and chat room
│   │   └── domain/                 # Message model
│   ├── notifications/
│   │   └── services/               # Notification handling
│   ├── background/
│   │   └── services/               # Background sync services
│   └── common/                     # Shared utilities, widgets, constants
│       ├── utils/                  # Utility functions
│       ├── widgets/                # Shared UI components
│       └── constants/              # Theme, colors, etc.
│
├── main.dart                        # Entry point of the app

Key Features and Folders

    Authentication (auth): Handles user login, signup, and authentication using Firebase. The data/ folder contains the Firebase service for authentication, presentation/ contains UI screens, and domain/ includes the user model.

    Todo Management (todo): Manages CRUD operations for todos. Real-time synchronization is handled by Firebase. presentation/ holds the UI screens like todo lists and details, data/ contains the Firebase interactions, and domain/ defines the todo model.

    Chat Functionality (chat): Enables real-time chat between users, tied to their tasks. Similar structure to other features with data/ for services, presentation/ for UI, and domain/ for the chat message model.

    Notifications (notifications): Push notifications for chat messages, new tasks, and updates using Firebase Cloud Messaging (FCM). The services are placed under services/.

    Background Tasks (background): Handles background tasks like syncing messages or tasks. This feature ensures the app runs smooth even when minimized or closed.

    Common Utilities and Widgets (common): Shared utilities (e.g., date and time handling) and UI components (e.g., custom buttons) are stored here. This avoids code duplication across features.

Setup and Installation

To set up the project locally, follow these steps:

    Clone the repository:

    bash

git clone https://github.com/biruk-tafese/2f-capital.git
cd 2f-capital

Install dependencies:

bash

flutter pub get

Set up Firebase:

    Create a Firebase project.
    Download and add google-services.json for Android and GoogleService-Info.plist for iOS to the appropriate directories.
    Enable Firebase Authentication, Firestore, and Firebase Cloud Messaging (FCM).

Run the app:

For Android:

bash

flutter run

For iOS:

bash

    flutter run

Dependencies

This project uses the following main packages:

    Firebase: Firebase services for authentication, real-time database, and messaging.
    Image Picker: To allow users to select images from their gallery.
    Provider: For state management across different features.
    Flutter Local Notifications: To handle local notifications.
    WorkManager: For background processing (e.g., syncing tasks/messages in the background).

Add more dependencies as required in the pubspec.yaml.
Testing

Run unit tests and widget tests:

bash

flutter test

Contributing

Contributions are welcome! Please follow these steps to contribute:

    Fork the repository.
    Create a new branch for your feature or bugfix.
    Commit and push your changes.
    Create a pull request, describing what you’ve done.


