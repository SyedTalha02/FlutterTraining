
class User {
  String email;
  String password;
  String token;

  User({this.email, this.password, this.token});

  User.map(dynamic obj) {
    this.email = obj["email"];
    this.password = obj["password"];
    this.token = obj["token"];
  }

  User.mapToken(dynamic obj) {
    this.token = obj["token"];
  }

  String get _email => email;
  String get _password => password;
  String get _token => token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    map["token"] = token;

    return map;
  }
}