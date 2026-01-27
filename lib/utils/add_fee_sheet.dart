import 'package:flutter/material.dart';

class AddFeeSheet extends StatefulWidget {
  const AddFeeSheet();

  @override
  State<AddFeeSheet> createState() => _AddFeeSheetState();
}

class _AddFeeSheetState extends State<AddFeeSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),

      /*  padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),*/
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Add Fee Head",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _input("Fee Title"),
            _input("Amount", keyboard: TextInputType.number),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Frequency",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                DropdownMenuItem(value: "Yearly", child: Text("Yearly")),
              ],
              onChanged: (_) {},
              validator: (v) => v == null ? "Required" : null,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Fee Added Successfully")),
                    );
                  }
                },
                child: const Text("SAVE"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }
}
