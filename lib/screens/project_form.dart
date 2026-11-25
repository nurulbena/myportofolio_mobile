import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _techStack = TextEditingController();
  final _projectUrl = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _techStack,
      _projectUrl,
      _imageUrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _deco(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint ?? label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final api = context.read<ApiClient>();
    final auth = context.read<AuthState>();
    final messenger = ScaffoldMessenger.of(context);

    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;
    final token = auth.token;
    if (token == null) return;

    setState(() {
      _isSubmitting = true;
    });

    final newProject = Project(
      title: _title.text.trim(),
      description: _description.text.trim(),
      techStack: _techStack.text.trim(),
      projectUrl: _projectUrl.text.trim(),
      projectImageUrl: _imageUrl.text.trim(),
    );

    try {
      final created = await api.createProject(newProject, token: token);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Project created!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${created.title}'),
                Text('Description: ${created.description}'),
                Text('Tech Stack: ${created.techStack}'),
                Text('Project URL: ${created.projectUrl}'),
                if (created.projectImageUrl.isNotEmpty)
                  Text('Image URL: ${created.projectImageUrl}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      for (final c in [
        _title,
        _description,
        _techStack,
        _projectUrl,
        _imageUrl,
      ]) {
        c.clear();
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await auth.logout();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
          ),
        );
        if (!mounted) return;
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Only the portfolio owner can add projects.'),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to save project (${e.statusCode}).')),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Cannot reach the server.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Project Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _title,
                  decoration: _deco('Title'),
                  validator: (value) =>
                      _requiredValidator(value, 'Title cannot be empty!'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _description,
                  maxLines: 5,
                  decoration: _deco('Description'),
                  validator: (value) =>
                      _requiredValidator(value, 'Description cannot be empty!'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _techStack,
                  decoration: _deco(
                    'Tech Stack',
                    hint: 'e.g. Flutter, Django, PostgreSQL',
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'Tech stack cannot be empty!'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _projectUrl,
                  keyboardType: TextInputType.url,
                  decoration: _deco(
                    'Project URL',
                    hint: 'https://github.com/...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Project URL cannot be empty!';
                    }
                    if (!_isValidUrl(value.trim())) {
                      return 'Enter a valid URL (http:// or https://).';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _imageUrl,
                  keyboardType: TextInputType.url,
                  decoration: _deco(
                    'Project Image URL (Optional)',
                    hint: 'https://example.com/image.png',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!_isValidUrl(value.trim())) {
                      return 'Enter a valid URL (http:// or https://).';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
