import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
class AppStrings {
  const AppStrings._();
  static String floggingTitle(index) {
    return index == 1 ? "지속가능한 걸음을 위한 준비물" : "지속가능한 걸음을 위한 Tip!";
  }

  static String floggingBody(index) {
    return index == 1
        ? "장갑과 봉투, 집게를 준비하면 더욱\n편리하게 플로깅 할 수 있어요!"
        : "분리수거용 봉지와 일반 쓰레기용\n봉지 두 개를 준비하면 더욱 좋아요!";
  }

  static String empty = "";

  static String kiloMeter = "km";

  static String trabSnack = "트래비 간식";

  static String calorie = "칼로리";

  static String time = "시간";

  static String cameraExpain = "내가 주운 쓰레기를 촬영해\n분리배출 방법을 알아볼까요?";

  static String floggingRecord = "플로깅 기록";

  static String myTrab = "마이 트래비";

  static String myPage = "마이 페이지";

  static String customerCenter = "고객 센터";

  static String method = "이용방법";

  static String invidualQuery = "1:1 문의";

  static String termsOfUse = "이용약관";

  static String logIn = "로그인";

  static String logOut = "로그아웃";

  static String withdrawal = "회원탈퇴";

  static String goToSnackPhoto = "간식 촬영하러 가기";

  static String sortTrash = "간식 분류하기";

  static String plastic = "플라스틱";

  static String glass = "유리";

  static String paper = "종이";

  static String can = "캔";

  static String vinyl = "비닐";

  static String styrofoam = "스티로폼";

  static String waste = "일반 쓰레기";

  static String foodWaste = "음식물 쓰레기";

  static String snackToTrab = "트래비에게 간식주러 가기";

  //mytrab
  static String furnitureT = "가구";
  static String snackT = "간식";
  static String trabHouseT = "의 트래비 하우스";
}
