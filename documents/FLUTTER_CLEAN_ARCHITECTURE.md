# Flutter Clean Architecture Documentation

## 1. Overview

This document describes the architecture of a Flutter application built to work with a NestJS backend.
The application follows **Clean Architecture**, uses **Cubit** for state management, and applies modern Flutter best practices.

### Goals
- Scalable and maintainable architecture
- Clear separation of concerns
- Testable business logic
- Easy to extend and refactor

---

## 2. Tech Stack

| Category            | Library / Tool |
|---------------------|----------------|
| Language            | Dart |
| Architecture        | Clean Architecture |
| State Management    | flutter_bloc (Cubit) |
| Networking          | Dio + Retrofit |
| Dependency Injection | injectable + get_it |
| Immutable Models    | Freezed |
| Code Generation     | build_runner |
| Asset Management    | flutter_gen |
| Theme and Color     | flex_color_scheme |
| Size Management     | flutter_screenutil |

---

## 3. Clean Architecture Overview

The application is divided into **three main layers**:

Presentation  
Domain  
Data  

### Dependency Rule
- Presentation → Domain
- Data → Domain
- Domain depends on nothing

---

## 4. Project Folder Structure

lib/
├── core/
│   ├── error/
│   ├── network/
│   ├── usecase/
│   ├── utils/
│   └── constants/
│
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   └── local/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── presentation/
│   ├── cubit/
│   ├── pages/
│   └── widgets/
│
├── di/
│   └── injection.dart
│
├── app.dart
└── main.dart
