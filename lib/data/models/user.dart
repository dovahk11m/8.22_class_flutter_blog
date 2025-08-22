// User 모델 클래스 설계
// API 문서 기준으로 설계해 볼 수 있다.

class User {
  int? id; // API 에서 누락될 수 있다.
  String? username;
  String? imgUrl; // 프로필은 선택사항
  String? accessToken;

  User({
    this.id,
    this.username,
    this.imgUrl,
    this.accessToken,
  });

  // json to Dart 변환 생성자
  // dart 문법. 이름이 있는 생성자
  // dart 에서 json 문자열을 convert 패키지에서 Map 구조 변환
  // User() 객체를 생성해주는 코드이다.
  User.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        username = data['username'],
        imgUrl = data['imgUrl'],
        accessToken = data['accessToken'];

  // 디버깅용 문자열 표현
  @override
  String toString() {
    return 'User{id: $id, username: $username, imgUrl: $imgUrl, accessToken: $accessToken}';
  }
}
