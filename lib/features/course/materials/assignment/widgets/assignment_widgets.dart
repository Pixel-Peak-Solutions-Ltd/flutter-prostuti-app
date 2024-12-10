import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/services/size_config.dart';

mixin AssignmentWidgets {
  Container submitBox(ThemeData theme) {
    return Container(
      height: SizeConfig.h(126),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade500)),
              child: const Icon(
                Icons.file_upload_outlined,
                size: 42,
              ),
            ),
            const Gap(12),
            Text(
              'Click to upload',
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: Colors.purple, fontWeight: FontWeight.w500),
            ),
            const Gap(4),
            Text(
              'PDF (Max 100 MB)',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Container fileBox(ThemeData theme, String name) {
    return Container(
      height: SizeConfig.h(64),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Center(
          child: ListTile(
        trailing: const Icon(Icons.file_download_outlined),
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
                    color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text(
                    'PDF',
                    style: theme.textTheme.bodySmall!.copyWith(
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
          name,
          style: theme.textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      )),
    );
  }
}
