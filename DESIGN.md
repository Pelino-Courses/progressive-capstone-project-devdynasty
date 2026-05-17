# CampusCart — Design Document

## Project Overview

**App Name:** CampusCart
**Team:** DevDynasty
**Platform:** Flutter (Mobile-first, runs on Web/Android/iOS)
**Design Tool Used:** Google Stitch (AI-powered UI design tool by Google)

CampusCart is a campus marketplace mobile app that enables university students in Rwanda to safely buy and sell items such as textbooks, clothes, electronics, and furniture within their campus community. The app addresses key problems identified during field research including price inconsistency, misleading product images, and disorganized WhatsApp-based selling.

---

## Design Approach

All mockups were generated using **Google Stitch**, following a consistent design language:
- **Design System:** Material Design 3
- **Primary Color:** Deep blue / green (to evoke trust and freshness)
- **Typography:** Clean, modern sans-serif
- **Style:** Friendly, professional, student-centric

### Why Google Stitch?
We used Google Stitch (an AI-powered UI design tool) because it allowed us to rapidly generate high-fidelity mobile mockups from descriptive prompts. This saved significant time compared to designing from scratch in Figma, while still producing consistent, production-quality visuals.

---

## Screen Mockups

### 1. Home Screen
**File:** `stitch-mockups/home_screen.png`

**Purpose:** Main entry point after login. Users can browse all products, search, and filter by category.

**Key UI Elements:**
- Top app bar with "CampusCart" branding and cart icon
- Search bar for product queries
- Horizontal category chips (Books, Clothing, Electronics, Furniture, Others)
- Scrollable list of product cards showing image, title, price, condition, seller, rating, and location
- Bottom navigation bar (Home, Search, My Listings, Profile)

**Friction Points Addressed:**
- Inefficient search → Search bar + category filters
- No centralized platform → Single feed of all listings

---

### 2. Product Details Screen
**File:** `stitch-mockups/product_details.png`

**Purpose:** Detailed view of a single product before a buyer commits to contacting the seller.

**Key UI Elements:**
- Back arrow and share icon
- Swipeable product image gallery with indicators
- Product title, price, and condition badge
- Description section
- Seller info card (profile picture, name, star rating, sales count)
- Location and posted date
- "Chat Seller" and "Make Offer" action buttons

**Friction Points Addressed:**
- Price inconsistency → Fixed price shown prominently
- No product verification → Seller rating and sales history visible

---

### 3. Add Listing Form
**File:** `stitch-mockups/add_listing.png`

**Purpose:** Sellers post new products for sale with all necessary details.

**Key UI Elements:**
- Close (X) icon, "New Listing" title, "Post" button on app bar
- Photo upload area (up to 5 images)
- Form fields: Product Title, Category (dropdown), Price (RWF), Condition (dropdown), Description, Location
- Primary "Post Listing" button at the bottom

**Friction Points Addressed:**
- Misleading images → Photo upload required, encourages real photos
- Price inconsistency → Fixed price field with no post-edit inflation

---

### 4. Login Screen
**File:** `stitch-mockups/login.png`

**Purpose:** User authentication entry point for returning users.

**Key UI Elements:**
- CampusCart logo and tagline ("Buy & Sell on Campus")
- Welcome heading and subtitle
- Email and password fields with icons
- Forgot Password link
- Sign In primary button
- "Or" divider
- Continue with Google button
- Sign Up link at the bottom

**Friction Points Addressed:**
- User trust → Student email verification ensures authentic campus users

---

### 5. Profile / My Listings Screen
**File:** `stitch-mockups/profile.png`

**Purpose:** User's personal dashboard to manage their own listings and profile.

**Key UI Elements:**
- App bar with "My Profile" title and settings icon
- Profile header: picture, name, university, rating, Verified Seller badge
- Stats row (Total Sales, Active Listings, Rating)
- Edit Profile button
- Tabs: My Listings / Sold Items
- List of user's products with status badges and edit/delete menu
- Floating action button (+) to add a new listing
- Bottom navigation bar

**Friction Points Addressed:**
- No product verification → Verified Seller badge and sales history build trust

---

## Design Decisions & Rationale

| Decision | Reason |
|----------|--------|
| Material Design 3 | Latest design system supported natively by Flutter; modern and accessible |
| Bottom navigation bar | Industry-standard pattern for mobile; easy thumb reach |
| Card-based product display | Scannable, image-forward — important for a visual marketplace |
| RWF currency prefix | Localized for Rwandan students |
| Verified Seller badges | Addresses trust issues identified in field research |
| Rounded form fields | Modern feel; friendly to young student users |

---

## AI Tools Disclosure

As required by the assignment:

| Tool | Purpose |
|------|---------|
| **Google Stitch** | Generated all 5 screen mockups from text prompts |
| **Claude (Anthropic AI)** | Assisted with document structuring, prompt refinement for Stitch, and feature planning |

All prompts fed to Stitch were written and reviewed by team members to ensure designs reflected our genuine app concept and the friction points discovered during field research.

---

## Next Steps

With the designs approved, the team will now proceed to implementation:
- **Part A:** Dart fundamentals demonstration
- **Part B:** OOP classes, inheritance, mixins, async/await
- **Part C:** Flutter widgets and UI implementation based on these mockups
- **Part D:** Navigation and forms with validation