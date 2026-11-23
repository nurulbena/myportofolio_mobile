import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _position = TextEditingController();
  final _start = TextEditingController();
  final _end = TextEditingController();
  final _desc = TextEditingController();
  final _link = TextEditingController();

  @override
  void dispose() {
    for (final c in [_company, _position, _start, _end, _desc, _link]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text = picked.toIso8601String().substring(0, 10); // yyyy-MM-dd
    }
  }

  // --- Validator ---
  String? _required(String? v, String label, {int max = 100}) {
    if (v == null || v.trim().isEmpty) return '$label tidak boleh kosong!';
    if (v.trim().length > max) return '$label maksimal $max karakter!';
    return null;
  }

  String? _validateEnd(String? v) {
    if (v == null || v.isEmpty) return 'Tanggal selesai wajib dipilih!';
    if (_start.text.isNotEmpty &&
        DateTime.parse(v).isBefore(DateTime.parse(_start.text))) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }

  String? _validateUrl(String? v) {
    if (v == null || v.trim().isEmpty) return null; // opsional
    final uri = Uri.tryParse(v.trim());
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return 'URL harus diawali http:// atau https://';
    }
    return null;
  }

  // --- Builder field biar gak ngulang-ngulang ---
  Widget _field(
    TextEditingController ctrl,
    String label, {
    required String? Function(String?) validator,
    int maxLines = 1,
    bool isDate = false,
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        readOnly: isDate,
        onTap: isDate ? () => _pickDate(ctrl) : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: isDate ? const Icon(Icons.calendar_today) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        validator: validator,
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengalaman berhasil disimpan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Perusahaan: ${_company.text.trim()}'),
              Text('Posisi: ${_position.text.trim()}'),
              Text('Mulai: ${_start.text}'),
              Text('Selesai: ${_end.text}'),
              Text('Deskripsi: ${_desc.text.trim()}'),
              Text('Tautan: ${_link.text.trim()}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Tutup'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field(_company, 'Nama Perusahaan',
                  validator: (v) => _required(v, 'Nama perusahaan')),
              _field(_position, 'Posisi',
                  validator: (v) => _required(v, 'Posisi')),
              _field(_start, 'Tanggal Mulai',
                  isDate: true,
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Tanggal mulai wajib dipilih!'
                      : null),
              _field(_end, 'Tanggal Selesai',
                  isDate: true, validator: _validateEnd),
              _field(_desc, 'Deskripsi',
                  maxLines: 5,
                  validator: (v) => _required(v, 'Deskripsi', max: 300)),
              _field(_link, 'Tautan (opsional)',
                  keyboard: TextInputType.url, validator: _validateUrl),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.indigo),
                  ),
                  onPressed: _save,
                  child: const Text('Simpan',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}