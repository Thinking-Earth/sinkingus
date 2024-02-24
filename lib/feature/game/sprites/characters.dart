import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

const CHARACTER_SIZE_X = 128.0;
const CHARACTER_SIZE_Y = 150.0;

class MyPlayer extends SpriteComponent
    with CollisionCallbacks, KeyboardHandler, RiverpodComponentMixin {
  int money = 0;
  RoleType role;
  late String uid;

  SpriteComponent background;
  late final Vector2 screensize;

  double maxSpeed = -300.0;
  JoystickComponent joystick;

  MyPlayer(this.role, this.screensize, this.joystick, this.background)
      : super(
            size: Vector2.all(100.0),
            anchor: Anchor.center,
            position: screensize * 0.5);

  @override
  FutureOr<void> onMount() async {
    uid = ref.read(userDomainControllerProvider).userInfo!.uid;
    sprite = await Sprite.load("characters/${role.code}_idle_left.png");
    size = Vector2(CHARACTER_SIZE_X, CHARACTER_SIZE_Y);

    add(TextComponent(
        text: ref.read(userDomainControllerProvider).userInfo!.nick,
        position: Vector2(0, -20)));

    return super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      background.position.add(joystick.relativeDelta * maxSpeed * dt);
      transform.scale = Vector2((joystick.relativeDelta.x > 0) ? -1 : 1, 1);
      sendChangedPosition();
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      Vector2 moveDirection = Vector2.zero();
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) moveDirection.x += -10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) moveDirection.x += 10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) moveDirection.y += -10;
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS)) moveDirection.y += 10;
      background.position.add(-moveDirection);
      transform.scale = Vector2(
          (moveDirection.x > 0) ? -1 : 1, 1); // TODO: sprite 바꾸기로 대체 (@전은지)
      sendChangedPosition();

      if (keysPressed.contains(LogicalKeyboardKey.keyP)) print(position);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void sendChangedPosition() async {
    await FirebaseDatabase.instance
        .ref("players/$uid/position")
        .set([-background.position.x, -background.position.y]);
  }
}

class OtherPlayer extends SpriteComponent {
  RoleType role = RoleType.undefined;
  late String name = "";
  String uid;
  Vector2 backgroundSize;

  OtherPlayer(this.uid, this.backgroundSize);

  Future<void> getUserInfo() async {
    final data = await FirebaseDatabase.instance.ref("players/$uid").get();
    if (data.exists) {
      final userInfo = data.value as Map<String, dynamic>;
      name = userInfo["name"];
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await getUserInfo();

    sprite = await Sprite.load("characters/${role.code}_idle_left.png");
    size = Vector2(CHARACTER_SIZE_X, CHARACTER_SIZE_Y);

    add(TextComponent(
        text: name, position: Vector2(0, -20), anchor: Anchor.topCenter));

    FirebaseDatabase.instance
        .ref("players/$uid/position")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final positionData = event.snapshot.value as List<dynamic>;
        //print(positionData);
        position =
            Vector2(positionData[0], positionData[1]) + backgroundSize * 0.5;
      }
    });

    return super.onLoad();
  }
}
