import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTeacherScreen extends ConsumerStatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  ConsumerState<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends ConsumerState<AddTeacherScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Teacher"),
      ),

      // ✅ FIXED SAVE BUTTON (never hides)
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

      // ✅ ONLY FORM SCROLLS
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 👤 Avatar
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person, size: 40, color: theme.primaryColor),
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle("Personal Information"),
              _inputField("Teacher Name"),
              _dropdownField("Gender", ["Male", "Female"]),
              _inputField("Date of Birth", icon: Icons.calendar_today),

              const SizedBox(height: 20),

              _sectionTitle("Professional Details"),
              _inputField("Employee ID"),
              _inputField("Qualification"),
              _dropdownField(
                "Experience",
                ["0-2 Years", "3-5 Years", "5+ Years"],
              ),

              const SizedBox(height: 20),

              _sectionTitle("Subjects & Classes"),
              _dropdownField(
                "Subject",
                ["Maths", "Science", "English", "Computer"],
              ),
              _dropdownField(
                "Class Assigned",
                ["1", "2", "3", "4", "5"],
              ),

              const SizedBox(height: 20),

              _sectionTitle("Contact Details"),
              _inputField(
                "Mobile Number",
                keyboard: TextInputType.phone,
              ),
              _inputField(
                "Email",
                keyboard: TextInputType.emailAddress,
              ),
              _inputField("Address"),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SAVE HANDLER (ready for API / provider)
  void _onSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher Added Successfully")),
      );

      // 👉 Later:
      // ref.read(addTeacherProvider.notifier).submit(data);
    }
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
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: (_) {},
        validator: (value) => value == null ? "Required" : null,
      ),
    );
  }
}
