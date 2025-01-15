import 'package:flutter/material.dart';

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
  int dummyID = 1;
  late ProductModel product;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    product = widget.productData;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
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
            Text(
              data.userId != dummyID
                  ? "User Id ${data.userId} "
                  : "Your comments",
              style: TextStyle(
                  color: data.userId != dummyID ? Colors.black : Colors.red),
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
      bool isSuccess = await ProductController().commentProduct(
          LoginController().modelData.accessToken, product.productId, message);
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
                                  loadImage(product.imageUrl),
                                  Text(
                                    product.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  Text(product.description),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Price: ${product.price} dollar',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '   |   ${product.comments.length} comments',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '   |   ${product.views.length} views',
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
