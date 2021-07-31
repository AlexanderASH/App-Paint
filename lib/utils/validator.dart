
class Validator {

  static String validateInput(String value) {
    if (value.isEmpty) {
      return 'Complete el campo';
    }

    return null;
  }
}