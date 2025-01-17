import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/controller/product_controller.dart';
import 'package:product_view_app/presentation/model/product_model.dart';

class DetailPageView extends StatefulWidget {
  final ProductModel productData;
  const DetailPageView({
    super.key,
    required this.productData,
  });

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  late ProductModel product;
  ProductController productController = ProductController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    product = widget.productData;
    loadData();
  }

  loadData() async {
    await productController.getProductById(LoginController().modelData.accessToken, product.productId.toString());
    // setState(() {
    //   listProducts = productController.listProducts;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> checkImageUrl(String url) async {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

    TextEditingController controller = TextEditingController();

    loadImage(String url) {
      return FutureBuilder<bool>(
        future: checkImageUrl(product.imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
            return Image.asset('assets/placeholder.png');
          } else {
            return Image.network(product.imageUrl);
          }
        },
      );
    }

    Widget spaceColumn({
      required List<Widget> children,
      double space = 5,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    }) {
      List<Widget> spacedChildren = [];

      for (int i = 0; i < children.length; i++) {
        spacedChildren.add(children[i]);

        if (i != children.length - 1) {
          spacedChildren.add(
            SizedBox(height: space),
          );
        }
      }

      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: spacedChildren,
      );
    }

    buildListComments() {
      List<Widget> listComments = <Widget>[];

      Widget buildItems(Comment data) {
        return Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        data.userId != LoginController().modelData.userId ? "User Id ${data.userId} " : "Your comments",
                    style: TextStyle(
                      color: data.userId != LoginController().modelData.userId ? Colors.black : Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: "\nRating score: ${data.ratingScore}",
                    style: const TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                ),
                child: Text(
                  data.commentText,
                  softWrap: true,
                ),
              ),
            ),
          ],
        );
      }

      for (var i = 0; i < product.comments.length; i++) {
        listComments.add(buildItems(product.comments[i]));
      }
      return listComments;
    }

    Future<void> onComment(String message) async {
      if (message == "") {
        return;
      }
      setState(() {
        isLoading = true;
      });
      bool isSuccess =
          await ProductController().commentProduct(LoginController().modelData.accessToken, product.productId, message);
      if (isSuccess) {
        controller.text = "";
        for (var element in ProductController().listProducts) {
          if (element.productId == product.productId) {
            product = element;
            break;
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text(
          "Product Detail",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: spaceColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        space: 12.0,
                        children: <Widget>[
                          Card(
                            child: Container(
                              alignment: Alignment.center,
                              child: spaceColumn(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child: loadImage(product.imageUrl),
                                  ),
                                  Text(
                                    product.productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                                  Text(product.description),
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
                                        if (index < product.statistics.avgRatingScore) {
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
                            ),
                          ),
                          const Text("How do you feel this product?"),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: controller,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 1,
                              maxLines: 8,
                              decoration: const InputDecoration(
                                hintText: 'Write your comments',
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              onPressed: () => onComment(controller.text),
                              child: const Text("Comments"),
                            ),
                          ),
                          spaceColumn(
                            space: 12.0,
                            children: buildListComments(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
