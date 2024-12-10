import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/services/size_config.dart';

class ResourceSkeleton extends StatelessWidget {
  const ResourceSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Skeletonizer(
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: SizeConfig.h(64),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Center(
                  child: ListTile(
                onTap: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Colors.grey.shade300)),
                leading: Stack(
                  children: [
                    Image.asset("assets/icons/file_icon.png"),
                    Positioned(
                      top: 20,
                      child: Container(
                        height: SizeConfig.h(12),
                        width: SizeConfig.w(30),
                        decoration: BoxDecoration(
                            color: const Color(0xffE86E35),
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                          child: Text(
                            'PPT',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                title: Text(
                  'টেস্ট সল্যুশন.pdf',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  '1.2 MB',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.file_download_outlined),
              )),
            ),
          ),
        );
      },
    );
  }
}
