import 'package:equatable/equatable.dart';

class TipModel extends Equatable {
  const TipModel({required this.id, required this.title, required this.body});

  final int id;
  final String title;
  final String body;

  factory TipModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String).trim();
    final body = (json['body'] as String).replaceAll('\n', ' ').trim();
    return TipModel(
      id: json['id'] as int,
      title: title.isEmpty ? title : '${title[0].toUpperCase()}${title.substring(1)}',
      body: body,
    );
  }

  @override
  List<Object?> get props => [id, title, body];
}
