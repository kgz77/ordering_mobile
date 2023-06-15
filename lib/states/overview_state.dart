import 'package:flutter/material.dart';
import 'package:foda/components/base_state.dart';
import 'package:foda/repositories/cart_repository.dart';
import 'package:foda/repositories/food_repository.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/checkout/checkout_view.dart';
import 'package:foda/services/get_it.dart';
import 'package:foda/services/navigation_service.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:foda/utils/common.dart';

import '../components/cupertino_model_route.dart';
import '../models/food.dart';
import '../repositories/category_repository.dart';

class OverviewState extends BaseState {
  final navigationService = locate<NavigationService>();
  final userRepo = locate<UserRepository>();
  final foodRepository = locate<FoodRepository>();
  final CategoryRepository categoryRepository = locate<CategoryRepository>();
  final cartRepo = locate<CartRepository>();

  PageController pageController = PageController();

  OverviewState() {
    foodRepository.getFoods();
    categoryRepository.getCategories();
    cartRepo.getCart(userRepo.currentUserUID!);
    navigationService.currentIndexNotifier.addListener(_currentIndexListener);
  }

  void animateToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _currentIndexListener() {
    animateToPage(navigationService.currentIndexNotifier.value);
  }

  void addToCart(Food food, [bool isAdding = true]) async {
    await cartRepo.addOrRemoveFoodFromCart(userRepo.currentUserUID!, food,
        isAdding: isAdding);
    if (isAdding) {
      showCustomToast("${food.title} добавлено в корзину");
    } else {
      showCustomToast("${food.title} удалено из корзины");
    }
  }

  void addToFavorite(Food food) {
    userRepo.addFoodToFavorite(userRepo.currentUserUID!, food);
    showCustomToast("${food.title} добавлено в избранные!");
  }

  void removCartItem(Food food) {
    cartRepo.removeFoodFromCart(userRepo.currentUserUID!, food);
    showCustomToast("${food.title} удалено из корзины");
  }

  Future<void> openCartView(BuildContext context) async {
    await showSnapModelBottomSheet(
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      elevation: 10,
      backgroundColor: AppTheme.black.withOpacity(.8),
      topRadius: const Radius.circular(40),
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.92,
        child: const CheckoutView(),
      ),
    );
  }
}
