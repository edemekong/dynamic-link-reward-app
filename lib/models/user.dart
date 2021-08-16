class User {
  String? uid;
  String? email;
  String? name;
  String? referCode;
  String? referLink;
  List<String>? referrers = [];
  int? reward;

  User({this.uid, this.email, this.name, this.referCode, this.referLink, this.referrers, this.reward});

  factory User.fromJson(String docId, Map<String, dynamic> data) {
    List<String> referrers = [];
    if (data.containsKey('referrers')) {
      referrers.add(data['referrers']);
    }

    return User(
      uid: docId,
      name: data['name'],
      email: data['email'],
      referCode: data['refer_code'],
      referLink: data['refer_link'],
      referrers: referrers,
      reward: data['reward'],
    );
  }
}
