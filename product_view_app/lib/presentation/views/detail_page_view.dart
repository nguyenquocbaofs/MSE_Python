import 'package:flutter/material.dart';

class DetailPageView extends StatefulWidget {
  const DetailPageView({super.key});

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text("Detail"),
          ),
        ),
      ),
    );
  }
}
