import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDebugWidget extends StatelessWidget {
  const AuthDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {        return Container(
          padding: const EdgeInsets.all(8),
          color: Colors.yellow.withValues(alpha: 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DEBUG AUTH STATUS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'User: ${snapshot.data?.email ?? 'Not logged in'}',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'UID: ${snapshot.data?.uid ?? 'null'}',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'Connection: ${snapshot.connectionState}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
