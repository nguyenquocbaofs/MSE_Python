import 'package:flutter/material.dart';

import 'package:product_view_app/presentation/views/detail_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    String dummyUrl =
        "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI";
    Widget buildBestProductList() {
      buildItem(int index) {
        subText(String txtContent) {
          return Text(
            '$txtContent $index',
            softWrap: true,
            style: const TextStyle(fontSize: 12.0),
          );
        }

        return Container(
            width: 220,
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: 80.0,
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Image.network(dummyUrl),
                  ),
                  subText("Product name"),
                  subText("Score: 1000"),
                  subText("Comments: 1700"),
                ],
              ),
            ));
      }

      List<Widget> listItem() {
        final items = <Widget>[];

        for (var i = 0; i < 20; i++) {
          items.add(buildItem(i));
        }
        return items;
      }

      return Container(
        color: Colors.yellow.shade100,
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
                )),
            SizedBox(
              height: 160.0,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: listItem(),
              ),
            )
          ],
        ),
      );
    }

    buildContentProductList() {
      buildItem(int index) {
        subText(String txtContent) {
          return Text(
            '$txtContent $index',
            softWrap: true,
            style: const TextStyle(fontSize: 12.0),
          );
        }

        return InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailPageView(),
              ),
            )
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
                    child: Image.network(dummyUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        subText("Product name"),
                        subText("Score"),
                        subText("Comments"),
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

        for (var i = 0; i < 20; i++) {
          items.add(buildItem(i));
        }
        return items;
      }

      return ListView(
        scrollDirection: Axis.vertical,
        children: listItem(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Product Views"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildBestProductList(),
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Text("List Products"),
            ),
            Expanded(
              child: buildContentProductList(),
            ),
          ],
        ),
      ),
    );
  }
}
