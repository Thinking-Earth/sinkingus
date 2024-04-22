import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';

class Background extends PositionComponent
    with HasGameReference<SinkingUsGame>, CollisionCallbacks {
  late SpriteComponent background;
  late PositionComponent wall;
  double mapRatio;
  late StreamSubscription<DatabaseEvent> playerListener;

  Background({required this.mapRatio});

  @override
  FutureOr<void> onLoad() async {
    final backgroundSprite = await Sprite.load("map1.png");

    position = Vector2(0, backgroundSprite.originalSize.y * mapRatio * -0.5) +
        game.camera.viewport.virtualSize * 0.5;
    size = backgroundSprite.originalSize * mapRatio;
    anchor = Anchor.topCenter;

    background = SpriteComponent(
        sprite: backgroundSprite,
        size: backgroundSprite.originalSize * mapRatio);

    wall = PositionComponent();
    setWall();

    background.add(wall);

    add(background);

    playerListener = FirebaseDatabase.instance
        .ref("game/${game.matchId}/players")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.exists) {
        if (event.snapshot.value.toString() != game.uid) {
          OtherPlayer newPlayer =
              OtherPlayer(event.snapshot.value.toString(), background.size);
          game.players.add(newPlayer);
          add(newPlayer);
        }
      }
    });

    return super.onLoad();
  }

  @override
  void onRemove() {
    playerListener.cancel();
    super.onRemove();
  }

  void setWall() {
    wall.addAll([
      PolygonHitbox([
        Vector2(842, 675) * mapRatio,
        Vector2(831, 660) * mapRatio,
        Vector2(830, 167) * mapRatio,
        Vector2(843, 152) * mapRatio,
        Vector2(1020, 152) * mapRatio,
        Vector2(1037, 167) * mapRatio,
        Vector2(1037, 224) * mapRatio,
        Vector2(1092, 243) * mapRatio,
        Vector2(1149, 242) * mapRatio,
        Vector2(1202, 223) * mapRatio,
        Vector2(1202, 170) * mapRatio,
        Vector2(1217, 153) * mapRatio,
        Vector2(1385, 152) * mapRatio,
        Vector2(1403, 168) * mapRatio,
        Vector2(1403, 661) * mapRatio,
        Vector2(1390, 675) * mapRatio,
        Vector2(1025, 674) * mapRatio,
        Vector2(1025, 760) * mapRatio,
        Vector2(1112, 787) * mapRatio,
        Vector2(1180, 841) * mapRatio,
        Vector2(1220, 906) * mapRatio,
        Vector2(1506, 906) * mapRatio,
        Vector2(1514, 899) * mapRatio,
        Vector2(1514, 296) * mapRatio,
        Vector2(1529, 287) * mapRatio,
        Vector2(1622, 287) * mapRatio,
        Vector2(1623, 213) * mapRatio,
        Vector2(1633, 200) * mapRatio,
        Vector2(1653, 200) * mapRatio,
        Vector2(1653, 214) * mapRatio,
        Vector2(1727, 214) * mapRatio,
        Vector2(1729, 218) * mapRatio,
        Vector2(1746, 217) * mapRatio,
        Vector2(1750, 200) * mapRatio,
        Vector2(1916, 200) * mapRatio,
        Vector2(1930, 211) * mapRatio,
        Vector2(1930, 469) * mapRatio,
        Vector2(1916, 480) * mapRatio,
        Vector2(1775, 480) * mapRatio,
        Vector2(1772, 654) * mapRatio,
        Vector2(1793, 664) * mapRatio,
        Vector2(1793, 777) * mapRatio,
        Vector2(1799, 805) * mapRatio,
        Vector2(1799, 903) * mapRatio,
        Vector2(1913, 903) * mapRatio,
        Vector2(1930, 920) * mapRatio,
        Vector2(1930, 954) * mapRatio,
        Vector2(1911, 973) * mapRatio,
        Vector2(1636, 973) * mapRatio,
        Vector2(1623, 958) * mapRatio,
        Vector2(1623, 823) * mapRatio,
        Vector2(1565, 823) * mapRatio,
        Vector2(1565, 942) * mapRatio,
        Vector2(1552, 954) * mapRatio,
        Vector2(1234, 954) * mapRatio,
        Vector2(1234, 1041) * mapRatio,
        Vector2(1664, 1041) * mapRatio,
        Vector2(1677, 1052) * mapRatio,
        Vector2(1677, 1303) * mapRatio,
        Vector2(1708, 1338) * mapRatio,
        Vector2(1844, 1338) * mapRatio,
        Vector2(1861, 1349) * mapRatio,
        Vector2(1861, 1510) * mapRatio,
        Vector2(1849, 1526) * mapRatio,
        Vector2(1770, 1526) * mapRatio,
        Vector2(1755, 1539) * mapRatio,
        Vector2(1642, 1542) * mapRatio,
        Vector2(1642, 1548) * mapRatio,
        Vector2(1698, 1603) * mapRatio,
        Vector2(1779, 1603) * mapRatio,
        Vector2(1812, 1619) * mapRatio,
        Vector2(1812, 1673) * mapRatio,
        Vector2(1799, 1688) * mapRatio,
        Vector2(1440, 1688) * mapRatio,
        Vector2(1422, 1673) * mapRatio,
        Vector2(1422, 1619) * mapRatio,
        Vector2(1437, 1604) * mapRatio,
        Vector2(1536, 1604) * mapRatio,
        Vector2(1536, 1541) * mapRatio,
        Vector2(1480, 1541) * mapRatio,
        Vector2(1465, 1527) * mapRatio,
        Vector2(1390, 1527) * mapRatio,
        Vector2(1375, 1512) * mapRatio,
        Vector2(1374, 1356) * mapRatio,
        Vector2(1390, 1341) * mapRatio,
        Vector2(1600, 1341) * mapRatio,
        Vector2(1627, 1304) * mapRatio,
        Vector2(1627, 1090) * mapRatio,
        Vector2(1219, 1090) * mapRatio,
        Vector2(1191, 1143) * mapRatio,
        Vector2(1114, 1212) * mapRatio,
        Vector2(1025, 1237) * mapRatio,
        Vector2(1025, 1344) * mapRatio,
        Vector2(1250, 1346) * mapRatio,
        Vector2(1266, 1360) * mapRatio,
        Vector2(1266, 1607) * mapRatio,
        Vector2(1251, 1622) * mapRatio,
        Vector2(1068, 1622) * mapRatio,
        Vector2(1053, 1607) * mapRatio,
        Vector2(1053, 1523) * mapRatio,
        Vector2(1068, 1508) * mapRatio,
        Vector2(1098, 1508) * mapRatio,
        Vector2(1098, 1449) * mapRatio,
        Vector2(1045, 1449) * mapRatio,
        Vector2(1010, 1490) * mapRatio,
        Vector2(897, 1490) * mapRatio,
        Vector2(897, 1535) * mapRatio,
        Vector2(883, 1551) * mapRatio,
        Vector2(792, 1551) * mapRatio,
        Vector2(751, 1444) * mapRatio,
        Vector2(705, 1444) * mapRatio,
        Vector2(675, 1491) * mapRatio,
        Vector2(389, 1497) * mapRatio,
        Vector2(389, 1600) * mapRatio,
        Vector2(375, 1618) * mapRatio,
        Vector2(235, 1618) * mapRatio,
        Vector2(221, 1600) * mapRatio,
        Vector2(221, 1491) * mapRatio,
        Vector2(108, 1491) * mapRatio,
        Vector2(92, 1475) * mapRatio,
        Vector2(92, 1360) * mapRatio,
        Vector2(107, 1346) * mapRatio,
        Vector2(400, 1344) * mapRatio,
        Vector2(400, 1196) * mapRatio,
        Vector2(378, 1176) * mapRatio,
        Vector2(378, 900) * mapRatio,
        Vector2(399, 874) * mapRatio,
        Vector2(399, 776) * mapRatio,
        Vector2(293, 768) * mapRatio,
        Vector2(166, 719) * mapRatio,
        Vector2(57, 625) * mapRatio,
        Vector2(4, 468) * mapRatio,
        Vector2(14, 421) * mapRatio,
        Vector2(116, 403) * mapRatio,
        Vector2(171, 313) * mapRatio,
        Vector2(159, 237) * mapRatio,
        Vector2(205, 215) * mapRatio,
        Vector2(329, 177) * mapRatio,
        Vector2(476, 177) * mapRatio,
        Vector2(610, 217) * mapRatio,
        Vector2(700, 279) * mapRatio,
        Vector2(772, 363) * mapRatio,
        Vector2(732, 448) * mapRatio,
        Vector2(787, 544) * mapRatio,
        Vector2(764, 600) * mapRatio,
        Vector2(706, 667) * mapRatio,
        Vector2(604, 733) * mapRatio,
        Vector2(532, 761) * mapRatio,
        Vector2(448, 777) * mapRatio,
        Vector2(448, 879) * mapRatio,
        Vector2(472, 899) * mapRatio,
        Vector2(570, 899) * mapRatio,
        Vector2(586, 915) * mapRatio,
        Vector2(586, 975) * mapRatio,
        Vector2(760, 975) * mapRatio,
        Vector2(779, 902) * mapRatio,
        Vector2(867, 800) * mapRatio,
        Vector2(975, 760) * mapRatio,
        Vector2(975, 673) * mapRatio
      ]),
      PolygonHitbox([
        Vector2(587, 1026) * mapRatio,
        Vector2(761, 1026) * mapRatio,
        Vector2(789, 1121) * mapRatio,
        Vector2(860, 1196) * mapRatio,
        Vector2(971, 1236) * mapRatio,
        Vector2(971, 1344) * mapRatio,
        Vector2(448, 1344) * mapRatio,
        Vector2(448, 1176) * mapRatio,
        Vector2(573, 1176) * mapRatio,
        Vector2(587, 1155) * mapRatio
      ]),
      PolygonHitbox([
        Vector2(1564, 337) * mapRatio,
        Vector2(1622, 337) * mapRatio,
        Vector2(1623, 470) * mapRatio,
        Vector2(1640, 479) * mapRatio,
        Vector2(1723, 481) * mapRatio,
        Vector2(1723, 653) * mapRatio,
        Vector2(1630, 653) * mapRatio,
        Vector2(1615, 663) * mapRatio,
        Vector2(1615, 772) * mapRatio,
        Vector2(1564, 772) * mapRatio
      ]),
      PolygonHitbox([
        Vector2(1404, 1419) * mapRatio,
        Vector2(1768, 1419) * mapRatio,
        Vector2(1768, 1466) * mapRatio,
        Vector2(1583, 1465) * mapRatio,
        Vector2(1563, 1493) * mapRatio,
        Vector2(1404, 1493) * mapRatio
      ])
    ]);

    //wall.debugMode = true;

    background.addAll([
      RectangleHitbox(
          position: Vector2(1667, 263) * mapRatio,
          size: Vector2(227, 180) * mapRatio)
        ..debugMode = true,
      RectangleHitbox(
          position: Vector2(1643, 659) * mapRatio,
          size: Vector2(79, 128) * mapRatio),
      RectangleHitbox(
          position: Vector2(1642, 827) * mapRatio,
          size: Vector2(37, 63) * mapRatio),
      RectangleHitbox(
          position: Vector2(968, 950) * mapRatio,
          size: Vector2(61, 40) * mapRatio),
      RectangleHitbox(
          position: Vector2(1200, 1393) * mapRatio,
          size: Vector2(53, 51) * mapRatio),
      RectangleHitbox(
          position: Vector2(172, 562) * mapRatio,
          size: Vector2(39, 57) * mapRatio),
      RectangleHitbox(
          position: Vector2(407, 199) * mapRatio,
          size: Vector2(148, 157) * mapRatio),
      RectangleHitbox(
          position: Vector2(358, 428) * mapRatio,
          size: Vector2(39, 59) * mapRatio),
      RectangleHitbox(
          position: Vector2(422, 502) * mapRatio,
          size: Vector2(39, 60) * mapRatio),
      RectangleHitbox(
          position: Vector2(654, 544) * mapRatio,
          size: Vector2(39, 59) * mapRatio),
      RectangleHitbox(
          position: Vector2(900, 221) * mapRatio,
          size: Vector2(32, 339) * mapRatio),
      RectangleHitbox(
          position: Vector2(1308, 229) * mapRatio,
          size: Vector2(32, 331) * mapRatio),
      PolygonHitbox([
        Vector2(959, 222) * mapRatio,
        Vector2(988, 225) * mapRatio,
        Vector2(990, 381) * mapRatio,
        Vector2(995, 397) * mapRatio,
        Vector2(1003, 434) * mapRatio,
        Vector2(1023, 470) * mapRatio,
        Vector2(1047, 471) * mapRatio,
        Vector2(1059, 457) * mapRatio,
        Vector2(1062, 393) * mapRatio,
        Vector2(1027, 379) * mapRatio,
        Vector2(1026, 256) * mapRatio,
        Vector2(1066, 244) * mapRatio,
        Vector2(1173, 244) * mapRatio,
        Vector2(1207, 256) * mapRatio,
        Vector2(1211, 378) * mapRatio,
        Vector2(1177, 417) * mapRatio,
        Vector2(1177, 457) * mapRatio,
        Vector2(1190, 468) * mapRatio,
        Vector2(1223, 468) * mapRatio,
        Vector2(1242, 436) * mapRatio,
        Vector2(1252, 386) * mapRatio,
        Vector2(1254, 232) * mapRatio,
        Vector2(1281, 226) * mapRatio,
        Vector2(1281, 419) * mapRatio,
        Vector2(1268, 482) * mapRatio,
        Vector2(1210, 541) * mapRatio,
        Vector2(1132, 568) * mapRatio,
        Vector2(1108, 567) * mapRatio,
        Vector2(1042, 543) * mapRatio,
        Vector2(979, 485) * mapRatio,
        Vector2(959, 418) * mapRatio,
        Vector2(959, 361) * mapRatio,
      ])
    ]);
    //background.debugMode = true;
  }
}
