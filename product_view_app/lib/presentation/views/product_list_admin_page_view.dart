import 'package:flutter/material.dart';
import 'package:product_view_app/presentation/components/admin_menu.dart';
import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/controller/product_controller.dart';
import 'package:product_view_app/presentation/model/product_model.dart';
import 'package:product_view_app/presentation/views/product_add_admin_page_view.dart';

class ProductListAdminPageView extends StatefulWidget {
  const ProductListAdminPageView({super.key});

  @override
  State<ProductListAdminPageView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListAdminPageView> {
  List<ProductModel> listProducts = [];
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> loadData() async {
    try {
      await productController
          .getProducts(LoginController().modelData.accessToken);

      listProducts = productController.listProducts;

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminMenu(
      index: 1,
      content: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Products",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductAddAdminPageView(),
                      ),
                    );
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FutureBuilder<bool>(
                        future: loadData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.blue,
                            ));
                          } else if (snapshot.hasError ||
                              !snapshot.hasData ||
                              !snapshot.data!) {
                            return Image.asset('assets/placeholder.png');
                          } else {
                            return DataTable(
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'ID',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                // DataColumn(
                                //     label: Text(
                                //   'Image',
                                //   style: TextStyle(fontWeight: FontWeight.bold),
                                // )),
                                DataColumn(
                                    label: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Description',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Price',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Views',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Comments',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Watchlist Adds',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Action',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ],
                              rows: listProducts.map((product) {
                                return DataRow(cells: [
                                  DataCell(
                                    Text(
                                      product.productId.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  // DataCell(
                                  //   Image.network(product.imageUrl),
                                  // ),
                                  DataCell(
                                    Text(product.productName),
                                  ),
                                  DataCell(
                                    SizedBox(
                                        width: 280,
                                        child: Text(
                                          product.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ),
                                  DataCell(Text(
                                    "${product.price.toStringAsFixed(2)}\$",
                                  )),
                                  DataCell(
                                    Text(product.statistics.totalViews
                                        .toString()),
                                  ),
                                  DataCell(
                                    Text(product.statistics.totalComments
                                        .toString()),
                                  ),
                                  DataCell(
                                    Text(product.statistics.totalWatchlistAdds
                                        .toString()),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue),
                                        onPressed: () {},
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {},
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
