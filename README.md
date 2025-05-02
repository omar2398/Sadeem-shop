# Sadeem Shop - E-commerce Mobile Application

An e-commerce mobile application built with Flutter, developed as part of **Phase 2 tasks** of the **Sadeem Tech** in our internship program.

📄 **[Project Overview](https://drive.google.com/file/d/1g_WX4suP4ZxxrxmahoJSv78DpnGDCdCL/view?usp=sharing)**

## Features

* User authentication
* Product browsing and search
* Shopping cart functionality
* Wishlist/favorites system
* User profile management

## Project Structure

```
lib/
├── Config/
│   └── themes/          # App theme configurations
├── core/
│   ├── di/              # Dependency injection setup
│   ├── error/           # Error handling
│   ├── services/        # Core services
│   ├── usecases/        # Business logic
│   └── widgets/         # Reusable widgets
├── features/
│   ├── auth/            # Authentication
│   ├── cart/            # Shopping cart
│   ├── favorites/       # Wishlist
│   ├── home/            # Home screen
│   ├── products/        # Product listings
│   ├── profile/         # User profile
│   └── Onboarding/      #Onboarding page
└── main.dart            # App entry point
```

## API

This application uses mock data from the public API documentation provided by [dummyjson.com](https://dummyjson.com/).

## Packages Used

* **State Management:** `flutter_bloc`
* **Dependency Injection:** `get_it`
* **Networking:** `dio`
* **Local Storage:** `shared_preferences`, `flutter_secure_storage`
* **UI:** `carousel_slider`, `hugeicons`, `cached_network_image`
* **Utilities:** `dartz`, `equatable`, `infinite_scroll_pagination`

## Getting Started

### Prerequisites

* Flutter SDK (version 3.6.1 or higher)
* Dart SDK
* Android Studio/Xcode (for mobile builds)

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

