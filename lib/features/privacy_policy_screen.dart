import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E3F98),
        // Deep blue theme color
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E3F98), Color(0xFF1A2352)],
          ),
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: Color(0xFF2E3F98),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "Privacy Policy for Prostuti Technologies",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3F98),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Last Updated: May 2025",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "At Prostuti Technologies (\"Prostuti,\" \"we,\" \"our\"), we are concerned about your privacy. This Privacy Policy explains how we collect, use, disclose, and protect your personal data when you use our platform (app, website, or related services). When you access our services, you agree to data collection and use as outlined in this policy.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildSection(
                    "1. What Data We Collect",
                    "We collect personal data that you provide directly, such as your \"name,\" \"email address,\" \"phone number,\" and \"payment information.\" We also gather account-based information, such as \"study interests,\" \"profile information,\" and \"academic history.\" We additionally collect usage data, such as your use of the platform, \"device information,\" and \"location information\" (if enabled). \"Cookies\" are used to enhance your experience by personalizing content and functionality.",
                  ),
                  _buildSection(
                    "2. How We Use Your Data",
                    "We utilize your personal data primarily to provide and improve our services, such as personalized study plans, exam preparation, and interactions with mentors. We also utilize the data to interact with you regarding account modifications, promotions, and support. Additionally, usage data enables us to gauge the performance of the platform and develop new features.",
                  ),
                  _buildSection(
                    "3. Who We Share Your Data With",
                    "We do not rent or sell your personal data. We will, however, share your information with \"service providers,\" such as \"payment processors\" and \"cloud service providers,\" that help us operate the platform. We will also share information as required by law or in relation to a business transfer (such as a \"merger\" or \"sale of assets\").",
                  ),
                  _buildSection(
                    "4. Data Storage and Retention",
                    "We keep your information secure, and we retain it for as long as necessary to provide you with our services or as required by law. We use \"cookies\" to collect information for functionality and personalization. You can control \"cookies\" through the settings in your browser, although some functionality will be affected if \"cookies\" are disabled.",
                  ),
                  _buildSection(
                    "5. Your Rights",
                    "You are entitled to your personal data. You can access it, modify it, or request its erasure. You can also withdraw from \"marketing communications\" and request a copy of your data in portable format. To invoke any such rights, please reach out to us at prostutiapp.tech@gmail.com",
                  ),
                  _buildSection(
                    "6. Note to Parents",
                    "Our website is designed for users above the age of 12 years. If you are a parent or guardian and believe your child has submitted personal data to us, please contact us so we can take appropriate action.",
                  ),
                  _buildSection(
                    "7. Changes to This Privacy Policy",
                    "We will amend this Privacy Policy from time to time to reflect our new practices or obligations imposed by law. We will inform you of any substantial changes in this Privacy Policy by email or platform notification. You are advised to view this policy periodically to be informed of such changes.",
                  ),
                  _buildSection(
                    "8. Contact Us",
                    "If you have any questions or concerns about this Privacy Policy or how we handle your personal data, please contact us at prostutiapp.tech@gmail.com",
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3F98),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "I Understand",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E3F98),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 20),
      ],
    );
  }
}
