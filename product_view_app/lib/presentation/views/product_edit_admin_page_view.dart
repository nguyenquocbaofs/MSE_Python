import 'package:flutter/material.dart';
import 'package:product_view_app/presentation/components/admin_menu.dart';
import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/controller/product_controller.dart';
import 'package:product_view_app/presentation/model/product_model.dart';
import 'package:product_view_app/presentation/views/product_list_admin_page_view.dart';

class ProductEditAdminPageView extends StatefulWidget {
  final ProductModel productModel;
  const ProductEditAdminPageView({super.key, required this.productModel});

  @override
  State<ProductEditAdminPageView> createState() => _ProductEditViewState();
}

class _ProductEditViewState extends State<ProductEditAdminPageView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController productNameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;
  ProductController productController = ProductController();

  @override
  void initState() {
    productNameController =
        TextEditingController(text: widget.productModel.productName);
    priceController =
        TextEditingController(text: widget.productModel.price.toString());
    descriptionController =
        TextEditingController(text: widget.productModel.description);
    imageUrlController =
        TextEditingController(text: widget.productModel.imageUrl);

    super.initState();
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    productNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onSubmit(
        {required String productName,
        required int productId,
        required double price,
        required String description,
        required String imageUrl}) async {
      await productController.editProduct(
          LoginController().modelData.accessToken,
          productId,
          productName,
          price,
          description,
          imageUrl);

      return true;
    }

    return AdminMenu(
      index: 1,
      content: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Edit Product",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, collect data

                          // Handle the collected data
                          await onSubmit(
                              productName: productNameController.text,
                              productId: widget.productModel.productId,
                              price: double.parse(priceController.text),
                              description: descriptionController.text,
                              imageUrl: imageUrlController.text);

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ProductListAdminPageView(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ProductListAdminPageView(),
                          ),
                        );
                      },
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
