# FoodLence Mobile - AI-Based Food Label Scanner (Frontend)

This repository contains the **Flutter Android client** of FoodLence. The app scans a packaged-food ingredient label with the phone camera, extracts the text on-device with Google ML Kit, and sends it to the FoodLence cloud backend, which identifies the ingredients, maps them to allergens and additives, and returns a personalised, colour-coded safety result.

> Backend, ML model and database live in a separate repository: **[foodlence-backend](https://github.com/<org>/foodlence-backend)** (replace with the real link).

---

## Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [How the App Works](#how-the-app-works)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Backend API Used by the App](#backend-api-used-by-the-app)
- [Team and Module Ownership](#team-and-module-ownership)
- [Supervision and Mentorship](#supervision-and-mentorship)
- [Development Workflow and Git Guidelines](#development-workflow-and-git-guidelines)
- [Testing and Quality Assurance](#testing-and-quality-assurance)
- [Disclaimer](#disclaimer)

---

## Project Overview

Packaged food labels are hard to read: scientific names, alternative terms and codes such as E-numbers hide allergens (for example, casein, whey and E322). Barcode apps only work for products already in their database, which excludes many local Sri Lankan and unlisted products.

FoodLence reads the **printed label itself**, so it works for any product. This repository is the mobile client in a **thin-client, thick-server** design:

- The app handles the camera, image preprocessing, on-device OCR and the user interface.
- The backend handles NLP classification, the allergen and additive knowledge base, profile evaluation and scan logging.
- The app holds **no allergen or food-chemistry knowledge**, so the model and database can improve without an app update.

An active internet connection is required for analysis. Offline AI processing is out of scope.

---

## Key Features

* **Label scanner:** camera screen with focus guide, flash toggle and capture/retake.
* **On-device OCR:** Google ML Kit text recognition after grayscale, contrast and noise preprocessing.
* **Colour-coded results:** SAFE (green), CAUTION (yellow) and UNSAFE (red) banner with a per-ingredient breakdown.
* **Additive education:** tap an ingredient card to read a plain-language explanation of additives, preservatives and E-numbers.
* **Multi-profile support:** up to five dietary profiles per account. Switch profile and re-evaluate the same scan without scanning again.
* **Low-confidence warning:** when the model is unsure (below 75% confidence), the app asks the user to check the physical label.
* **Scan history:** past results stored on the server and cached on the device for quick reference.
* **Manual text search fallback:** type or paste ingredient text if scanning fails.
* **Onboarding and medical disclaimer:** shown before first use and must be accepted.
* **Safe failure handling:** loading, timeout and no-internet states, so the app never crashes when the network drops.

---

## How the App Works

```
Camera capture
   -> Image preprocessing (grayscale, contrast, noise reduction)
   -> Google ML Kit OCR (raw text, on-device)
   -> POST /api/v1/analyze  { ocr_text, profile_id }   (HTTPS, JWT)
   -> Backend: segment -> classify -> allergen engine -> evaluate vs profile
   <- JSON safety report
   -> Result dashboard (SAFE / CAUTION / UNSAFE, ingredient cards, confidence)
   -> Saved to scan history
```

The OCR text stays on the device after a scan, so switching profiles only sends the same text again with a different `profile_id`.

---

## Tech Stack

| Area | Technology |
| :--- | :--- |
| Framework | Flutter (Dart), Android 8.0+ |
| OCR | `google_mlkit_text_recognition` |
| Camera | `camera` plugin |
| Image preprocessing | `image` package |
| Networking | `dio` (REST/JSON over HTTPS) |
| State management | Riverpod (or Provider; keep one across the app) |
| Auth storage | `flutter_secure_storage` (JWT access and refresh tokens) |
| Local cache | `sqflite` (scan history cache) / `shared_preferences` (settings) |
| Design | Figma, Flutter Material widgets |
| CI | GitHub Actions (`flutter analyze`, `flutter test`) |

> These are the intended defaults. Adjust the list if the team picks different packages.

---

## Repository Structure

```text
foodlence-mobile/
├── lib/
│   ├── core/                # Theme, constants, routing, error handling
│   ├── models/              # Data models (AnalysisResult, Profile, ScanRecord)
│   ├── services/
│   │   ├── ocr_service.dart       # ML Kit text recognition
│   │   ├── image_preprocessor.dart
│   │   ├── api_client.dart        # Dio client, JWT interceptor, mock switch
│   │   └── history_cache.dart     # Local scan history
│   ├── features/
│   │   ├── onboarding/      # Welcome and medical disclaimer
│   │   ├── auth/            # Login and register
│   │   ├── scanner/         # Camera and capture
│   │   ├── results/         # Colour-coded dashboard, ingredient cards
│   │   ├── profiles/        # Profile list, editor, switcher
│   │   ├── history/         # Scan history
│   │   └── search/          # Manual text search fallback
│   ├── widgets/             # Shared UI components
│   └── main.dart
├── assets/                  # Icons, images, fonts
├── test/                    # Unit and widget tests
├── integration_test/        # End-to-end tests against the API contract
├── docs/                    # Wireframes, Figma exports, screenshots
├── pubspec.yaml
└── README.md
```

---

## Getting Started

### Prerequisites
* Flutter SDK (3.19 or newer) and Dart
* Android Studio (emulator and SDK) or VS Code with the Flutter extension
* Git
* An Android phone (8.0+) with a rear camera of at least 8 MP, or an emulator. A real device is recommended for OCR testing.

### Setup
```bash
git clone https://github.com/<org>/foodlence-mobile.git
cd foodlence-mobile
flutter pub get
```

### Run against the mock API (no backend needed)
Used during early development, before the backend is deployed:
```bash
flutter run --dart-define=USE_MOCK_API=true
```

### Run against the backend
```bash
flutter run --dart-define=API_BASE_URL=https://<your-backend-url>/api/v1
```
For a locally running backend on an Android emulator, use `http://10.0.2.2:8000/api/v1`.

### Build a release APK
```bash
flutter build apk --release --dart-define=API_BASE_URL=https://<your-backend-url>/api/v1
```
The APK is created at `build/app/outputs/flutter-apk/app-release.apk`.

> Never commit secrets, keystores or `.env` files. Keep signing keys outside the repository.

---

## Backend API Used by the App

The full contract is maintained in the backend repository. The app uses:

| Method | Endpoint | Purpose |
| :--- | :--- | :--- |
| POST | `/auth/register`, `/auth/login`, `/auth/refresh` | Account and tokens |
| GET | `/profiles` | List the user's profiles |
| POST / PUT / DELETE | `/profiles`, `/profiles/{id}` | Manage profiles (max 5) |
| GET | `/allergens` | Allergen list for the profile editor |
| POST | `/analyze` | Send OCR text and `profile_id`, receive the safety report |
| GET | `/history` | Paginated scan history |
| GET | `/health` | Backend health check |

All requests use HTTPS (TLS 1.2+) and `Authorization: Bearer <token>` except the auth routes. The `overall_status` values are `SAFE`, `CAUTION` and `UNSAFE`.

---

## Team and Module Ownership

This repository is owned by the **Mobile and UI lead**. The other members contribute through the backend repository.

| Name | Index No | Role | Main modules |
| :--- | :--- | :--- | :--- |
| **H.G.B.A Mekala** | `22CSE0361` | **Mobile & UI Lead** (this repo) | Flutter app, scanner, OCR integration, results dashboard, profiles UI, history, APK |
| **H.G.K Rashmika** | `21CSE0190` | ML Dataset & Training Lead | Dataset, noise augmentation, NLP classifier |
| **S.K.P.H. Deemantha** | `22CSE0348` | Knowledge Base, Allergen Engine & QA Lead | Database, allergen engine, profile logic, testing, UAT |
| **P.A.A. Ishara Dilshan** | `22CSE0360` | Backend & Deployment Lead | FastAPI, authentication, deployment, load testing |

---

## Supervision and Mentorship

* Institution: Department of Software Engineering, Faculty of Computing, Sabaragamuwa University of Sri Lanka
* Course unit: SE5104 Mini Project (Group 14)
* Internal supervisor: Ms. B.R. Madhurangi (Lecturer)
* Industry mentor: Mr. G.A.C.G. Dhanawardhana (Software Engineer)

---

## Development Workflow and Git Guidelines

The project follows **GitHub Flow**:

* `main` always holds working, reviewable code. Do not push directly to it.
* Create a branch per Jira ticket, for example `feature/flutter-camera-scanner` or `fix/ocr-timeout-handling`.
* Commit often with clear messages that mention the Jira key, for example `FL-50: add flash toggle to camera screen`.
* Open a Pull Request into `main`. It needs **at least one approval** and passing CI (`flutter analyze` and `flutter test`).
* Every member commits from their own identifiable GitHub account throughout the project. A single bulk upload at the end is not accepted.
* Tasks are tracked in the team's Jira board (space key `FL`), organised into three two-week sprints.

---

## Testing and Quality Assurance

* **Unit and widget tests:** `flutter test` covers state management, profile switching and the preprocessing helpers.
* **Integration tests:** `flutter test integration_test` validates the app against the API contract, using the mock API first and the deployed backend later.
* **OCR accuracy:** measured on real packaging samples under different lighting. Target: at least 85% character accuracy on clear labels.
* **Performance:** the request-to-result time shown in the app should stay under 3 seconds on a 4G connection.
* **Static analysis:** `flutter analyze` must pass before merging.
* **User Acceptance Testing:** at least five volunteers (people with food allergies or parents managing them) test the app in real shopping conditions, with feedback collected through a questionnaire.

---

## Disclaimer

FoodLence is an informational decision-support tool and not a certified medical device. OCR and automated ingredient classification can make mistakes, and manufacturers may change recipes or have cross-contamination without updating the packaging. Always read the physical label, and consult a qualified healthcare professional for medical dietary advice. People with severe allergies should carry their prescribed emergency medication.
