class EmailCheckerHelper {

  static RegExp emailExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");


  static bool isNotValid(String email) {
    return !emailExp.hasMatch(email);
  }


}