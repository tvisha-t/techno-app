import 'package:flutter/material.dart';

// incident reports
// form collects date, location, type of incident, & description
// todo: wire up submit button to send data to a database?? trigger push notif to users w/ pinned city
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedType;
  bool _submitted = false; // submitted form? for success method

  final List<String> _incidentTypes = [
    'assault',
    'robbery',
    'theft',
    'harassment',
    'vandalism',
    'suspicious activity',
    'other... ',
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    // make sure they actually filled in everything
    if (_selectedDate == null || _locationController.text.isEmpty || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('whoops - you are missing some required info!!')),
      );
      return;
    }

// todo: HERE is where we send form data to backend i think
// we want to send 
    // _selectedDate, _locationController.text, _selectedType, and _detailsController.text

    setState(() => _submitted = true);
  }

  void _reset() {
    setState(() {
      _submitted = false;
      _selectedDate = null;
      _selectedType = null;
      _locationController.clear();
      _detailsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B2D8E),
        title: const Text('report an incident', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey[100],
      body: _submitted ? _buildSuccessView() : _buildForm(),
    );
  }

  // ── success screen ────────────────────────
  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'report submitted',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'thanks for helping keep your community safe! we will let users in the area know',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B2D8E),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('submit again', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // ── da big bad form ─────────────────────────────────────────────
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'please report what youe experienced to keep others safe...',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // ── date picker field ──────────────────────────────
          _fieldLabel('date *'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF5B2D8E)),
                  const SizedBox(width: 12),
                  Text(
                    // Show chosen date or a prompt
                    _selectedDate != null
                        ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}'
                        : 'choose a date',
                    style: TextStyle(
                      color: _selectedDate != null ? Colors.black : Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

           // ── location text field ────────────────────────────
          _fieldLabel('location  *'),
          _styledTextField(
            controller: _locationController,
            hint: 'e.g. Main St & 5th Ave, Minneapolis',
            icon: Icons.location_on,
          ),
          const SizedBox(height: 16),
 
          // ── Incident type dropdown ─────────────────────────
          _fieldLabel('type of incident *'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                hint: const Text('choose incident type', style: TextStyle(color: Colors.grey)),
                isExpanded: true,
                items: _incidentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (val) => setState(() => _selectedType = val),
              ),
            ),
          ),
          const SizedBox(height: 16),
 
          // ── Details text area ──────────────────────────────
          _fieldLabel('details'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: TextField(
              controller: _detailsController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe what happened (optional but helpful)...',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none, 
              ),
            ),
          ),
          const SizedBox(height: 32),
 
          // ── submit button ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B2D8E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _styledTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF5B2D8E)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}