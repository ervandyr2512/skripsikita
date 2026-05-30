import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../viewmodels/skripsibot_viewmodel.dart';

class SkripsiBotScreen extends StatefulWidget {
  const SkripsiBotScreen({super.key});

  @override
  State<SkripsiBotScreen> createState() => _SkripsiBotScreenState();
}

class _SkripsiBotScreenState extends State<SkripsiBotScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _quickPrompts = const [
    'Struktur BAB 1 yang baik?',
    'Bantu cari gap penelitian',
    'Tips manajemen waktu skripsi',
    'Bedanya metode kualitatif vs kuantitatif',
  ];

  void _send([String? text]) {
    final message = (text ?? _controller.text).trim();
    if (message.isEmpty) return;
    context.read<SkripsiBotViewModel>().sendMessage(message);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<SkripsiBotViewModel>().messages;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SkripsiBot',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                Text('AI Assistant • Online',
                    style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + 1,
              itemBuilder: (context, i) {
                if (i == messages.length) {
                  return _buildQuickPrompts();
                }
                final m = messages[i];
                return Align(
                  alignment: m.fromBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment:
                          m.fromBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: m.fromBot ? Colors.white : AppColors.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(m.fromBot ? 4 : 18),
                              bottomRight: Radius.circular(m.fromBot ? 18 : 4),
                            ),
                            border: m.fromBot
                                ? Border.all(color: AppColors.divider)
                                : null,
                          ),
                          child: Text(
                            m.content,
                            style: TextStyle(
                              color: m.fromBot ? AppColors.textPrimary : Colors.white,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            DateFormat('HH:mm').format(m.timestamp),
                            style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saran pertanyaan:',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPrompts
                .map((p) => InkWell(
                      onTap: () => _send(p),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          p,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'Tanya apa saja...',
                  filled: true,
                  fillColor: Color(0xFFF1F5F9),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _send,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
