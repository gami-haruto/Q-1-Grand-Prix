import 'package:flutter/material.dart';

import '../models/quote.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.history});

  final List<Quote> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'マイベスト履歴',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: const Center(child: Text('まだ履歴はありません。')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'マイベスト履歴',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final quote = history[index];
            return ListTile(
              title: Text(quote.text),
              subtitle: quote.author.isNotEmpty ? Text(quote.author) : null,
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: history.length,
        ),
      ),
    );
  }
}
