import 'package:flutter/material.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with CommonWidgets {
  // Track which FAQ items are expanded
  final Map<int, bool> _expandedItems = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false
  };

  // List of FAQ items
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'টেস্ট কোর্স কিভাবে কিনবো?',
      'answer':
          'প্রস্তুতি অ্যাপে সাবস্ক্রিপশন প্ল্যান কিনতে, আপনার অ্যাকাউন্টে লগইন করুন, "সাবস্ক্রিপশন" মেনুতে যান, আপনার পছন্দের প্ল্যান (১ মাস, ৩ মাস, ৬ মাস, অথবা ১২ মাস) নির্বাচন করুন, এবং আমাদের নিরাপদ পেমেন্ট গেটওয়ে ব্যবহার করে অর্থপ্রদান করুন। সাবস্ক্রিপশন কেনার পরে, আপনি সমস্ত টেস্ট কোর্স, স্টাডি মেটেরিয়াল এবং অন্যান্য প্রিমিয়াম সুবিধাগুলি অ্যাক্সেস করতে পারবেন।'
    },
    {
      'question': 'ফ্লাশ কার্ড কীভাবে তৈরি করবো?',
      'answer':
          'প্রস্তুতি অ্যাপে ফ্লাশ কার্ড তৈরি করতে, আপনার অ্যাকাউন্টে লগইন করুন, "ফ্লাশ কার্ড" সেকশনে যান, "নতুন কার্ড তৈরি করুন" বাটনে ক্লিক করুন, আপনার প্রশ্ন এবং উত্তর লিখুন, এবং "সংরক্ষণ করুন" বাটনে ক্লিক করুন। আপনি পরবর্তীতে আপনার তৈরি করা ফ্লাশ কার্ডগুলি সম্পাদনা, অর্গানাইজ, এবং অধ্যয়ন করতে পারবেন।'
    },
    {
      'question': 'সাবস্ক্রিপশন শেষ হলে কী কী ফিচার ব্যবহার করতে পারব?',
      'answer':
          'আপনার সাবস্ক্রিপশন শেষ হওয়ার পরেও, আপনি নিম্নলিখিত ফিচারগুলি ব্যবহার করতে পারবেন: টেস্ট সিস্টেম, অসীমিত ডাউট সলভিং, অসীমিত ফ্লাশকার্ড ব্যবহার, এবং কিছু প্রি-রেকর্ডেড কোর্স। তবে, প্রিমিয়াম কন্টেন্ট এবং নতুন কোর্স অ্যাক্সেস করতে আপনাকে আবার সাবস্ক্রাইব করতে হবে।'
    },
    {
      'question': 'রিফান্ড পলিসি কী?',
      'answer':
          'একবার সাবস্ক্রিপশন কেনা হলে, আইন দ্বারা প্রয়োজনীয় ক্ষেত্র ছাড়া বাতিলকরণ বা রিফান্ডের কোনো বিকল্প নেই। সাবস্ক্রাইব করার আগে, আমাদের টেস্ট কোর্স এবং পরিষেবাগুলি সম্পর্কে সমস্ত প্রয়োজনীয় তথ্য দেখে নিন। কোনো প্রশ্ন থাকলে, সাবস্ক্রাইব করার আগে আমাদের সাপোর্ট টিমের সাথে যোগাযোগ করুন।'
    },
    {
      'question': 'প্রস্তুতি অ্যাপ কি আমার ব্যক্তিগত তথ্য সংরক্ষণ করে?',
      'answer':
          'হ্যাঁ, আমরা আপনার ব্যক্তিগত তথ্য সংরক্ষণ করি এবং এটি সুরক্ষিত রাখি। আমরা আপনার নাম, ইমেইল, ফোন নম্বর, পেমেন্ট তথ্য, স্টাডি ইন্টারেস্ট, প্রোফাইল তথ্য এবং একাডেমিক হিস্ট্রি সংগ্রহ করি। আমরা আপনার তথ্য অন্য কোনো তৃতীয় পক্ষের সাথে শেয়ার করি না, কেবল পেমেন্ট প্রসেসর এবং ক্লাউড সার্ভিস প্রোভাইডারদের মতো সেবা প্রদানকারীদের সাথে শেয়ার করি যারা আমাদের প্ল্যাটফর্ম পরিচালনায় সাহায্য করে।'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context.l10n!.faq),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  itemCount: _faqItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildFAQItem(
                      index,
                      _faqItems[index]['question'] ?? '',
                      _faqItems[index]['answer'] ?? '',
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  // Launch email to support
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'support@prostuti.app',
                    query:
                        'subject=FAQ Question&body=I have a question regarding...',
                  );

                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4169E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "প্রশ্ন করুন", // "Ask Question" in Bengali
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    bool isExpanded = _expandedItems[index] ?? false;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with toggle
          InkWell(
            onTap: () {
              setState(() {
                _expandedItems[index] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ),

          // Answer content (only shown when expanded)
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
