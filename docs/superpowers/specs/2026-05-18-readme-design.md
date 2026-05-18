# Design Spec: Project README.md

**Date**: 2026-05-18
**Topic**: Documentation for Installation and Testing

## 1. Purpose
Provide a clear, step-by-step guide for new developers to set up, run, and test the Waste2Taste Expo application.

## 2. Content Sections

### 2.1 Project Overview
- Name: Waste2Taste
- Goal: Minimize food waste through pantry management and recipe generation.
- Tech Stack: Expo, React Native, TypeScript.

### 2.2 Prerequisites
- Node.js (v20+)
- npm or pnpm
- Expo Go app (for mobile testing)

### 2.3 Step-by-Step Installation
1. `git clone https://github.com/will702/waste2taste.git`
2. `cd waste2taste`
3. `npm install`

### 2.4 Running the App
- Start Metro Bundler: `npx expo start`
- Android/iOS: Scan QR code with Expo Go.
- Web: Press `w` in the terminal.

### 2.5 Testing
- Type checking: `npm run typecheck`
- Mention that tests should be added to the `__tests__` or similar directory (standard practice).

### 2.6 Project Structure
- `app/`: Expo Router pages.
- `components/`: Reusable UI components.
- `context/`: Global state management.
- `data/`: Mock data and themes.
- `types/`: TypeScript definitions.

## 3. Visuals
- Use standard Markdown formatting.
- Include code blocks for commands.

## 4. Success Criteria
- A user can successfully run the app following the instructions.
- The `README.md` file exists in the root directory.
