class Secrets {
  // IMPORTANT: Add your Gemini API key to the .env file
  // Create a .env file in the project root with: GEMINI_API_KEY=your_actual_key_here
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );
}
