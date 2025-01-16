import 'package:flutter/material.dart';
import 'package:product_view_app/presentation/controller/login_controller.dart';
import 'package:product_view_app/presentation/controller/user_info_controller.dart';

class UserInfoPageView extends StatefulWidget {
  const UserInfoPageView({super.key});

  @override
  State<UserInfoPageView> createState() => _UserInfoPageViewState();
}

class _UserInfoPageViewState extends State<UserInfoPageView> {
  bool isEditState = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    updateControllerInfo();
  }

  updateControllerInfo() {
    mobileController.text = UserInfoController().modelData.mobile;
    addressController.text = UserInfoController().modelData.address;
    dropdownValue = UserInfoController().modelData.gender;
  }

  @override
  Widget build(BuildContext context) {
    buildInfoContent() {
      buildItemReadOnly() {
        buildItem({required String title, required String content}) {
          return Row(
            children: [
              SizedBox(
                width: 70.0,
                child: Text(title),
              ),
              Text(content)
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItem(title: "Name: ", content: UserInfoController().modelData.username),
            const SizedBox(
              height: 14.0,
            ),
            buildItem(title: "Mobile: ", content: UserInfoController().modelData.mobile),
            const SizedBox(
              height: 14.0,
            ),
            buildItem(title: "Gender: ", content: UserInfoController().modelData.gender),
            const SizedBox(
              height: 14.0,
            ),
            buildItem(title: "Address: ", content: UserInfoController().modelData.address),
            const SizedBox(
              height: 14.0,
            ),
            buildItem(title: "Email: ", content: UserInfoController().modelData.email),
            const SizedBox(
              height: 14.0,
            ),
            SizedBox(
              width: 120.0,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    updateControllerInfo();
                    isEditState = true;
                  });
                },
                child: const Text("Edit Info"),
              ),
            ),
          ],
        );
      }

      buildEdit() {
        const List<String> list = <String>['Male', 'Female'];
        buildDropdownField() {
          return Row(
            children: [
              const SizedBox(
                width: 70,
                child: Text("Gender: "),
              ),
              DropdownMenu<String>(
                initialSelection: list.first,
                onSelected: (String? value) {
                  dropdownValue = value!;
                },
                dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ],
          );
        }

        buildItem({
          required String title,
          required TextEditingController controller,
        }) {
          return Row(
            children: [
              SizedBox(
                width: 70.0,
                child: Text(title),
              ),
              SizedBox(
                width: 200,
                height: 45.0,
                child: TextField(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  controller: controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildItem(
              title: "Mobile: ",
              controller: mobileController,
            ),
            const SizedBox(
              height: 14.0,
            ),
            buildDropdownField(),
            const SizedBox(
              height: 14.0,
            ),
            buildItem(
              title: "Address: ",
              controller: addressController,
            ),
            const SizedBox(
              height: 14.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditState = false;
                      });
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(
                  width: 24.0,
                ),
                SizedBox(
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      await UserInfoController()
                          .editUserInfo(LoginController().modelData.accessToken, mobileController.text,
                              addressController.text, dropdownValue)
                          .then(
                            (value) => setState(
                              () {
                                isEditState = false;
                              },
                            ),
                          );
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            )
          ],
        );
      }

      return Card(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          width: double.infinity,
          height: double.infinity,
          child: isEditState ? buildEdit() : buildItemReadOnly(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: buildInfoContent(),
        ),
      ),
    );
  }
}
