import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../services/firebase/model/app_user_model.dart';
import '../controllers/my_batch_controller.dart';

final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));

class MyBatchView extends GetView<MyBatchController> {
  const MyBatchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("App Users"),
          centerTitle: true,
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowLeft),
            onPressed: () => Get.back(),
          ),
        ),
        body: listWithEmail,
      );

  Widget get listWithEmail => FutureBuilder<List<AppUser>>(
        future: controller.getAppUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data?.isEmpty ?? true) {
              return const Center(child: Text("No Data"));
            } else {
              final users = snapshot.data ?? [];
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: users.length,
                itemBuilder: (context, index) =>
                    tileWithName(users[index], index, context),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          return Container();
        },
      );

  Widget tileWithName(AppUser user, int index, BuildContext context) => Tooltip(
        message: user.email,
        child: Card(
          elevation: controller.isMe(user.email) ? 5 : 0,
          child: ListTile(
            shape: shape,
            tileColor: controller.isMe(user.email)
                ? Color.alphaBlend(
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha(5 * (Get.isDarkMode ? 4 : 3)),
                    Theme.of(context).cardColor)
                : null,
            leading: Text((index + 1).toString()),
            title: Text(user.name),
            trailing: controller.isMe(user.email) ? const Text("😋") : null,
          ),
        ),
      );
}
