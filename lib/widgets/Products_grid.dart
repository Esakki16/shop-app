import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pro_products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final proProductsData = Provider.of<ProProducts>(context);
    final proProduts =
        showFavs ? proProductsData.FavoriteItems : proProductsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: proProduts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: proProduts[i],
        child: ProductItem(
            // proProduts[i].id,
            // proProduts[i].title,
            // proProduts[i].imageUrl,
            ),
      ),
    );
  }
}
