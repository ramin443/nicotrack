import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal-stage-model.freezed.dart';
part 'withdrawal-stage-model.g.dart';

@freezed
class WithdrawalStageModel with _$WithdrawalStageModel {
  const factory WithdrawalStageModel({
    required String timeAfterQuitting,
    required List<Map<String, dynamic>> whatHappens,
    required List<Map<String, dynamic>> symptoms,
    required List<Map<String, dynamic>> howToCope,
  }) = _WithdrawalStageModel;

  factory WithdrawalStageModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalStageModelFromJson(json);
}