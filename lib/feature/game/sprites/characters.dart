import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';
import 'package:sinking_us/helpers/constants/app_typography.dart';

const double CHARACTER_SIZE_X = 100 * 1.4;
const double CHARACTER_SIZE_Y = 128 * 1.4;

enum CharacterState {
  idle,
  walk;
}

class MyPlayer extends SpriteAnimationGroupComponent<CharacterState>
    with
        CollisionCallbacks,
        KeyboardHandler,
        RiverpodComponentMixin,
        HasGameReference<SinkingUsGame> {
  int money = 0;
  RoleType role = RoleType.undefined;
  String uid;

  SpriteComponent background;
  SpriteComponent background2;
  late final Vector2 screensize;
  Vector2 characterPosition = Vector2(0, 0);
  Vector2 oldCharacterPosition = Vector2(0, 0);
  double dtSum = 0;

  double maxSpeed = 200.0;
  JoystickComponent joystick;
  late TextComponent nameText;

  late Sprite idle;
  late Sprite walk1;
  late Sprite walk2;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;

  MyPlayer(this.uid, this.screensize, this.joystick, this.background,
      this.background2)
      : super(
            size: Vector2(CHARACTER_SIZE_X * 1.w, CHARACTER_SIZE_Y * 1.w),
            anchor: Anchor.center,
            position: screensize * 0.5);

  @override
  FutureOr<void> onLoad() async {
    idle = await Sprite.load("characters/${role.code}_idle.png");
    walk1 = await Sprite.load("characters/${role.code}_walk1.png");
    walk2 = await Sprite.load("characters/${role.code}_walk2.png");
    idleAnimation = SpriteAnimation.spriteList([idle], stepTime: 0.2);
    walkAnimation =
        SpriteAnimation.spriteList([walk1, idle, walk2, idle], stepTime: 0.2);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.walk: walkAnimation,
    };

    current = CharacterState.idle;

    await FirebaseDatabase.instance
        .ref("players/$uid/position")
        .get()
        .then((value) {
      final positionData = value.value as List<dynamic>;
      characterPosition = Vector2(positionData[0], positionData[1]) * 1.w;
      background.position.add(-characterPosition);
      background2.position.add(-characterPosition);
      oldCharacterPosition = characterPosition.clone();
    });

    nameText = TextComponent(
        text: game.state.playerName,
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        position: Vector2(size.x * 0.5, 0));

    add(nameText);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      if (joystick.relativeDelta.x > 0) {
        transform.scale = Vector2(-1, 1);
        nameText.scale = Vector2(-1, 1);
        current = CharacterState.walk;
      } else {
        transform.scale = Vector2(1, 1);
        nameText.scale = Vector2(1, 1);
        current = CharacterState.walk;
      }
      background.position.add(joystick.relativeDelta * maxSpeed * dt * -1.w);
      background2.position.add(joystick.relativeDelta * maxSpeed * dt * -1.w);
      characterPosition.add(joystick.relativeDelta * maxSpeed * dt * 1.w);
    }

    if (oldCharacterPosition == characterPosition) {
      current = CharacterState.idle;
    }

    if (dtSum > 0.1 &&
        (oldCharacterPosition.x != characterPosition.x ||
            oldCharacterPosition.y != characterPosition.y)) {
      sendChangedPosition();
      dtSum = 0;
      oldCharacterPosition = characterPosition.clone();
    } else {
      dtSum += dt;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      Vector2 moveDirection = Vector2.zero();
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA))
        moveDirection.x += -10.w;
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD))
        moveDirection.x += 10.w;
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW))
        moveDirection.y += -10.w;
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS))
        moveDirection.y += 10.w;
      if (moveDirection.x >= 0) {
        current = CharacterState.walk;
        scale = Vector2(-1, 1);
        nameText.scale = Vector2(-1, 1);
      } else if (moveDirection.x < 0) {
        current = CharacterState.walk;
        scale = Vector2(1, 1);
        nameText.scale = Vector2(1, 1);
      }
      background.position.add(-moveDirection);
      background2.position.add(-moveDirection);
      characterPosition.add(moveDirection);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void sendChangedPosition() async {
    if (isMounted) {
      await FirebaseDatabase.instance
          .ref("players/$uid/position")
          .set([characterPosition.x / 1.w, characterPosition.y / 1.w]);
    }
  }

  void setRole(RoleType newRole) async {
    role = newRole;
    idle = await Sprite.load("characters/${role.code}_idle.png");
    walk1 = await Sprite.load("characters/${role.code}_walk1.png");
    walk2 = await Sprite.load("characters/${role.code}_walk2.png");
  }

  void nextDay() {
    characterPosition = Vector2.zero();
    oldCharacterPosition = Vector2.zero();
    sendChangedPosition();
    background.position =
        Vector2(0, background.size.y * -0.5) + screensize * 0.5;
    background2.position =
        Vector2(0, background2.size.y * -0.5) + screensize * 0.5;
  }
}

class OtherPlayer extends SpriteAnimationGroupComponent<CharacterState>
    with HasGameReference<SinkingUsGame> {
  RoleType role = RoleType.undefined;
  late String name = "";
  String uid;
  Vector2 backgroundSize;
  late TextComponent nameText;

  late Vector2 oldPosition;
  double dtSum = 0;

  late Sprite idle;
  late Sprite walk1;
  late Sprite walk2;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;

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

    oldPosition = backgroundSize * 0.5;

    idle = await Sprite.load("characters/${role.code}_idle.png");
    walk1 = await Sprite.load("characters/${role.code}_walk1.png");
    walk2 = await Sprite.load("characters/${role.code}_walk2.png");
    idleAnimation = SpriteAnimation.spriteList([idle], stepTime: 0.2);
    walkAnimation =
        SpriteAnimation.spriteList([walk1, idle, walk2, idle], stepTime: 0.2);

    animations = {
      CharacterState.idle: idleAnimation,
      CharacterState.walk: walkAnimation,
    };

    current = CharacterState.idle;

    size = Vector2(CHARACTER_SIZE_X * 1.w, CHARACTER_SIZE_Y * 1.w);
    anchor = Anchor.center;

    nameText = TextComponent(
        text: name,
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        position: Vector2(size.x * 0.5, 0));
    add(nameText);

    FirebaseDatabase.instance
        .ref("players/$uid/position")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        oldPosition = position.clone();
        final positionData = event.snapshot.value as List<dynamic>;
        position = Vector2(positionData[0], positionData[1]) * 1.w +
            backgroundSize * 0.5;
        if (position.x - oldPosition.x > 0) {
          transform.scale = Vector2(-1, 1);
          nameText.scale = Vector2(-1, 1);
          current = CharacterState.walk;
        } else {
          transform.scale = Vector2(1, 1);
          nameText.scale = Vector2(1, 1);
          current = CharacterState.walk;
        }
      } else {
        game.deletePlayer(this);
        removeFromParent();
      }
    });

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (dtSum > 0.2) {
      if (oldPosition == position) {
        current = CharacterState.idle;
      } else {
        oldPosition = position.clone();
      }
      dtSum = 0;
    } else {
      dtSum += dt;
    }
    super.update(dt);
  }
}
