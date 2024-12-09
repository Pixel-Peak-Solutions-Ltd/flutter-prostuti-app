import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/common/widgets/long_button.dart';
import 'package:prostuti/core/services/file_helper.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/assignment_details_viewmodel.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/assignment_file_name.dart';
import 'package:prostuti/features/course/materials/assignment/viewmodel/get_file_path.dart';
import 'package:prostuti/features/course/materials/assignment/widgets/assignment_widgets.dart';

import '../../../../../core/services/size_config.dart';
import '../widgets/assignment_skeleton.dart';

class AssignmentDetailsView extends ConsumerStatefulWidget {
  const AssignmentDetailsView({
    super.key,
  });

  @override
  AssignmentDetailsViewState createState() => AssignmentDetailsViewState();
}

class AssignmentDetailsViewState extends ConsumerState<AssignmentDetailsView>
    with CommonWidgets, AssignmentWidgets {
  final fileHelper = FileHelper();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final assignmentDetailsAsync =
        ref.watch(assignmentDetailsViewmodelProvider);

    return Scaffold(
      appBar: commonAppbar("এসাইনমেন্ট"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: assignmentDetailsAsync.when(
            data: (assignment) {
              String filePath = ref.watch(getFilePathProvider);
              String fileName = ref.watch(assignmentFileNameProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'এসাইনমেন্ট গাইডলাইন',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Gap(24),
                  Text(
                    'এসাইনমেন্ট মার্কস',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const Gap(6),
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: assignment.data!.marks.toString()),
                  ),
                  const Gap(24),
                  Text(
                    'সাবমিশনের ডিটেইলস',
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(6),
                  Text(
                    textAlign: TextAlign.justify,
                    assignment.data!.details ?? "No details",
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Gap(24),
                  for (var file in assignment.data!.uploadFileResources!)
                    InkWell(
                        onTap: () async {
                          Fluttertoast.showToast(msg: "Starting Download");
                          String? filePath = await fileHelper.downloadFile(
                              file.path!, file.originalName!);

                          if (filePath != null) {
                            await fileHelper.openFile(filePath);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Failed to download the file.");
                          }
                        },
                        child: fileBox(theme, file.originalName!)),
                  const Gap(24),
                  Text(
                    'সাবমিট করুন',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Gap(24),
                  filePath != ""
                      ? fileBox(theme, fileName)
                      : InkWell(
                          onTap: () async {
                            final result = await FilePicker.platform
                                .pickFiles(type: FileType.any);

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              ref
                                  .watch(getFilePathProvider.notifier)
                                  .setFilePath(file.path);

                              ref
                                  .watch(assignmentFileNameProvider.notifier)
                                  .setFileName(file.path.split('/').last);
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: submitBox(theme)),
                  const Gap(24),
                  LongButton(onPressed: () {}, text: "সাবমিশন কনফার্ম করুন")
                ],
              );
            },
            error: (error, stackTrace) => Text("$error"),
            loading: () => AssignmentSkeleton(),
          ),
        ),
      ),
    );
  }
}
