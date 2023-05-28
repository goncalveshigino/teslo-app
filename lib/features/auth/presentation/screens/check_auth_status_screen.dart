import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';




class CheckAuthStatusScreen extends ConsumerWidget {
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
