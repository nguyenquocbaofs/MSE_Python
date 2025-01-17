import 'package:flutter/material.dart';
import 'package:product_view_app/presentation/views/dashboad_admin_page_view.dart';
import 'package:product_view_app/presentation/views/product_list_admin_page_view.dart';

class AdminMenu extends StatefulWidget {
  final int index;
  final Widget content;

  const AdminMenu({
    super.key,
    required this.index,
    required this.content,
  });

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  int _selectedIndex = 0;
  late Widget _content;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    _content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
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
                if (_selectedIndex == 0) {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const DashBoadAdminPageView(),
                    ),
                  );
                } else if (_selectedIndex == 1) {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const ProductListAdminPageView(),
                    ),
                  );
                }
                _content = const SizedBox();
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
                label: Text('Dashboard'),
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
              color: Colors.white,
              child: _content,
            ),
          ),
        ],
      ),
    );
  }
}
