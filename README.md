# FoodLence - AI-Based Food Label Scanner

FoodLence is an offline-first mobile application combining Optical Character Recognition (OCR) and Artificial Intelligence to scan physical food ingredient labels, identify potential allergens and chemical additives, and deliver instant, personalized dietary safety reports.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Mobile App Setup](#mobile-app-setup)
  - [Backend Setup](#backend-setup)
- [Team Details & Module Ownership](#team-details--module-ownership)
- [Supervision & Mentorship](#supervision--mentorship)
- [Development Workflow & Git Guidelines](#development-workflow--git-guidelines)
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

## Getting Started

### Prerequisites
* Flutter SDK (v3.19+)
* Python (v3.10+)
* Android Studio or VS Code
* Git
* Docker Desktop (Optional)

### Mobile App Setup
1. Open terminal and navigate to the mobile folder: `cd mobile`
2. Get packages: `flutter pub get`
3. Run app: `flutter run`

### Backend Setup
1. Navigate to backend: `cd backend`
2. Create virtual environment: `python -m venv venv`
3. Activate environment:
   * Windows: `venv\Scripts\activate`
   * Mac/Linux: `source venv/bin/activate`
4. Install packages: `pip install -r requirements.txt`
5. Run server: `uvicorn app.main:app --reload`
6. View Swagger API Docs: `http://127.0.0.1:8000/docs`

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

This project strictly adheres to the GitHub Flow branching model:
* The `main` branch contains verified, production-ready code.
* All feature additions and bug fixes occur in dedicated branches (`feature/<name>` or `fix/<name>`).
* Direct pushes to `main` are restricted; code is merged via Pull Requests (PRs) requiring review approval.
* All team members must make regular, descriptive, and individually identifiable commits.

---

## Testing & Quality Assurance

* **Unit Testing**: Dart unit/widget tests for the mobile app and pytest for Python backend modules.
* **OCR Testing**: Accuracy benchmarked across 100 real packaging samples (target: >= 85% clear, >= 70% curved/reflective).
* **AI Matching Evaluation**: Precision, recall, and F1 score measured against a 200-ingredient test dataset.
* **User Acceptance Testing (UAT)**: Validated with real volunteers managing dietary restrictions.

---

## Disclaimer

FoodLence is designed as an informational decision-support tool and is not a certified medical diagnostic device. OCR accuracy and automated ingredient mappings may vary based on label packaging and lighting conditions. Users should always inspect physical packaging directly and consult qualified healthcare professionals for medical dietary advice.
