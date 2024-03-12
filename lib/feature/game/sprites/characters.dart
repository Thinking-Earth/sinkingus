// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
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
    with KeyboardHandler, HasGameReference<SinkingUsGame>, CollisionCallbacks {
  int money = 0;
  RoleType role = RoleType.worker;
  String uid;

  late final Vector2 screensize;
  Vector2 characterPosition = Vector2(0, 0);
  Vector2 oldCharacterPosition = Vector2(0, 0);
  double sendDtSum = 0;
  double animationDtSum = 0;

  double maxSpeed = 80.w;
  late Vector2 moveForce;
  JoystickComponent joystick;
  late TextComponent nameText;
  late CircleHitbox hitbox;

  late Sprite idle;
  late Sprite walk1;
  late Sprite walk2;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;

  MyPlayer(this.uid, this.screensize, this.joystick)
      : super(
            size: Vector2(CHARACTER_SIZE_X * 1.w, CHARACTER_SIZE_Y * 1.w),
            anchor: Anchor.center,
            position: screensize * 0.5) {
    moveForce = Vector2.zero();
  }

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
      characterPosition =
          Vector2(positionData[0] * 1.0, positionData[1] * 1.0) * 1.w;
      game.background.position.add(-characterPosition);
      game.background2.position.add(-characterPosition);
      oldCharacterPosition = characterPosition.clone();
    });

    nameText = TextBoxComponent(
        text: game.state.playerName,
        textRenderer: TextPaint(style: AppTypography.blackPixel),
        anchor: Anchor.center,
        align: Anchor.bottomCenter,
        position: Vector2(size.x * 0.5, 10.w));

    hitbox = CircleHitbox(
        anchor: Anchor.bottomCenter,
        position: Vector2(size.x * 0.5, size.y - 28.w),
        radius: 25.w);

    add(hitbox);
    add(nameText);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moveForce != Vector2.zero()) {
      if (!hitbox.isColliding) {
        transform.scale = Vector2(moveForce.x > 0 ? -1 : 1, 1);
        nameText.scale = Vector2(moveForce.x > 0 ? -1 : 1, 1);
      }
      current = CharacterState.walk;

      game.background.position.add(-moveForce);
      game.background2.position.add(-moveForce);

      characterPosition.add(moveForce);
      moveForce = Vector2.zero();
    }

    if (!joystick.delta.isZero()) {
      moveForce = joystick.relativeDelta * maxSpeed * dt * 1.w;
    }

    if (animationDtSum > 0.3) {
      if (oldCharacterPosition.x == characterPosition.x &&
          oldCharacterPosition.y == characterPosition.y &&
          current == CharacterState.walk) {
        current = CharacterState.idle;
        animationDtSum = 0;
      }
    } else {
      animationDtSum += dt;
    }

    if (sendDtSum > 0.1) {
      if (oldCharacterPosition.x != characterPosition.x ||
          oldCharacterPosition.y != characterPosition.y) {
        sendChangedPosition();
        sendDtSum = 0;
        oldCharacterPosition = characterPosition.clone();
      }
    } else {
      sendDtSum += dt;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
          keysPressed.contains(LogicalKeyboardKey.keyA)) {
        moveForce.x += -maxSpeed / 20;
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
          keysPressed.contains(LogicalKeyboardKey.keyD)) {
        moveForce.x += maxSpeed / 20;
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
          keysPressed.contains(LogicalKeyboardKey.keyW)) {
        moveForce.y += -maxSpeed / 20;
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
          keysPressed.contains(LogicalKeyboardKey.keyS)) {
        moveForce.y += maxSpeed / 20;
      }

      if (moveForce.x != 0 && moveForce.y != 0) {
        moveForce /= pow(2, 1 / 2) as double;
      }
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (intersectionPoints.length == 2) {
      Vector2 mid =
          (intersectionPoints.elementAt(0) + intersectionPoints.elementAt(1)) /
              2;
      double length = (hitbox.absoluteCenter - mid).length;
      moveForce +=
          (hitbox.absoluteCenter - mid).scaled(hitbox.radius - length) / length;
    }
    super.onCollision(intersectionPoints, other);
  }

  void setRole() async {
    role = await game.state.getRole(uid);
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
  }

  void nextDay() {
    characterPosition = Vector2.zero();
    oldCharacterPosition = Vector2.zero();
    sendChangedPosition();
    game.background.position =
        Vector2(0, game.background2.size.y * -0.5) + screensize * 0.5;
    game.background2.position =
        Vector2(0, game.background2.size.y * -0.5) + screensize * 0.5;
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

  late StreamSubscription<DatabaseEvent> positionListener;

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

    positionListener = FirebaseDatabase.instance
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

  void setRole() async {
    role = await game.state.getRole(uid);
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
  }

  @override
  void onRemove() {
    positionListener.cancel();
    super.onRemove();
  }
}
