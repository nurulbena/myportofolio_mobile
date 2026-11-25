import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  Future<void> _onTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final auth = context.read<AuthState>();
    messenger.hideCurrentSnackBar();

    switch (item.name) {
      case 'Lihat Proyek':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProjectListScreen()),
        );
      case 'Tambah Proyek':
        final loggedIn = await ensureLoggedIn(context);
        if (!context.mounted || !loggedIn) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProjectFormPage()),
        );
      case 'Tambah Pengalaman':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExperienceFormPage()),
        );
      case 'Logout':
        if (auth.isLoggedIn) {
          await auth.logout();
          messenger.showSnackBar(
            const SnackBar(content: Text('You have been logged out.')),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text('You are not logged in.')),
          );
        }
      default:
        messenger.showSnackBar(
          SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
