import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/teacher_provider.dart';
import '../../requestmodel/add_teacher_request.dart';
import '../../services/teacher_api_service.dart';
import '../../widgets/profile_image_picker_sheet.dart';

class AddTeacherScreen extends ConsumerStatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  ConsumerState<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends ConsumerState<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  //final service = TeacherApiService();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _qualificationCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  // Dropdown State
  String? selectedGender;
  String? selectedExperience;
  String? selectedSubject;
  String? selectedClass;

  File? _profileImageFile;
  String? _profileBase64;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qualificationCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Teacher"),
      ),

      // Fixed Save Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _onSave,
              child: const Text(
                "SAVE TEACHER",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _onChangeProfileImage(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageFile != null
                        ? FileImage(_profileImageFile!)
                        : const AssetImage('assets/images/default_user.png')
                    as ImageProvider,
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.camera_alt, size: 18),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle("Personal Information"),
              _inputField("Teacher Name", controller: _nameCtrl),
              _dropdownField(
                "Gender",
                ["Male", "Female"],
                selectedGender,
                    (val) => setState(() => selectedGender = val),
              ),

              const SizedBox(height: 20),

              _sectionTitle("Professional Details"),
              _inputField("Qualification", controller: _qualificationCtrl),
              _dropdownField(
                "Experience",
                ["0-2 Years", "3-5 Years", "5+ Years"],
                selectedExperience,
                    (val) => setState(() => selectedExperience = val),
              ),

              const SizedBox(height: 20),

              _sectionTitle("Subjects & Classes"),
              _dropdownField(
                "Subject",
                ["Math", "English", "Hindi", "Physics", "Chemistry"],
                selectedSubject,
                    (val) => setState(() => selectedSubject = val),
              ),
              _dropdownField(
                "Class Assigned",
                ["1", "2", "3", "4", "5"],
                selectedClass,
                    (val) => setState(() => selectedClass = val),
              ),

              const SizedBox(height: 20),

              _sectionTitle("Contact Details"),
              _inputField(
                "Mobile Number",
                controller: _mobileCtrl,
                keyboard: TextInputType.phone,
              ),
              _inputField(
                "Email",
                controller: _emailCtrl,
                keyboard: TextInputType.emailAddress,
              ),
              _inputField("Address", controller: _addressCtrl),
            ],
          ),
        ),
      ),
    );
  }
  void _onChangeProfileImage(BuildContext context) {
    showProfileImagePickerSheet(
      context: context,
      onImagePicked: (result) {
        setState(() {
          _profileImageFile = result.file;
          _profileBase64 = result.base64;
        });
        debugPrint('Base64Image $_profileBase64');
      },
    );
  }
  // ================= SAVE =================

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ref.read(teacherApiServiceProvider); // ✅ ref works

    try {
      _showLoading();

      final res = await service.addTeacher(
        AddTeacherRequest(
          teacherName: _nameCtrl.text.trim(),
          qualification: _qualificationCtrl.text.trim(),
          experience: selectedExperience ?? "0-2 Years",
          gender: selectedGender ?? "Male",
          mobile: _mobileCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: "123456",
          address: _addressCtrl.text.trim(),
          classes: ["1"],
          subjects: ["Math"],
          assignedClasses: ["1A"],
          imageBase64: _profileBase64 ?? "",
        ),
      );

      if (mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher Added Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError(e.toString());
    }
  }

  // ================= UI HELPERS =================

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputField(
      String label, {
        TextEditingController? controller,
        IconData? icon,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _dropdownField(
      String label,
      List<String> items,
      String? value,
      Function(String?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? "Required" : null,
      ),
    );
  }
}
