import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearnAboutDonation extends StatelessWidget {
  const LearnAboutDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learn More About Donation",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: const DonationInfoBody(),
    );
  }
}

class DonationInfoBody extends StatelessWidget {
  const DonationInfoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderSection(),
          _buildInfoCardSection(context),
          _buildLinksSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why Donate Blood or Platelets?",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            "Your donation can save lives, provide critical help during emergencies, and support medical treatments.",
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoCard(
            title: "Humanitarian Benefits",
            content:
                "Donating blood helps save lives during emergencies, surgeries, and treatments. Platelets are vital for cancer patients, trauma victims, and those with chronic illnesses.",
            icon: Icons.favorite,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Best Practices for Donation",
            content:
                "Stay hydrated, eat a healthy meal before donating, and avoid alcohol. After donating, rest, drink fluids, and avoid strenuous activity.",
            icon: Icons.local_hospital,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            title: "Precautions & Cautions",
            content:
                "Ensure you meet donation eligibility criteria. After donating, rest and avoid lifting heavy objects. Seek medical advice if you feel unwell post-donation.",
            icon: Icons.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Learn More",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          _buildLinkItem(
            title: "E-RaktKosh: India's Online Blood Bank",
            url: "https://eraktkosh.mohfw.gov.in/BLDAHIMS/bloodbank/about.cnt",
          ),
          _buildLinkItem(
            title: "Post-donation advice to blood donors",
            url: "https://www.ncbi.nlm.nih.gov/books/NBK310568/",
          ),
          _buildLinkItem(
            title: "American Red Cross: Blood Donation",
            url: "https://www.redcross.org/give-blood.html",
          ),
          _buildLinkItem(
            title: "WHO Guidelines on Blood Donation",
            url:
                "https://www.who.int/news-room/fact-sheets/detail/blood-safety-and-availability",
          ),
          _buildLinkItem(
            title: "National Blood Transfusion Council (NBTC) India",
            url: "http://nbtc.naco.gov.in/page/aboutus/",
          ),
          _buildLinkItem(
            title: "NHS Blood and Transplant",
            url: "https://www.blood.co.uk",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title,
      required String content,
      required IconData icon}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.redAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem({required String title, required String url}) {
    Uri uri = Uri.parse(url);
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.link, color: Colors.blueAccent),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 15.0, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
