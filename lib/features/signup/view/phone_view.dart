import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:prostuti/features/signup/view/otp_view.dart';
import 'package:prostuti/features/signup/viewmodel/phone_number_viewmodel.dart';

import '../../../common/widgets/long_button.dart';

class PhoneView extends ConsumerStatefulWidget {
  const PhoneView({Key? key}) : super(key: key);

  @override
  PhoneViewState createState() => PhoneViewState();
}

class PhoneViewState extends ConsumerState<PhoneView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/prostuti_logo.png",
                width: 154,
                height: 101,
              ),
              const Gap(118),
              Text(
                'আপনার ফোন নম্বর লিখুন',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Gap(32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ফোন নম্বর',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        hintText: "আপনার ফোন নম্বর লিখুন"),
                  ),
                ],
              ),
              Gap(32),
              LongButton(
                text: 'এগিয়ে যাই',
                onPressed: () {
                  ref
                      .watch(phoneNumberProvider.notifier)
                      .setPhoneNumber(_phoneController.text);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OtpView(),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
