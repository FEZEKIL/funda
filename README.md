# Funda - AI Math & Physics Tutor

An educational app that uses Google's Gemini API to analyze math and physics problems from images and provide step-by-step explanations.

## 🔐 Important: API Key Setup

**Before running the app, you need to set up your Gemini API key:**

1. Go to [Google AI Studio](https://aistudio.google.com/) and create an API key
2. Create a `.env` file in the project root with your API key:
   ```env
   GEMINI_API_KEY=your_actual_gemini_api_key_here
   ```
3. The `.env` file is already in `.gitignore` and will not be committed to GitHub

---

# AI Lab Assistant

AI Lab Assistant is a strong, judge-friendly choice that leverages Gemini 3's multimodal capabilities to help students understand science and math concepts through visual reasoning. With a deadline of 10 Feb 2026, we have time to build something polished — not rushed.

## 🌟 Project Concept

Students (or teachers) can:

- 📷 Take a photo of a lab setup, worksheet, graph, or math problem
- ✍️ Ask a question (optional)
- 🤖 Gemini:
  - Explains what the experiment/problem is about
  - Walks through the steps or reasoning
  - Checks answers
  - Highlights mistakes
  - Suggests improvements or safety notes (age-appropriate)

### Example demo

Take a picture of a beaker + thermometer →
Gemini explains how to measure temperature correctly, common mistakes, and calculates example results.

Take a photo of a math problem →
Gemini explains step-by-step, instead of just giving the answer.

This directly shows multimodal reasoning, which judges want.

## 🧠 Why Gemini 3 fits perfectly

- Image understanding (lab setups, handwritten notes)
- Deep reasoning (multi-step explanation)
- Low latency (feels like a helper, not a slow chatbot)
- Multimodal in / structured text out

We'll clearly show that Gemini is central, not optional.

## 🏗️ Core Features (MVP)

1️⃣ **Photo Understanding**
- Upload or take a photo
- Gemini identifies the experiment/problem

2️⃣ **Explain Like a Tutor**
- Step-by-step guidance, simple language
- Multiple explanation difficulty levels (Beginner / Advanced)

3️⃣ **Answer Checker**
- User inputs their answer → Gemini checks it
- Explains why it's correct or incorrect

4️⃣ **Hints Instead of Spoilers**
- "Try adjusting X" instead of immediately solving everything

5️⃣ **Lab Tips**
- Safety notes, common mistakes, measurement advice
(kept non-graphic and educational)

## 🛠️ Tech Stack

**Frontend:** Flutter (mobile)

**Backend:** Lightweight Node.js or Python server

**Gemini 3 API integration**

**Image handling:** Client camera upload → backend → Gemini

**Storage:** Firebase / Supabase (simple + fast)

## ✍️ Integration Description

AI Lab Assistant uses the Gemini 3 multimodal API to help students understand science and math concepts through visual reasoning. Users take a photo of a lab setup, worksheet, or math problem, and Gemini analyzes the image to identify key components such as equipment, measurements, graphs, symbols, and equations. The model then explains what the task is asking, outlines the correct procedure or reasoning steps, and provides guided hints instead of revealing full solutions immediately.

Gemini's advanced reasoning capabilities power the core experience. It interprets images, extracts relevant details, evaluates student answers, and produces structured explanations tailored to the learner's level. Low-latency responses make the interaction feel conversational, allowing students to ask follow-up questions or try alternative approaches.

The app also supports answer verification. Students enter their result, and Gemini evaluates accuracy, explains mistakes, and suggests how to improve. For lab scenarios, the system highlights common errors and safety reminders based on the detected setup.

AI Lab Assistant is not just a chat tool — the application depends on Gemini's multimodal understanding to transform photos into meaningful teaching moments. Without Gemini's reasoning and image analysis, the app would not function.

## 🎥 3-Minute Demo Video Plan

1️⃣ Intro (10 sec): "Take a photo — get a lesson."
2️⃣ Demo #1: Lab setup photo → explanation + safety hint
3️⃣ Demo #2: Math worksheet photo → step-by-step reasoning
4️⃣ Demo #3: Student enters answer → Gemini checks + explains
5️⃣ Close: "Built with Gemini 3 multimodal reasoning."

Short, clear, impressive.

## 🗓️ Roadmap to Feb 10, 2026

**Month 1** — Prototype
- Build camera upload + Gemini call
- Get image explanations working

**Month 2** — Core Features
- Answer checker
- Hint system
- UI polish

**Month 3** — Classroom Testing
- Collect example problems
- Improve prompts + responses
- Fix latency issues

**Month 4** — Submission Prep
- Public demo link
- GitHub repo cleanup
- Record final video
- Submit!

We'll iterate together.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
