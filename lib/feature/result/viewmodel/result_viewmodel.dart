import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'result_viewmodel.g.dart';

class ResultViewModelState {
  ResultViewModelState({
    required this.status
  });

  String status;
}

@Riverpod(keepAlive: true)
class ResultViewModelController extends _$ResultViewModelController {
  @override
  ResultViewModelState build() {
    return ResultViewModelState(
      status: "nature die"
    );
  }

  void setState() {
    state = ResultViewModelState(
      status: state.status
    );
  }

  void setStatus(String status) {
    state.status = status;
    setState();
  }
}