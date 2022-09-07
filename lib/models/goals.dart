import 'package:json_annotation/json_annotation.dart';
import 'serializers.dart';
part 'goals.g.dart';

@JsonSerializable()
class Goal extends SerializableDocument {
  String objective;
  Map<String, double> progress;
  DateTime createdAt;

  Goal(
    this.objective,
    this.progress,
    this.createdAt,
  );

  @override
  Map<String, dynamic> toJson() => _$GoalToJson(this);
  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
