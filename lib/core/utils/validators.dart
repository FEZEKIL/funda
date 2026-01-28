class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? validateAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your answer';
    }
    // Add more specific validation for math answers if needed
    return null;
  }

  static String? validateImagePath(String? path) {
    if (path == null || path.isEmpty) {
      return 'Please select an image';
    }
    return null;
  }
}
