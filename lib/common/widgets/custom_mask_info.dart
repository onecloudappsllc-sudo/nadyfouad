class CustomMaskInfo{

  static String maskedEmail (String email){
    List<String> parts = email.split('@');
    String user = parts[0];
    String domain = parts[1];

    int visibleLength = (user.length > 3) ? 3 : 1;
    String visiblePart = user.substring(0, visibleLength);
    String maskedPart = '*' * (user.length - visibleLength);

    return '$visiblePart$maskedPart$domain';
  }

}