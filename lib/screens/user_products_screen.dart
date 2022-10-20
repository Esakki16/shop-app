import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pro_products.dart';
import '../widgets/user-product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProProducts>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final proProductsData = Provider.of<ProProducts>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProProducts>(
                      builder: (ctx, proProductsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                proProductsData.items[i].id!,
                                proProductsData.items[i].title,
                                proProductsData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: proProductsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
