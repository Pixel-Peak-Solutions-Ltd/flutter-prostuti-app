import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/file_helper.dart';
import 'package:prostuti/core/services/size_config.dart';
import 'package:prostuti/features/course/materials/resources/viewmodel/resource_details_viewmodel.dart';
import 'package:prostuti/features/course/materials/resources/widgets/resource_skeleton.dart';

class ResourceDetailsView extends ConsumerStatefulWidget {
  const ResourceDetailsView({
    super.key,
  });

  @override
  ResourceDetailsViewState createState() => ResourceDetailsViewState();
}

class ResourceDetailsViewState extends ConsumerState<ResourceDetailsView>
    with CommonWidgets {
  FileHelper fileHelper = FileHelper();

  @override
  Widget build(BuildContext context) {
    final resourceDetailsAsync = ref.watch(resourceDetailsViewmodelProvider);
    return Scaffold(
      appBar: commonAppbar("রিসোর্স"),
      body: resourceDetailsAsync.when(
        data: (resource) {
          return ListView.builder(
            itemCount: resource.data!.uploadFileResources!.length,
            itemBuilder: (context, index) {
              final uploadItem = resource.data!.uploadFileResources![index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: SizeConfig.h(64),
                  width: MediaQuery.sizeOf(context).width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  child: Center(
                      child: ListTile(
                    onTap: () async {
                      Fluttertoast.showToast(msg: "Starting Download");
                      String? filePath = await fileHelper.downloadFile(
                          uploadItem.path!, uploadItem.originalName!);

                      if (filePath != null) {
                        await fileHelper.openFile(filePath);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed to download the file.");
                      }
                    },
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
                                'PDF',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
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
                      uploadItem.originalName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.file_download_outlined),
                  )),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Text("$error"),
        loading: () => const ResourceSkeleton(),
      ),
    );
  }
}
