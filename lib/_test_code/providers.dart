import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 기본 창고를 설계 해 보자. (변경 안되는 값들)
// 2. 창고 매뉴얼 필요 없다.
// 타입 안정성 설계 --> 제네릭을 명시
final productsProvider = Provider<List<String>>((ref) {
  return ['사과', '바나나', '우유', '빵'];
});

// 2. 복합 창고를 만들기 전에 - 상태를 먼저 결정해야 한다(값 - 객체)
/// 사과나 바나등 등을 담을 수 있는 객체를 설계 해야 한다.
/// 2. 1 - 상태를 먼저 설계 한다 (보통은 클래스 설계)

/// 상태 --> 객체 (불변 객체) 왜 냐면 다시 접근해서 안에 상태 값을 마구 변경하면
/// 오류가 발생 할 수 있는 일이 많이 생긴다.

class Cart {
  List<String> items;

  Cart({required this.items});
}

/// 2. 2 -  창고 매뉴얼 설계도
class CartNotifier extends Notifier<Cart> {
  /// 중요 변수 - Notifier 클래스를 상속 받으면 state 변수가 기본적으로 있다.

  // 반드시 초기 상태가 어떤지 명시 해주어야 한다.
  /// 필수 !!
  @override
  Cart build() {
    return Cart(items: []);
  }

  // 상품을 추가하는 방법
  void add(String item) {
    // 불변 객체로 설계 설계
    final newItems = [...state.items, item]; // 기본 리스에 + 새 상품 = 새로운 자료 구조 생성
    state = Cart(items: newItems);
  }

  // 상품을 제거하는 방법
  void remove(String item) {
    // list. 특정 조건을 확인하고 새로운 리스트를 만들어주는 메서드
    //['사과', '바나나']
    // '바나나'
    final List<String> newItems =
        state.items.where((element) => element != item).toList();
    state = Cart(items: newItems);
  }
}

/// 2.3 실제 창고 생성 / 매뉴얼과, 창고 데이터를 명시
final cartProvider = NotifierProvider<CartNotifier, Cart>(() => CartNotifier());
