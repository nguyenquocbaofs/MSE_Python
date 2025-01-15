import 'package:flutter/material.dart';

import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/controller/product_controller.dart';
import 'package:product_view_app/presentation/model/product_model.dart';
import 'package:product_view_app/presentation/views/detail_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  List<ProductModel> listProducts = [];
  ProductController productController = ProductController();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    await productController
        .getProducts(LoginController().modelData.accessToken);
    setState(() {
      listProducts = productController.listProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadImage(String url) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/placeholder.png');
        },
      );
    }

    Widget buildBestProduct() {
      List<ProductModel> sortScoresList = listProducts;
      sortScoresList.sort((a, b) {
        if (a.scores == b.scores) {
          return b.comments.length.compareTo(a.comments.length);
        } else {
          return b.scores.compareTo(a.scores);
        }
      });

      if (sortScoresList.isNotEmpty) {
        ProductModel product = sortScoresList[0];
        buildItem() {
          subText(String txtContent) {
            return Text(
              txtContent,
              softWrap: true,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          }

          return Container(
            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: loadImage(product.imageUrl),
                ),
                subText(product.productName),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Price: ${product.price} dollar',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: '   |   ${product.comments.length} comments',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '   |   ${product.views.length} views',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) {
                      if (index < product.scores) {
                        return const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        );
                      } else {
                        return const Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.volunteer_activism_rounded),
                    Text("Best Products"),
                  ],
                ),
              ),
              buildItem(),
            ],
          ),
        );
      }

      return const SizedBox();
    }

    buildContentProductList() {
      buildItem(ProductModel product) {
        subText(String txtContent) {
          return Text(
            txtContent,
            softWrap: true,
            style: const TextStyle(fontSize: 12.0),
          );
        }

        return InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPageView(
                  productData: product,
                ),
              ),
            ).then((value) {
              setState(() {
                listProducts = productController.listProducts;
              });
            })
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: loadImage(product.imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        subText(product.productName),
                        subText("Sprice: ${product.price} dollar"),
                        subText("${product.comments.length} comments"),
                        subText("${product.views.length} views"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      List<Widget> listItem() {
        final items = <Widget>[];

        for (var i = 0; i < listProducts.length; i++) {
          items.add(buildItem(listProducts[i]));
        }
        return items;
      }

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: listItem(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text(
          "Product Views",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: listProducts.length > 1
                    ? Column(
                        children: [
                          buildBestProduct(),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: const Text(
                              "List Products",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          buildContentProductList(),
                        ],
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.blue,
                              semanticsLabel: "Product loading.....",
                            ),
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
