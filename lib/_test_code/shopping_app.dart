import 'package:flutter/material.dart';
import 'package:flutter_blog/_test_code/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 창고 시스템을 도입 - StatelessWidget 확장 --> ConsumerWidget 변경
class ShoppingApp extends ConsumerWidget {
  const ShoppingApp({super.key});

  // WidgetRef ref - 통로
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 방금 내가 만든 창고에 접근해(이름) --> 창고에서 관리하는 데이를 반환
    final List<String> products = ref.read(productsProvider);
    // ['사과', '바나나', '우유', '빵']
    final Cart cart = ref.watch(cartProvider);

    // ref.watch(provider) <-- 계속 구독해(계속 지켜봐)
    // ref.read(provider)  <-- 뭔간 단 한번 요청할 때 사용
    return Scaffold(
      appBar: AppBar(
        title: Text('상점'),
        actions: [
          // 장바구니 개수 표시
          Center(child: Text('장바구니 ${cart.items.length} 개')),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final String product = products[index];
                return ListTile(
                  title: Text(product),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // 상태를 공유 해야 해!!
                      // 창고에 데이터를 추가 해 (기능)
                      // ref.read(cartProvider) --> 창고 데이터를 반환
                      // ref.read(cartProvider.notifier) // 창고 메뉴얼 접근
                      ref.read(cartProvider.notifier).add(product);
                    },
                    child: Text('담기'),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '장바구니',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final String item = cart.items[index];
                      return ListTile(
                        title: Text(item),
                        trailing: IconButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).remove(item);
                          },
                          icon: Icon(
                            Icons.remove,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
