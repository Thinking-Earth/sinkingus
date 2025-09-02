import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_viewmodel.g.dart';

class ResultViewModelState {
  ResultViewModelState({required this.status, required this.isMusicPlayed});

  String status;
  bool isMusicPlayed;
}

@Riverpod(keepAlive: true)
class ResultViewModelController extends _$ResultViewModelController {
  @override
  ResultViewModelState build() {
    return ResultViewModelState(status: "nature die", isMusicPlayed: false);
  }

  void setState() {
    state = ResultViewModelState(
        status: state.status, isMusicPlayed: state.isMusicPlayed);
  }

  void setStatus(String status) {
    state.status = status;
    setState();
  }

  void setMusicPlayed(bool isPlayed) {
    state.isMusicPlayed = isPlayed;
    setState();
  }
}
