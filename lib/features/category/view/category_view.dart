import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/features/login/view/login_view.dart';

class CategoryView extends ConsumerWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    List<String> categories = [
      "একাডেমিক (ক্লাস ১১-১২)",
      "ভর্তি পরীক্ষা",
      "চাকরি প্রস্তুতি"
    ];

    List<String> icons = [
      "assets/images/backpack_03.png",
      "assets/images/mortarboard_01.png",
      "assets/images/briefcase_01.png"
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.shadeSecondaryLight,
        elevation: 0,
        title: const Text('ক্যাটাগরি'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppColors.borderNormalLight, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: Image.asset(icons[index]),
                title: Text(categories[index]),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ));
                },
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            );
          },
        ),
      ),
    );
  }
}
