# App Concept Document: CampusCart

## Team Information
- **Team Name:** DevDynasty
- **App Name:** CampusCart
- **Members:** [Your Full Name], [Teammate Full Name]
- **Date:** March 26, 2026

---

## Problem Statement

Students at [Your University Name] face significant challenges when buying and selling items on campus due to the lack of a centralized, trustworthy marketplace platform. Current methods using WhatsApp and Instagram lead to price inconsistency, misleading product representations, no product verification, and inefficient search capabilities.

---

## Target Users

| User Type | Description |
|-----------|-------------|
| Primary | University/college students (Year 1-4) |
| Secondary | Campus staff, recent graduates, local vendors serving students |

### Key Use Cases
- Students selling used textbooks at end of semester
- Students buying affordable furniture and household items
- Students buying/selling clothes, shoes, and electronics
- Students searching for specific items without scrolling through WhatsApp
- Students seeking verified sellers to avoid scams and fake images

---

## Core Value Proposition

> "CampusCart is a trusted, centralized mobile marketplace that connects students within their campus community, eliminating price baiting, fake images, and disorganized WhatsApp selling by providing verified listings, transparent pricing, and easy search functionality."

---

## MVP Features & Problem-Solution Fit

| # | Feature | Description | Problem Addressed |
|---|---------|-------------|-------------------|
| 1 | **Product Listing with Fixed Price** | Sellers set a fixed price; buyers can make offers. Original listed price remains visible and cannot be changed after posting. | Price inconsistency (Friction #1) |
| 2 | **Search & Categories** | Students can search by keyword or browse categories (Books, Electronics, Clothing, Furniture) | No centralized platform (Friction #2), Inefficient search (Friction #5) |
| 3 | **Image Upload with Verification** | Sellers must upload real photos taken in-app or from gallery. System flags potential stock/fake images. | Misleading product images (Friction #3) |
| 4 | **User Ratings & Reviews** | Buyers rate sellers after each transaction. High-rated users earn trust badges. | No product verification (Friction #4) |
| 5 | **In-App Chat** | Built-in messaging for negotiation and delivery coordination, replacing WhatsApp communication. | Disorganized communication (Friction #2) |

---

## Constraint Integration Plan

| Constraint | How CampusCart Addresses It |
|------------|---------------------------|
| **Limited Technical Infrastructure** | App will work offline for browsing cached listings; lightweight design optimized for slower campus networks. |
| **User Trust & Safety** | Rating system, verified listings, and in-app chat keep all transactions traceable and accountable. |
| **Resource Constraints (Time/Budget)** | MVP focuses on 5 core features only; additional features (payments, delivery tracking) planned for future iterations. |
| **User Adoption** | Simple, familiar UI; referral system encourages students to invite campus friends. |

---

## User Flow Diagram

ONBOARDING
↓

SIGN UP / LOGIN
(Student email verification)
↓

HOME SCREEN
├── Search Bar
├── Categories Row (Books, Electronics, Clothing, Furniture)
└── Recent Listings Feed
↓

PRODUCT DETAILS
├── View Images
├── Fixed Price + Make Offer Button
├── Seller Rating
└── Chat Seller Button
↓

IN-APP CHAT
├── Negotiate Price
├── Ask Questions
└── Coordinate Delivery
↓

AFTER TRANSACTION
└── Rate Buyer/Seller

## Wireframes

Wireframe images are available in the `wireframes/` folder:

| Screen | File |
|--------|------|
| Onboarding/Welcome | wireframes/screen1_onboarding.jpg |
| Home Screen | wireframes/screen2_home.jpg |
| Product Details | wireframes/screen3_product_details.jpg |
| Add Listing | wireframes/screen4_add_listing.jpg |
| Chat Screen | wireframes/screen5_chat.jpg |

---

## Future Enhancements (Post-MVP)

| Feature | Description |
|---------|-------------|
| Push Notifications | Alert users when someone messages or makes an offer |
| Payment Integration | In-app payments for seamless transactions |
| Delivery Tracking | Track delivery status from seller to buyer |
| Verified Campus ID | Verify users are actual students |
| Saved Searches | Save searches and get alerts when new items match |

---

## AI Tools Used

AI tools (ChatGPT) were used to:
- Structure and format app concept documentation
- Brainstorm feature ideas aligned with research findings
- Create wireframe descriptions and user flow

All app concept ideas, features, and problem-solution mappings are original and based on the team's field research.