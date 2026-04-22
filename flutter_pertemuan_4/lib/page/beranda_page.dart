import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:simple_alert_dialog/simple_alert_dialog.dart';
import 'package:flutter_pertemuan_4/main.dart'; 

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final TextEditingController _locationController = TextEditingController(text: SharedData.location);
  final TextEditingController _emailController = TextEditingController(text: SharedData.email);
  final TextEditingController _phoneController = TextEditingController(text: SharedData.phone);
  final TextEditingController _summaryController = TextEditingController(text: SharedData.summary);
  
  List<Map<String, TextEditingController>> _expControllers = [];
  List<Map<String, TextEditingController>> _eduControllers = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi minimal 1 form jika data kosong
    _addExperienceField();
    _addEducationField();
  }

  void _addExperienceField() {
    setState(() {
      _expControllers.add({
        "title": TextEditingController(),
        "company": TextEditingController(),
        "year": TextEditingController(),
        "description": TextEditingController(),
      });
    });
  }

  void _addEducationField() {
    setState(() {
      _eduControllers.add({
        "degree": TextEditingController(),
        "school": TextEditingController(),
        "year": TextEditingController(),
      });
    });
  }

  Widget _buildFormField({required TextEditingController controller, required String label, String hint = "", int maxLines = 1, TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.blue.withOpacity(0.03),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text("CV Editor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildFormSection(
              title: "Kontak",
              icon: Icons.contact_mail_rounded,
              children: [
                _buildFormField(controller: _locationController, label: "Lokasi"),
                _buildFormField(controller: _emailController, label: "Email", type: TextInputType.emailAddress),
                _buildFormField(controller: _phoneController, label: "No. HP", type: TextInputType.phone),
              ],
            ),

            _buildFormSection(
              title: "Tentang Saya",
              icon: Icons.person_search_rounded,
              children: [
                _buildFormField(controller: _summaryController, label: "Summary", maxLines: 3),
              ],
            ),

            // --- PENGALAMAN KERJA ---
            _buildDynamicSection(
              title: "Pengalaman Kerja",
              icon: Icons.work_history_rounded,
              controllers: _expControllers,
              onAdd: _addExperienceField,
              buildFields: (index) => [
                _buildFormField(controller: _expControllers[index]["title"]!, label: "Posisi"),
                _buildFormField(controller: _expControllers[index]["company"]!, label: "Perusahaan"),
                _buildFormField(controller: _expControllers[index]["year"]!, label: "Tahun"),
                _buildFormField(controller: _expControllers[index]["description"]!, label: "Deskripsi", maxLines: 2),
              ],
              onRemove: (index) => setState(() => _expControllers.removeAt(index)),
            ),

            const SizedBox(height: 20),

            // --- PENDIDIKAN (BARIAN YANG HILANG) ---
            _buildDynamicSection(
              title: "Pendidikan",
              icon: Icons.school_rounded,
              controllers: _eduControllers,
              onAdd: _addEducationField,
              buildFields: (index) => [
                _buildFormField(controller: _eduControllers[index]["degree"]!, label: "Gelar / Jurusan"),
                _buildFormField(controller: _eduControllers[index]["school"]!, label: "Sekolah / Universitas"),
                _buildFormField(controller: _eduControllers[index]["year"]!, label: "Tahun"),
              ],
              onRemove: (index) => setState(() => _eduControllers.removeAt(index)),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL SIMPAN (DENGAN ALERT DIALOG) ---
            ElevatedButton(
              onPressed: () {
                SimpleAlertDialog.show(
                  context,
                  assetImagepath: AnimatedImage.confirm,
                  buttonsColor: Colors.blueAccent,
                  title: AlertTitleText("Simpan Data?"),
                  content: AlertContentText("Data CV kamu akan diperbarui."),
                  onConfirmButtonPressed: (ctx) {
                    setState(() {
                      SharedData.location = _locationController.text;
                      SharedData.email = _emailController.text;
                      SharedData.phone = _phoneController.text;
                      SharedData.summary = _summaryController.text;
                      
                      SharedData.experiences.clear();
                      for (var exp in _expControllers) {
                        if (exp["title"]!.text.isNotEmpty) {
                          SharedData.experiences.add({
                            "title": exp["title"]!.text,
                            "company": exp["company"]!.text,
                            "year": exp["year"]!.text,
                            "description": exp["description"]!.text,
                          });
                        }
                      }

                      SharedData.educations.clear();
                      for (var edu in _eduControllers) {
                        if (edu["degree"]!.text.isNotEmpty) {
                          SharedData.educations.add({
                            "degree": edu["degree"]!.text,
                            "school": edu["school"]!.text,
                            "year": edu["year"]!.text,
                          });
                        }
                      }
                    });
                    Navigator.pop(ctx);
                    CherryToast.success(title: const Text("Berhasil disimpan!")).show(context);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // --- TOMBOL HAPUS (DENGAN ALERT DIALOG) ---
            OutlinedButton(
              onPressed: () {
                SimpleAlertDialog.show(
                  context,
                  assetImagepath: AnimatedImage.warning,
                  buttonsColor: Colors.redAccent,
                  title: AlertTitleText("Hapus Semua?"),
                  content: AlertContentText("Semua data di form dan profile akan dikosongkan."),
                  onConfirmButtonPressed: (ctx) {
                    setState(() {
                      SharedData.summary = "";
                      SharedData.experiences.clear();
                      SharedData.educations.clear();
                      _expControllers.clear(); _addExperienceField();
                      _eduControllers.clear(); _addEducationField();
                      _summaryController.clear();
                    });
                    Navigator.pop(ctx);
                    CherryToast.error(title: const Text("Data telah dikosongkan.")).show(context);
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("KOSONGKAN SEMUA DATA", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: Colors.blueAccent, size: 20), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDynamicSection({required String title, required IconData icon, required List controllers, required VoidCallback onAdd, required List<Widget> Function(int) buildFields, required Function(int) onRemove}) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [Icon(icon, color: Colors.blueAccent), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          TextButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text("Tambah")),
        ]),
        const SizedBox(height: 10),
        ...List.generate(controllers.length, (index) => Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
          child: Column(children: [
            if(index > 0) Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => onRemove(index))),
            ...buildFields(index),
          ]),
        )),
      ],
    );
  }
}