# CampusCart — Campus Marketplace App

> Mini-Capstone Assignment One — Parts A through D
> **Team:** DevDynasty
> **Module:** Mobile Application Development (MAD)
> **Submission Tag:** `mini-capstone-part-a-d`

---

## 📱 About

**CampusCart** is a Flutter-based mobile marketplace app designed for university students in Rwanda. It enables students to safely buy and sell items like textbooks, clothes, electronics, and furniture within their campus community.

The app addresses real friction points identified during field research:
- Price inconsistency on WhatsApp listings
- Misleading stock/AI-generated product photos
- Lack of seller verification
- Disorganized, inefficient search on existing channels

---

## 👥 Team: DevDynasty

| Role | Member |
|------|--------|
| Developer / Research | [Saidu KUBWIMANA] |
| Developer / Research | [Crescent ISHIMWE] |

---

## 🎯 Assignment Coverage

| Part | Requirement | Location |
|------|-------------|----------|
| **Part A** | Dart fundamentals — variables, null safety, collections, functions | `campuscart/lib/dart_basics/` |
| **Part B** | OOP & data models — classes, inheritance, mixins, async/await | `campuscart/lib/models/` & `campuscart/lib/services/` |
| **Part C** | Flutter widgets & UI — layouts, custom widgets, Material Design 3 theme | `campuscart/lib/theme/`, `campuscart/lib/widgets/`, `campuscart/lib/screens/home_screen.dart` |
| **Part D** | Navigation & forms — named routes, data passing, form validation | `campuscart/lib/main.dart` + `campuscart/lib/screens/` |
| **Design** | 3-5 Google Stitch mockups + DESIGN.md | `stitch-mockups/` & `DESIGN.md` |

---

## 📂 Repository Structure
progressive-capstone-project-devdynasty/
├── campuscart/                      # Flutter project
│   ├── lib/
│   │   ├── dart_basics/             # Part A - Dart fundamentals demos
│   │   │   ├── variables_demo.dart
│   │   │   ├── collections_demo.dart
│   │   │   └── functions_demo.dart
│   │   ├── models/                  # Part B - Classes, inheritance, mixins
│   │   │   ├── user.dart
│   │   │   ├── seller.dart
│   │   │   ├── buyer.dart
│   │   │   ├── rateable.dart
│   │   │   ├── timestamped.dart
│   │   │   └── product.dart
│   │   ├── services/                # Part B - Async/await
│   │   │   └── product_service.dart
│   │   ├── theme/                   # Part C - Material Design 3 theme
│   │   │   └── app_theme.dart
│   │   ├── widgets/                 # Part C - Custom reusable widgets
│   │   │   ├── product_card.dart
│   │   │   └── category_chip.dart
│   │   ├── screens/                 # Parts C & D - UI screens
│   │   │   ├── home_screen.dart
│   │   │   ├── product_details_screen.dart
│   │   │   └── add_listing_screen.dart
│   │   ├── part_b_demo.dart         # Part B integrated demo
│   │   └── main.dart                # App entry point + named routes
│   └── pubspec.yaml
├── docs/                            # Previous phase documentation
│   ├── field_research.md
│   ├── app_concept.md
│   └── team_charter.md
├── stitch-mockups/                  # Google Stitch mockups
│   ├── home_screen.png
│   ├── product_details.png
│   ├── add_listing.png
│   ├── login.png
│   └── profile.png
├── wireframes/                      # Earlier wireframes
├── DESIGN.md                        # Design document
└── README.md

---

## 🚀 Running the App

### Prerequisites
- Flutter SDK installed (3.x)
- Chrome browser (for web demo)
- VS Code or Android Studio

### Steps
```bash
# Clone the repo
git clone <repo-url>
cd progressive-capstone-project-devdynasty/campuscart

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome
```

### Running individual Part A demos
```bash
dart run lib/dart_basics/variables_demo.dart
dart run lib/dart_basics/collections_demo.dart
dart run lib/dart_basics/functions_demo.dart
```

### Running Part B integrated demo
```bash
dart run lib/part_b_demo.dart
```

---

## 🎥 Demo Video

📺 **YouTube:** [Link will be added here after recording]

---

## 🧠 Key Concepts Demonstrated

### Part A — Dart Fundamentals
- Type-safe variables (`String`, `int`, `double`, `bool`)
- Null safety operators (`?`, `!`, `??`, `??=`, `?.`)
- Collections: `List`, `Map`, `Set`
- Functions: arrow, named parameters, optional params, higher-order

### Part B — OOP & Data Models
- Base class `User` with `Seller` and `Buyer` extending it (inheritance)
- `Rateable` and `Timestamped` mixins for shared behavior
- `Product` class combining both mixins (`with Rateable, Timestamped`)
- `ProductService` with `async`/`await` to simulate network calls

### Part C — Flutter UI
- Material Design 3 theme (seeded color scheme)
- Custom reusable widgets (`ProductCard`, `CategoryChip`)
- `StatefulWidget` for dynamic state (search, filter, loading)
- Responsive layouts with `Column`, `Row`, `ListView`, `Expanded`

### Part D — Navigation & Forms
- Named routes declared in `MaterialApp.routes`
- Data passing via `Navigator.pushNamed(..., arguments: ...)`
- Returning results via `Navigator.pop(context, true)`
- Form validation with `GlobalKey<FormState>` and field validators
- Live validation with `AutovalidateMode.onUserInteraction`

---

## 🤖 AI Tools Disclosure

As required by the assignment guidelines:

| Tool | Purpose |
|------|---------|
| **Google Stitch** | Generated all 5 screen mockups from text prompts |
| **Claude (Anthropic)** | Assisted with code structure, documentation, and explanations |

All generated code was reviewed and understood by team members. All research (interviews, friction points, problem statement) is original and conducted by the team.

---

## 📝 License

This project is submitted as part of coursework for the MAD module. Not intended for commercial distribution.