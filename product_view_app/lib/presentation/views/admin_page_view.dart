import 'package:flutter/material.dart';
import 'package:product_view_app/presentation/views/product_list_admin_page_view.dart';

class AdminPageView extends StatefulWidget {
  const AdminPageView({super.key});

  @override
  State<AdminPageView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminPageView> {
  int _selectedIndex = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildContent() {
      if (_selectedIndex == 0) {
        return const SizedBox(); // Danh sách người dùng
      } else if (_selectedIndex == 1) {
        return const ProductListAdminPageView(); // Danh sách sản phẩm
      }
      return const SizedBox();
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            backgroundColor: Colors.blueAccent,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            // leading: const Icon(Icons.admin_panel_settings, size: 40),
            unselectedIconTheme:
                const IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: const TextStyle(
              color: Colors.white,
            ),
            selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('User'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart),
                label: Text('Product'),
              ),
            ],
          ),

          // Nội dung bên phải
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
