import 'package:flutter/material.dart';

import '../models/quote.dart';
import '../services/quote_api_service.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuoteApiService _quoteApiService = QuoteApiService();
  final List<Quote> _history = [];
  Quote? _myBest;
  Quote? _candidateQuote;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCandidateQuote();
  }

  Future<void> _loadCandidateQuote() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _candidateQuote = await _quoteApiService.fetchRandomQuote();
    } catch (e) {
      _errorMessage = e.toString();
      _candidateQuote = null;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _chooseCandidateAsBest() {
    if (_candidateQuote == null) {
      return;
    }

    setState(() {
      _myBest = _candidateQuote;
      _history.add(_candidateQuote!);
    });

    _loadCandidateQuote();
  }

  void _keepCurrentBest() {
    _loadCandidateQuote();
  }

  Widget _buildBestSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'マイベスト',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_myBest == null)
          const Text('まだマイベストが設定されていません。')
        else
          QuoteCard(
            quote: _myBest!,
            onTap: () {},
          ),
      ],
    );
  }

  Widget _buildCandidateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '新しい名言',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_candidateQuote == null)
          const Text('名言を読み込めませんでした。')
        else
          QuoteCard(
            quote: _candidateQuote!,
            onTap: _chooseCandidateAsBest,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Q-1 グランプリ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue[500],
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'マイベスト一覧',
            onPressed: () {
              Navigator.pushNamed(context, '/history', arguments: _history);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading) ...[
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ] else if (_errorMessage != null) ...[
              Expanded(
                child: Center(child: Text(_errorMessage!)),
              ),
              ElevatedButton(
                onPressed: _loadCandidateQuote,
                child: const Text('再読み込み'),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBestSection(context),
                    const SizedBox(height: 24),
                    _buildCandidateSection(context),
                    const SizedBox(height: 24),
                    const Text(
                      '新しい名言がより良い場合は「マイベストにする」を押してください。',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 80,
                child: ElevatedButton(
                  onPressed: _chooseCandidateAsBest,
                  child: const Text(
                    'マイベストにする',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 80,
                child: ElevatedButton(
                  onPressed: _keepCurrentBest,
                  child: const Text(
                    '現状のマイベストを維持する',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),const SizedBox(height: 70),
            ],
          ],
        ),
      ),
    );
  }
}
