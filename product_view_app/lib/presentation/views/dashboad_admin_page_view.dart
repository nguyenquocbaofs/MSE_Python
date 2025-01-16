import 'package:flutter/widgets.dart';
import 'package:product_view_app/presentation/components/admin_menu.dart';

class DashBoadAdminPageView extends StatelessWidget {
  const DashBoadAdminPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminMenu(
        index: 0,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Welcome to Product View Application",
                  style: TextStyle(fontSize: 36)),
            )
          ],
        ));
  }
}
