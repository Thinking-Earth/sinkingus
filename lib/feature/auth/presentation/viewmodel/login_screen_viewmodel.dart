import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sinking_us/feature/auth/data/model/user_info_model.dart';
import 'package:sinking_us/feature/auth/domain/auth_domain.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/helpers/extensions/showdialog_helper.dart';

part 'login_screen_viewmodel.g.dart';

class LoginScreenState {
  LoginScreenState();
}

@riverpod
class LoginScreenController extends _$LoginScreenController {
  @override
  LoginScreenState build() {
    return LoginScreenState();
  }

  void setState() {
    state = LoginScreenState();
  }

  void handlePressedSignInGoogle() async {
    ShowDialogHelper.showLoading(color: Colors.white);
    final UserInfoModel? userInfo = await ref.read(authDomainControllerProvider.notifier).socialSignInWithGoogle();
    if(userInfo != null) {
      ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
      ShowDialogHelper.closeLoading();
    } else {
      ShowDialogHelper.showAlert(title: tr('noti_noti'), message: tr('noti_fail_google'));
    }
  }

  void handlePressedSignInApple() async {
    ShowDialogHelper.showLoading(color: Colors.white);
    final UserInfoModel? userInfo = await ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
    if(userInfo != null) {
      ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
      ShowDialogHelper.closeLoading();
    } else {
      ShowDialogHelper.showAlert(title: tr('noti_noti'), message: tr('noti_fail_apple'));
    }
    ref.read(authDomainControllerProvider.notifier).socialSignInWithApple();
  }

  void handlePressedTester() async {
    ShowDialogHelper.showLoading(color: Colors.white);
    final UserInfoModel userInfo = UserInfoModel(
      email: "${generateRandomUID(21)}@gmail.com", 
      nick: generateRandomNick(), 
      profileURL: "", 
      uid: generateRandomUID(21)
    );
    ref.read(userDomainControllerProvider.notifier).setUserInfo(userInfo: userInfo);
    ShowDialogHelper.closeLoading();
  }
}

String generateRandomUID(int length) {
  Random random = Random();
  String randomNumber = '';

  for (int i = 0; i < length; i++) {
    randomNumber += random.nextInt(10).toString();
  }

  return randomNumber;
}

String generateRandomNick() {
  Random random = Random();
  List<String> animals = [
    'Penguin', 'Polar Bear', 'Tiger', 'Rhino', 'Elephant', 'Gorilla', 'Leopard'
  ];
  List<String> adjectives = [
    'Displaced', 'Endangered', 'Hungry', 'Lost', 'Lonely'
  ];

  String animal = animals[random.nextInt(animals.length)];
  String adjective = adjectives[random.nextInt(adjectives.length)];
  int number = random.nextInt(20) + 1;  // 1부터 20까지의 랜덤 번호

  return "The $number${getOrdinalSuffix(number)} $adjective $animal";
}

// 숫자에 따른 서수 접미사를 반환하는 함수
String getOrdinalSuffix(int number) {
  int lastDigit = number % 10;
  if ((number % 100 >= 11) && (number % 100 <= 13)) {
    return 'th';
  }
  switch (lastDigit) {
    case 1: return 'st';
    case 2: return 'nd';
    case 3: return 'rd';
    default: return 'th';
  }
}