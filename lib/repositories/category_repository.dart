import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:foda/models/category.dart';
import 'package:foda/models/result.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  ValueNotifier<List<Category>> categoriesNotifier =
      ValueNotifier<List<Category>>([]);

  StreamSubscription? streamsSubscriptions;

  Future<Either<ErrorHandler, List<Category>>> getCategories() async {
    try {
      final querySnapshot = _firestore.collection("category").snapshots();
      streamsSubscriptions?.cancel();
      streamsSubscriptions = null;
      streamsSubscriptions = querySnapshot.listen(_listenToCategories);
      return const Right([]);
    } catch (e) {
      return Left(ErrorHandler(message: e.toString()));
    }
  }

  Future<Either<ErrorHandler, Category>> getCategory(String categoryId) async {
    try {
      final categories = categoriesNotifier.value
          .firstWhere((category) => category.id == categoryId);
      return Right(categories);
    } catch (e) {
      try {
        // if (foodId.isEmpty) {
        //   return const Left(ErrorHandler(message: 'No food Id found...'));
        // }
        // final _productSnapshot = await _firestore.doc(foodId).get();
        // if (_productSnapshot.exists) {
        //   final food = Category.fromMap(_productSnapshot.data() as Map<String, dynamic>);
        //   categoriesNotifier.value.add(categories);
        //   categoriesNotifier.notifyListeners();
        //   return Right(categories);
        // }
        return const Left(ErrorHandler(message: "Error"));
      } on FirebaseException catch (e) {
        return Left(ErrorHandler(message: e.message ?? ''));
      }
    }
  }

  void _listenToCategories(QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (final document in snapshot.docs) {
      final category = Category.fromMap(document.data());

      final index = categoriesNotifier.value
          .indexWhere((element) => element.id == category.id);

      if (index != -1) {
        categoriesNotifier.value.removeAt(index);
        categoriesNotifier.value.insert(index, category);
      } else {
        categoriesNotifier.value.add(category);
      }

      categoriesNotifier.notifyListeners();
    }
  }
}
