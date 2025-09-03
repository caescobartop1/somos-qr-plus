import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderNavigation extends StatelessWidget {
  final Widget child;
  
  const ProviderNavigation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SOMOS QR',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                fontFamily: 'Helvetica Black',
                height: 1,
                shadows: [
                  Shadow(color: Colors.black, offset: Offset(0.5, 0), blurRadius: 0),
                  Shadow(color: Colors.black, offset: Offset(-0.5, 0), blurRadius: 0),
                  Shadow(color: Colors.black, offset: Offset(0, 0.5), blurRadius: 0),
                  Shadow(color: Colors.black, offset: Offset(0, -0.5), blurRadius: 0),
                ],
              ),
            ),
            const Icon(
              Icons.add,
              size: 24,
              color: Colors.black,
            ),
          ],
        ),
      ),
      drawer: NavigationDrawer(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 3,
                    ),
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/SOMOS QR+ logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SOMOS QR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                        letterSpacing: -1.2,
                        fontFamily: 'Helvetica',
                        height: 1,
                        shadows: [
                          Shadow(color: Colors.white.withOpacity(0.3), offset: Offset(0.5, 0), blurRadius: 0),
                          Shadow(color: Colors.white.withOpacity(0.3), offset: Offset(-0.5, 0), blurRadius: 0),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              context.go('/quality-scorecards');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('My Patients'),
            onTap: () {
              Navigator.pop(context);
              context.go('/provider/patients');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Quality Score Cards'),
            onTap: () {
              Navigator.pop(context);
              context.go('/provider/quality-scorecards');
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('Reports'),
            onTap: () {
              Navigator.pop(context);
              context.go('/provider/reports');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Resources'),
            onTap: () {
              Navigator.pop(context);
              context.go('/provider/resources');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go('/provider/settings');
            },
          ),
        ],
      ),
      body: child,
    );
  }
} 