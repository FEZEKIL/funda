# TTS Fix TODO

## Completed
- [x] Updated Flutter audio_service.dart to call backend endpoint
- [x] Created backend TTS service (backend/src/services/tts.service.js)
- [x] Created backend TTS controller (backend/src/controllers/tts.controller.js)
- [x] Created backend TTS routes (backend/src/routes/tts.routes.js)
- [x] Updated backend config to include TTS API key
- [x] Moved axios to production dependencies

## Remaining Tasks
- [ ] Set TTS_API_KEY environment variable in backend/.env
- [ ] Enable Google Cloud Text-to-Speech API in Google Cloud Console
- [ ] Test TTS functionality by running backend and Flutter app
- [ ] Update backend URL in audio_service.dart if needed (currently localhost:5000)

## Notes
- The original error was caused by using Gemini API key for TTS API
- TTS functionality moved to backend for security (no API key exposure in client)
- Backend expects TTS_API_KEY environment variable
