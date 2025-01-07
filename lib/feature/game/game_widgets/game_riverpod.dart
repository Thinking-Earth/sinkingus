import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:sinking_us/config/routes/app_router.dart';
import 'package:sinking_us/config/routes/routes.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/sprites/characters.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';
import 'package:sinking_us/feature/result/viewmodel/result_viewmodel.dart';

class GameState extends PositionComponent
    with RiverpodComponentMixin, HasGameReference<SinkingUsGame> {
  late int hp = 100;
  late int natureScore = 100;
  late int money = 100;
  String playerName = "";
  int currentEvent = -1;
  RuleType rule = RuleType.noRule;
  Map<GroceryType, int> groceryList = {
    for (var element in GroceryType.values) element: -1
  };

  double dtSum = 0;

  late StreamSubscription<DatabaseEvent> ruleListener,
      necessityListener,
      scoreListener;

  @override
  FutureOr<void> onLoad() {
    ruleListener = FirebaseDatabase.instance
        .ref("game/${game.matchId}/rule")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        rule = RuleType.getById(event.snapshot.value as int);
        if (game.day > 0) {
          game.gameUI.gameNotification("${tr(rule.code)} has been enacted.");
        }
      }
    });
    necessityListener = FirebaseDatabase.instance
        .ref("game/${game.matchId}/groceryList")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> castedData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        for (var grocery in GroceryType.values) {
          if (groceryList[grocery] != castedData[grocery.code]) {
            groceryList[grocery] = castedData[grocery.code];
            game.gameUI.gameNotification("${grocery.code} has been activated.");
          }
        }
      }
    });
    scoreListener = FirebaseDatabase.instance
        .ref("game/${game.matchId}/natureScore")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        natureScore = event.snapshot.value as int;
      }
    });
    return super.onLoad();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      ref.listen(matchDomainControllerProvider, (ps, ns) {
        if (ns.hpdt > 0) {
          hp = min(hp + ns.hpdt, 100);
        } else {
          hp = max(hp + ns.hpdt, 0);
        }
        if (ns.natureScoredt != 0) {
          natureScore = ns.natureScoredt > 0
              ? min(natureScore + ns.natureScoredt, 100)
              : max(natureScore + ns.natureScoredt, 0);
          setNatureScore();
        }
        money = ns.money;
      });
    });

    playerName = ref.read(userDomainControllerProvider).userInfo!.nick;

    return super.onMount();
  }

  void gameEnd() async {
    String status = "undefined";
    if (game.day == 8) {
      Map<String, String> playersStatus = await FirebaseDatabase.instance
          .ref("game/${game.matchId}/status")
          .get()
          .then((value) {
        return Map<String, String>.from(value.value as Map);
      });
      switch (game.player.role) {
        case RoleType.worker:
          status = "win";
          break;
        case RoleType.business:
          if (money >= 3000) status = "win";
          break;
        case RoleType.politician:
          if (!playersStatus.values.contains("hp die")) status = "win";
          break;
        case RoleType.nature:
          if (natureScore >= 50) status = "win";
          break;
        case RoleType.undefined:
          break;
      }
    } else {
      if (hp == 0) {
        status = "hp die";
      } else if (natureScore == 0) {
        status = "nature die";
      }
    }
    ref.read(matchDomainControllerProvider.notifier).sendStatus(status: status);
    ref.read(resultViewModelControllerProvider.notifier).setStatus(status);
    AppRouter.popAndPushNamed(Routes.resultScreenRoute);
    leaveMatch(hp != 0);
  }

  @override
  void update(double dt) {
    if (hp == 0 || natureScore == 0) {
      gameEnd();
    }

    if (game.player.role != RoleType.business) {
      if (dtSum > 3) {
        if (game.day > 0 && game.gameUI.timer.isRunning()) hp -= 1;
        dtSum = 0;
      } else {
        dtSum += dt;
      }
    }

    super.update(dt);
  }

  void startGame() {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(1);
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('Chapter Book.mp3', volume: 0.1);
  }

  void checkHost() {
    ref.read(matchDomainControllerProvider.notifier).checkHost();
  }

  bool isHost() {
    return ref.read(matchDomainControllerProvider.notifier).isHost();
  }

  void nextDay() {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(game.day);
  }

  void hostStartGame() async {
    await ref.read(matchDomainControllerProvider.notifier).hostStartGame(
        game.uid, List<String>.generate(5, (index) => game.players[index].uid));
  }

  void hostNextDay() {
    ref.read(matchDomainControllerProvider.notifier).hostNextDay();
  }

  void leaveMatch(bool isHostEnd) async {
    ref
        .read(matchDomainControllerProvider.notifier)
        .leaveMatch(isHostEnd: isHostEnd);
    FlameAudio.bgm.stop();
  }

  void setPlayers(List<OtherPlayer> players) {
    ref.read(matchDomainControllerProvider.notifier).setPlayers(
        List<String>.generate(players.length, (index) => players[index].uid));
  }

  void setRule(RuleType newRule) {
    ref.read(matchDomainControllerProvider.notifier).setRule(newRule.id);
  }

  bool setDt(int? hpdt, int? natureScoredt, int? moneydt) {
    return ref
        .read(matchDomainControllerProvider.notifier)
        .setDt(hpdt, natureScoredt, moneydt);
  }

  void setActivate(GroceryType type) {
    ref.read(matchDomainControllerProvider.notifier).setStoreActive(type);
  }

  void setNatureScore() {
    ref
        .read(matchDomainControllerProvider.notifier)
        .setNatureScore(natureScore);
  }

  Future<RoleType> getRole(String uid) async {
    return await ref.read(matchDomainControllerProvider.notifier).getRole(uid);
  }

  @override
  void onRemove() {
    ruleListener.cancel();
    necessityListener.cancel();
    scoreListener.cancel();
    super.onRemove();
  }

  void buy(int price) {
    ref.read(matchDomainControllerProvider.notifier).buy(price);
  }
}
