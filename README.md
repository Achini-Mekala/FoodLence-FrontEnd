# FoodLence - AI-Based Food Label Scanner

FoodLence is an offline-first mobile application combining Optical Character Recognition (OCR) and Artificial Intelligence to scan physical food ingredient labels, identify potential allergens and chemical additives, and deliver instant, personalized dietary safety reports.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [New Member Onboarding & Getting Started](#new-member-onboarding--getting-started)
  - [1. Prerequisites](#1-prerequisites)
  - [2. Clone the Repository](#2-clone-the-repository)
  - [3. Pre-Development Health Checks (Run Before Coding!)](#3-pre-development-health-checks-run-before-coding)
  - [4. Backend API Connectivity & Setup](#4-backend-api-connectivity--setup)
  - [5. Running the Application](#5-running-the-application)
- [Team Details & Module Ownership](#team-details--module-ownership)
- [Supervision & Mentorship](#supervision--mentorship)
- [Development Workflow & Git Guidelines](#development-workflow--git-guidelines)
  - [Branching Protocol](#branching-protocol)
  - [Pre-Commit & Testing Checklist](#pre-commit--testing-checklist)
  - [Pull Request (PR) Submission](#pull-request-pr-submission)
- [Testing & Quality Assurance](#testing--quality-assurance)
- [Disclaimer](#disclaimer)

---

## Project Overview

Reading modern packaged food labels is challenging due to scientific nomenclature, alternative names, and chemical codes (such as E-numbers and INS numbers). Standard barcode scanning applications rely on centralized international databases that frequently lack coverage for local, regional, or unlisted bakery products.

FoodLence solves this problem by directly analyzing the printed text on packaging using on-device OCR, processing ingredient relationships with Natural Language Processing (NLP), and cross-referencing findings against personalized user health profiles.

---

## Key Features

* **Direct Label OCR Scanning**: Extracts ingredient text directly from physical packaging using Google ML Kit and Tesseract OCR without requiring barcodes.
* **Semantic AI Understanding**: Understands ingredient synonyms, scientific terms, and E/INS codes (e.g., mapping whey, casein, and E322 to their respective allergen categories).
* **Personal & Family Multi-Profile Checking**: Enables users to configure multiple dietary profiles and evaluate product safety across family members from a single scan.
* **Additive & Chemical Education**: Identifies preservatives, artificial colors, emulsifiers, stabilizers, and sweeteners with plain-language explanations.
* **Side-by-Side Product Comparison**: Compare two scanned food items side-by-side to determine which product contains fewer additives or allergens.
* **Offline-First Functionality**: On-device OCR processing and a curated SQLite knowledge base ensure core functionality works in low-connectivity retail environments.
* **Confidence Scoring & Verification**: Transparently rates extraction and matching certainty to alert users when label conditions require manual verification.
* **Manual Ingredient Search & Education**: Allows users to search ingredients manually to view detailed descriptions, purposes, and allergen affiliations.

---

## System Architecture

FoodLence follows a modular, layered architecture designed for local on-device execution with optional cloud synchronization:

1. Camera & Image Preprocessor (Grayscale, Contrast Adjustment, Noise Filtering)
2. On-Device OCR Engine (Google ML Kit / Tesseract OCR)
3. Text Cleaning & Regex Parsing (Isolates ingredients from packaging text)
4. AI / NLP Matching Engine (spaCy, scikit-learn, RapidFuzz) <-> Embedded SQLite Knowledge Base
5. Allergen Detection Engine <-> User Profiles Database
6. Result Display Dashboard (Color-coded Safe / Caution / Warning Alerts)
7. Local Scan History Archive (SQLite)

---

## Tech Stack

### Mobile Client
* Framework: Flutter (Dart)
* Local Database: SQLite (sqflite)
* State Management: Provider / Riverpod
* OCR Engines: Google ML Kit Flutter Plugin & Tesseract OCR
* UI Design: Flutter Material Design Widgets

### Backend & AI Processing
* Backend Framework: Python FastAPI
* NLP & AI Libraries: spaCy, scikit-learn, RapidFuzz / FuzzyWuzzy
* Cloud Database: PostgreSQL
* Authentication: JWT (JSON Web Tokens) with bcrypt password hashing
* DevOps & Containerization: Docker, Docker Compose, GitHub Actions
* Cloud Hosting: Render / Railway

## Repository Structure

```text
ai-food-label-scanner/
├── mobile/                  # Flutter application source code
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── services/        # OCR, SQLite, and API services
│   │   ├── views/           # Screens and UI widgets
│   │   └── main.dart        # Application entry point
│   ├── assets/              # Icons, seed database
│   └── pubspec.yaml
├── backend/                 # Python FastAPI backend & AI engine
│   ├── app/
│   │   ├── api/             # REST API endpoints
│   │   ├── core/            # Security and authentication
│   │   ├── nlp/             # AI models and matching logic
│   │   └── models/          # Database schemas
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── requirements.txt
├── docs/                    # Architecture diagrams, wireframes, reports
├── .gitignore
└── README.md
```

## New Member Onboarding & Getting Started

Welcome to the **FoodLence** engineering team! Follow this step-by-step checklist to set up your local development environment, verify baseline code health, and connect to the backend before writing any code.

---

### 1. Prerequisites
Ensure you have the following installed on your development machine:
* **Flutter SDK**: `^3.19.0` or higher (Matching Dart SDK `^3.9.2`).
* **Android Studio / Command-line Tools**: For Android SDK, platform tools, and emulator management.
* **VS Code** (Recommended) or **Android Studio** with the following extensions:
  * Flutter (`Dart-Code.flutter`)
  * Dart (`Dart-Code.dart`)
* **Git**: Installed and configured with your name and GitHub email (`git config --global user.name "Your Name"`).
* **Target Device**: Either a configured Android Virtual Device (AVD Emulator) or a physical Android smartphone with **USB Debugging** enabled.
* **Docker Desktop** (Optional, recommended for running local PostgreSQL & FastAPI backend).

Verify your environment readiness by running:
```bash
flutter doctor
```
*(All checks for Flutter, Android toolchain, and connected devices should pass or be resolved before proceeding).*

---

### 2. Clone the Repository
Clone the frontend repository to your local workspace:

```bash
# Clone the frontend repository
git clone https://github.com/GKR21/FoodLence-FrontEnd.git

# Navigate into the project folder
cd FoodLence-FrontEnd
```

*(Optional: If your assigned task requires full-stack testing with the backend engine, also clone the backend repository alongside in your workspace folder):*
```bash
git clone https://github.com/dilshandevxx/FoodLence-Backend.git
```

---

### 3. Pre-Development Health Checks (Run Before Coding!)

> [!IMPORTANT]
> **Always run these commands immediately after cloning or pulling the latest changes from `main`**, and before writing any new code:

#### Step 3.1: Clean Cache & Fetch Dependencies
```bash
flutter clean
flutter pub get
```

#### Step 3.2: Run Static Code Analysis (Zero Warnings Policy)
Ensure the repository currently compiles and complies with linter rules without any warnings or errors:
```bash
flutter analyze
```
*Expected result: `No issues found!`*

#### Step 3.3: Run Automated Widget & Unit Tests
Verify that all existing tests pass on your machine:
```bash
flutter test
```
*Expected result: `All tests passed!`*

#### Step 3.4: Auto-Format Dart Code
Keep code compliant with Dart's official style guide:
```bash
dart format .
```

---

### 4. Backend API Connectivity & Setup

The FoodLence frontend integrates with a Python FastAPI backend (Port `8000`). If your feature interacts with API endpoints or backend diagnostics:

#### Understanding IP Addresses Across Devices:
| Testing Device | Backend API Base URL | Why? |
| :--- | :--- | :--- |
| **Android Emulator** | `http://10.0.2.2:8000` | The Android emulator runs in its own virtual network. `10.0.2.2` bridges directly to your development PC's `localhost`. |
| **Physical Phone (USB/Wi-Fi)** | `http://<YOUR_PC_IP>:8000` | Use your computer's local Wi-Fi IPv4 address (e.g. `http://192.168.1.50:8000`). Phone and PC must be on the same Wi-Fi. |
| **Windows Desktop / Chrome Web** | `http://localhost:8000` | Direct local machine loopback. |

#### Starting the Local Backend:
* **Option A: Using Docker (Fastest)**
  ```bash
  cd ../FoodLence-BackEnd
  docker-compose up -d
  ```
* **Option B: Using Python Virtual Environment**
  ```bash
  cd ../FoodLence-BackEnd
  python -m venv venv
  # Activate virtual environment:
  .\venv\Scripts\activate      # On Windows
  source venv/bin/activate       # On Mac/Linux

  pip install -r requirements.txt
  uvicorn app.main:app --reload
  ```
* Confirm backend is running: Open `http://localhost:8000/docs` in your browser, or verify on the mobile app's **Backend** tab ([BackendStatusScreen](lib/main.dart)).

---

### 5. Running the Application

1. Check your connected devices:
   ```bash
   flutter devices
   ```
2. Start the app on your selected emulator or physical device:
   ```bash
   flutter run
   ```
3. Test initial navigation across the bottom navigation bar:
   * **Scanner**: Live OCR extraction simulation.
   * **Compare**: Product comparison view.
   * **Profiles**: User and household allergy profiles.
   * **Backend**: Real-time service connectivity diagnostics.

---

## Team Details & Module Ownership

| Name | Index / Reg No | Role & Module Ownership |
| :--- | :--- | :--- |
| **H.G.B.A Mekala** | `22CSE0361` | **Mobile & UI Lead**: Mobile App UI, Scanner Interface, Analysis Dashboard, Scan History, Favorites |
| **H.G.K Rashmika** | `21CSE0190` | **AI & Semantic Engine Lead**: AI Engine, Semantic Matching, Ingredient Classification, AI Explanations, Confidence Scoring |
| **S.K.P.H. Deemantha** | `22CSE0348` | **Knowledge Base & Detection Lead**: Knowledge Base Schema, Allergen/Additive Detection, E-Number Mapping, Product Comparison |
| **P.A.A. Ishara Dilshan** | `22CSE0360` | **Platform, OCR & Profile Lead**: User & Family Profiles, Personalized Warning Engine, OCR Pipeline, Multilingual Support, Dockerized Services |

---

## Supervision & Mentorship

* Academic Institution: Department of Software Engineering, Faculty of Computing, Sabaragamuwa University of Sri Lanka
* Course Unit: SE5104 Mini Project
* Internal Supervisor: Ms. B.R. Madhurangi (Lecturer)
* Industry Mentor: Mr. G.A.C.G. Dhanawardhana (Associate Software Engineer, Surecore (Pvt) Ltd)

---

## Development Workflow & Git Guidelines

This project strictly adheres to the **GitHub Flow** branching model. Every team member must follow these rules:

> [!CAUTION]
> **Direct pushes to `main` are strictly prohibited!** Any change must go through a dedicated feature branch and Pull Request (PR).

### Branching Protocol

1. **Sync with Remote Main**:
   Always branch off an up-to-date `main`:
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create Your Feature Branch**:
   Name your branch descriptively using your name or index and module task:
   `feature/<name>-<feature-description>` or `fix/<name>-<issue>`
   ```bash
   # Examples based on module ownership:
   git checkout -b feature/mekala-scanner-camera-feed
   git checkout -b feature/rashmika-ai-confidence-badge
   git checkout -b feature/deemantha-comparison-ui
   git checkout -b feature/dilshan-allergy-profile-editor
   ```

### Pre-Commit & Testing Checklist

Before committing any code, you **MUST** run:
```bash
# 1. Format all modified files
dart format .

# 2. Verify static analysis has 0 warnings
flutter analyze

# 3. Ensure all tests still pass
flutter test
```
Do **not** commit code that fails `flutter analyze` or breaks existing test suites.

### Pull Request (PR) Submission

1. **Commit with Conventional Messages**:
   Make small, readable, and individually identifiable commits:
   ```bash
   git add .
   git commit -m "feat(scanner): implement camera preview widget with overlay guidelines"
   ```

2. **Push Branch to Origin**:
   ```bash
   git push -u origin feature/<your-branch-name>
   ```

3. **Open a GitHub Pull Request**:
   * Navigate to the [FoodLence-FrontEnd Pull Requests](https://github.com/GKR21/FoodLence-FrontEnd/pulls) tab on GitHub.
   * Open a PR targeting `main`.
   * Add a clear summary of changes, linked issues, and screenshots/recordings for UI updates.
   * Request review from the relevant module lead before merging.

---

## Testing & Quality Assurance

* **Unit Testing**: Dart unit/widget tests for the mobile app and pytest for Python backend modules.
* **OCR Testing**: Accuracy benchmarked across 100 real packaging samples (target: >= 85% clear, >= 70% curved/reflective).
* **AI Matching Evaluation**: Precision, recall, and F1 score measured against a 200-ingredient test dataset.
* **User Acceptance Testing (UAT)**: Validated with real volunteers managing dietary restrictions.

---

## Disclaimer

FoodLence is designed as an informational decision-support tool and is not a certified medical diagnostic device. OCR accuracy and automated ingredient mappings may vary based on label packaging and lighting conditions. Users should always inspect physical packaging directly and consult qualified healthcare professionals for medical dietary advice.
