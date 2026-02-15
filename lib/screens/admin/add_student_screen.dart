import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../requestmodel/student_request_model.dart';
import '../../utils/app_date_picker.dart';
import '../../providers/student_provider.dart';
import '../../widgets/profile_image_picker_sheet.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState
    extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Controllers (MOVED OUTSIDE BUILD)
  final nameController = TextEditingController();
  final parentController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  String? gender;
  String? selectedClass;
  String? selectedSection;
  String? _profileBase64;
  File? _profileImageFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final studentState = ref.watch(addStudentProvider);

    /// ✅ Listen for success / error
    ref.listen(addStudentProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data != null && data.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data.message)),
            );
            _formKey.currentState!.reset();
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👤 Avatar
              Center(
                child: GestureDetector(
                  onTap: () => _onChangeProfileImage(context),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageFile != null
                        ? FileImage(_profileImageFile!)
                        : const AssetImage('assets/images/user.png')
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

              _sectionTitle("Student Information"),

              _inputField("Student Name",
                  controller: nameController),

              _dropdownField("Gender", ["Male", "Female"],
                  onChanged: (val) => gender = val),

              /// ✅ Date Picker
              TextFormField(
                controller: dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  prefixIcon:
                  const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
                onTap: () async {
                  final selectedDate =
                  await AppDatePicker.pickDate(
                    context: context,
                    format: "yyyy-MM-dd",
                  );

                  if (selectedDate != null) {
                    dobController.text = selectedDate;
                  }
                },
              ),

              const SizedBox(height: 20),
              _sectionTitle("Academic Details"),

              Row(
                children: [
                  Expanded(
                    child: _dropdownField(
                        "Class", ["1", "2", "3", "4"],
                        onChanged: (val) =>
                        selectedClass = val),),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _dropdownField(
                        "Section", ["A", "B", "C"],
                        onChanged: (val) =>
                        selectedSection = val),),],),
              const SizedBox(width: 10),
              _sectionTitle("Parent Information"),

              _inputField("Parent Name",
                  controller: parentController),

              _inputField("Mobile Number",
                  controller: mobileController,
                  keyboard: TextInputType.phone),

              _inputField("Email",
                  controller: emailController,
                  keyboard:
                  TextInputType.emailAddress),

              _inputField("Password",
                  controller: passwordController,
                  keyboard:
                  TextInputType.visiblePassword),
              _inputField("Address",
                  controller: addressController),
              const SizedBox(height: 32),
              /// ✅ SAVE BUTTON (Connected to API)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: studentState.isLoading
                      ? null
                      : () {
                    if (_formKey.currentState!
                        .validate()) {
                      final model =
                      StudentRequestModel(
                        studentName:
                        nameController.text,
                        parentName:
                        parentController.text,
                        dob: dobController.text,
                        gender: gender ?? "Male",
                        mobile: mobileController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        address: addressController.text,
                        classes: [selectedClass ?? "1"],
                        section: [selectedSection ?? "A"],
                        imageBase64: _profileBase64 ?? "",);
                      ref.read(addStudentProvider.notifier).addStudent(model);
                    }
                  },
                  child: studentState.isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text(
                    "SAVE STUDENT",
                    style:
                    TextStyle(fontSize: 16),
                  ),
                ),
              ),
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
  /// 🔹 Section Title
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

  /// 🔹 Input Field
  Widget _inputField(String label,
      {required TextEditingController controller,
        TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty
            ? "Required"
            : null,
      ),
    );
  }

  /// 🔹 Dropdown Field
  Widget _dropdownField(
      String label, List<String> items,
      {required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
        items: items
            .map((e) =>
            DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
        value == null ? "Required" : null,
      ),
    );
  }
}
