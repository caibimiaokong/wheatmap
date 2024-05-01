class Validator {
  Validator();

  String? email(String? value) {
    //RegExp是Dart中的一个内置类，用于表示正则表达式。
    //正则表达式是一种用于匹配字符串的模式，可以用于验证输入的格式是否正确，
    //或者从文本中提取特定的信息。在Dart中，可以使用RegExp类来创建正则表达式对象，
    //并使用其方法来执行匹配操作。
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value!)) {
      return 'please input validated email';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value!)) {
      return 'please input validated password';
    } else if (value.length < 6) {
      return 'password too short';
    } else {
      return null;
    }
  }

  String? name(String? value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'please input validated name';
    } else {
      return null;
    }
  }

  String? number(String? value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'please input validated number';
    } else {
      return null;
    }
  }

  String? amount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'validator.amount';
    } else {
      return null;
    }
  }

  String? notEmpty(String? value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'validator.notEmpty';
    } else {
      return null;
    }
  }
}
