import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Category extends Equatable {
  final String id;
  final String title;

  const Category({
    required this.id,
    required this.title,
  });

  Category copyWith({
    String? id,
    String? title,
  }) {
    return Category(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Food(id: $id, title: $title)';
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
    ];
  }


}
