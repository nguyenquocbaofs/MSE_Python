import 'package:flutter/material.dart';

class DetailPageView extends StatefulWidget {
  const DetailPageView({super.key});

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    int dummyCurrentId = 1;
    String dummyComment = "This is my comment to test";
    String dummyUrl =
        "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI";

    Widget commonSpaceColumn(
        {required List<Widget> children,
        double space = 5,
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
        MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
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
      Widget buildItems(int id) {
        return Row(
          children: [
            Text(
              "Name: ---- ",
              style: TextStyle(
                  color: id != dummyCurrentId ? Colors.black : Colors.red),
            ),
            const SizedBox(
              width: 12,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Text(dummyComment),
            ),
          ],
        );
      }

      for (var i = 0; i < 20; i++) {
        listComments.add(buildItems(i));
      }
      return listComments;
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text(
          "Product Detail",
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: commonSpaceColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    space: 12.0,
                    children: <Widget>[
                      Card(
                        child: Container(
                          alignment: Alignment.center,
                          child: commonSpaceColumn(
                            children: <Widget>[
                              const SizedBox(
                                height: 5,
                              ),
                              Image.network(dummyUrl),
                              const Text("Product Title:"),
                              const Text("Product vote: "),
                              const Text("Score: "),
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
                          onPressed: () => {},
                          child: const Text("Comments"),
                        ),
                      ),
                      commonSpaceColumn(
                        space: 12.0,
                        children: buildListComments(),
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
