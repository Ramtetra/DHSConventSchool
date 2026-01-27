import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),

      body: SingleChildScrollView(
       // padding: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 👤 STUDENT AVATAR
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person, size: 40, color: theme.primaryColor),
                ),
              ),

              const SizedBox(height: 24),

              // 📌 STUDENT INFO
              _sectionTitle("Student Information"),

              _inputField("Student Name"),
              _dropdownField("Gender", ["Male", "Female"]),
              _inputField("Date of Birth", icon: Icons.calendar_today),

              const SizedBox(height: 20),

              // 🎓 ACADEMIC INFO
              _sectionTitle("Academic Details"),

              Row(
                children: [
                  Expanded(child: _dropdownField("Class", ["1", "2", "3", "4"])),
                  const SizedBox(width: 12),
                  Expanded(child: _dropdownField("Section", ["A", "B", "C"])),
                ],
              ),

              _inputField("Roll Number"),

              const SizedBox(height: 20),

              // 👪 PARENT INFO
              _sectionTitle("Parent Information"),

              _inputField("Parent Name"),
              _inputField("Mobile Number", keyboard: TextInputType.phone),
              _inputField("Email", keyboard: TextInputType.emailAddress),

              const SizedBox(height: 32),

              // 💾 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Student Added Successfully")),
                      );
                    }
                  },
                  child: const Text(
                    "SAVE STUDENT",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SECTION TITLE
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

  // 🔹 INPUT FIELD
  Widget _inputField(
      String label, {
        IconData? icon,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
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

  // 🔹 DROPDOWN FIELD
  Widget _dropdownField(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (_) {},
        validator: (value) => value == null ? "Required" : null,
      ),
    );
  }
}
