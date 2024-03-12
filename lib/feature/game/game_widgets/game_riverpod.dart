import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:sinking_us/feature/auth/domain/user_domain.dart';
import 'package:sinking_us/feature/game/domain/match_domain.dart';
import 'package:sinking_us/feature/game/game_widgets/game.dart';
import 'package:sinking_us/feature/game/mini_game/buy_necessity_dialog.dart';
import 'package:sinking_us/feature/game/mini_game/select_policy_dialog.dart';
import 'package:sinking_us/feature/game/sprites/event_btn.dart';
import 'package:sinking_us/feature/game/sprites/roles.dart';

class GameState extends PositionComponent
    with RiverpodComponentMixin, HasGameReference<SinkingUsGame> {
  late int hp = 100;
  late int natureScore = 100;
  late int money = 100;
  String playerName = "";
  int currentEvent = -1;
  RuleType rule = RuleType.noRule;

  double dtSum = 0;

  @override
  FutureOr<void> onLoad() {
    FirebaseDatabase.instance
        .ref("game/${game.matchId}/rule")
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        rule = RuleType.getById(event.snapshot.value as int);
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
        if (ns.natureScoredt > 0) {
          natureScore = min(natureScore + ns.natureScoredt, 100);
        } else {
          natureScore = max(natureScore + ns.natureScoredt, 0);
        }
        money = ns.money;
      });
    });

    playerName = ref.read(userDomainControllerProvider).userInfo!.nick;

    return super.onMount();
  }

  void gameEnd() async {
    Map<String, String> playersStatus = await FirebaseDatabase.instance
        .ref("game/${game.matchId}/status")
        .get()
        .then((value) {
      return value.value as Map<String, String>;
    });
    String status = "undefined";
    if (game.day == 8) {
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
    // TODO: dialog
  }

  @override
  void update(double dt) {
    if (hp < 0 || natureScore < 0) {
      gameEnd();
    }

    if (game.player.role != RoleType.business) {
      if (dtSum > 3) {
        if (currentEvent != GameEventType.news.id &&
            currentEvent != GameEventType.undefined.id) hp -= 1;
        dtSum = 0;
      } else {
        dtSum += dt;
      }
    }

    super.update(dt);
  }

  void startGame() {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(1);
  }

  void nextDay() {
    ref.read(matchDomainControllerProvider.notifier).setNextDay(game.day);
  }

  void hostStartGame() async {
    await ref.read(matchDomainControllerProvider.notifier).hostStartGame();
  }

  void hostNextDay() {
    ref.read(matchDomainControllerProvider.notifier).hostNextDay();
  }

  void leaveMatch() async {
    ref.read(matchDomainControllerProvider.notifier).leaveMatch();
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

  Future<Map<GroceryType, int>> getGroceryList() async {
    return await ref
        .read(matchDomainControllerProvider.notifier)
        .getGroceryList();
  }
}
