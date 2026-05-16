# Project Aether

Project Aether is a realtime multiplayer Flutter application built with Clean Architecture and Riverpod.  
The project simulates raid battles, world boss events, and realtime player communication using Firebase.

---

# Features

## World Boss Timer
- Live countdown timer for world boss events
- Realtime synchronization
- Dynamic UI updates

## Raid System
- Multiplayer raid join system
- Maximum of 15 players per raid
- Concurrency-safe join handling
- Prevents duplicate or overflow joins during simultaneous requests

## Realtime Chat
- Live player messaging
- Realtime updates using Firebase
- Optimized message fetching

---

# Architecture

The project follows:

- Clean Architecture
- Riverpod State Management
- Service Layer Pattern
- Feature-based folder structure

---

# Technologies Used

- Flutter
- Dart
- Firebase Firestore
- Riverpod

---

# Concurrency Strategy

The raid system uses atomic transaction logic to ensure that no more than 15 players can join the same raid simultaneously.

### Protection Methods
- Firestore transactions
- Server-side validation
- Atomic updates
- Safe concurrent request handling

This prevents race conditions and guarantees raid integrity under heavy load.

---

# Firebase Cost Optimization

To reduce Firebase read costs, the project uses:

- Query limits
- Pagination
- Lazy loading
- Fetching latest messages only
- Optimized realtime listeners
- Reduced unnecessary document reads

---

# Project Structure

```text
lib/
 ├── features/
 │    ├── boss/
 │    ├── raid/
 │    ├── chat/
 │
 ├── main.dart
```

---

# Getting Started

## Install Dependencies

```bash
flutter pub get
```

## Run The Application

```bash
flutter run
```

## Run Tests

```bash
flutter test
```

---

# Notes

- Includes concurrency testing for raid validation
- Built for scalability and realtime responsiveness
- Follows production-style architecture principles
