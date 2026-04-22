import 'package:flutter/material.dart';
import 'package:flutter_pertemuan_4/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Header (Dynamic Location) ---
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(width: double.infinity, height: 200, decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1504805572947-34fad45aed93?q=80&w=1470&auto=format&fit=crop'), fit: BoxFit.cover))),
                  const Positioned(bottom: -50, child: CircleAvatar(backgroundColor: Colors.white, radius: 64, child: CircleAvatar(backgroundImage: AssetImage('assets/DSC_0020g.jpg'), radius: 60))),
                ],
              ),
              const SizedBox(height: 60),
              const Text("Fahry Muhammad Akbar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("ANDROID DEVELOPER", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
              
              // Tampilkan LOKASI dinamis
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(SharedData.location, style: const TextStyle(color: Colors.grey)),
                ]),
              ),
              const SizedBox(height: 24),

              // --- Kontak Info Row ---
              _buildContactSection(),

              const SizedBox(height: 20),
              
              // --- Tombol Detail ---
              TextButton.icon(
                onPressed: () => setState(() => showDetail = !showDetail),
                icon: Icon(showDetail ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                label: Text(showDetail ? "Hide Details" : "Show Full Resume"),
              ),

              if (showDetail) _buildResumeDetails(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // Widget baru untuk menampilkan Email & HP
  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContactItem(Icons.email_outlined, SharedData.email),
          Container(width: 1, height: 30, color: Colors.blue.shade100),
          _buildContactItem(Icons.phone_android_outlined, SharedData.phone),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: Colors.blueAccent),
      const SizedBox(width: 8),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _buildResumeDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SUMMARY
          const Text("Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(SharedData.summary.isEmpty ? "Belum ada ringkasan." : SharedData.summary, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 25),
          
          // EXPERIENCE
          if(SharedData.experiences.isNotEmpty)...[
            const Text("Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...SharedData.experiences.map((exp) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0, color: Colors.grey.shade50,
              child: ExpansionTile(
                title: Text(exp["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${exp["company"]} | ${exp["year"]}"),
                children: [Padding(padding: const EdgeInsets.all(16), child: Text(exp["description"] ?? ""))],
              ),
            )),
          ],

          const SizedBox(height: 25),

          // EDUCATION (DITAMPILKAN KEMBALI)
          if(SharedData.educations.isNotEmpty)...[
            const Text("Pendidikan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...SharedData.educations.map((edu) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0, color: Colors.grey.shade50,
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blueAccent),
                title: Text(edu["school"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("${edu["degree"]} (${edu["year"]})"),
              ),
            )),
          ]
        ],
      ),
    );
  }
  }