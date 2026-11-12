import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../services/ai_service.dart';

class AiBusinessCoachScreen extends StatefulWidget {
  const AiBusinessCoachScreen({super.key});

  @override
  State<AiBusinessCoachScreen> createState() => _AiBusinessCoachScreenState();
}

class _AiBusinessCoachScreenState extends State<AiBusinessCoachScreen> {
  final AiService _aiService = AiService();

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];

  bool _isThinking = false;

  final List<String> _suggestions = [
    'Improve my business idea',
    'Help me with marketing',
    'How should I price my product?',
    'Help me create a business plan',
    'How can I find customers?',
    'How do I prepare for funding?',
  ];

  @override
  void initState() {
    super.initState();

    _messages.add(
      const ChatMessage(
        message:
            'Hello! 👋 I am your Rural Spark AI Business Coach.\n\n'
            'I can help you with your business idea, customers, '
            'marketing, pricing, business planning, funding preparation '
            'and business growth.\n\n'
            'What would you like help with?',
        isUser: false,
      ),
    );
  }

  Future<void> _sendMessage([String? suggestedMessage]) async {
    if (_isThinking) return;

    final text = suggestedMessage ?? _controller.text.trim();

    if (text.isEmpty) return;

    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(message: text, isUser: true));

      _isThinking = true;
    });

    _scrollToBottom();

    try {
      final response = await _aiService.sendMessage(text);

      if (!mounted) return;

      setState(() {
        _messages.add(ChatMessage(message: response, isUser: false));
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          ChatMessage(
            message:
                'Sorry, I could not respond right now.\n\n'
                '$error',
            isUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isThinking = false;
        });

        _scrollToBottom();
      }
    }
  }

  void _startNewChat() {
    _aiService.startNewConversation();

    setState(() {
      _messages.clear();

      _messages.add(
        const ChatMessage(
          message:
              'New conversation started. 🌱\n\n'
              'Tell me what you would like help with.',
          isUser: false,
        ),
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
    return Scaffold(
      backgroundColor: AppColors.veryLightGreen,
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightGreen,
              child: Icon(Icons.auto_awesome, color: AppColors.darkGreen),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Business Coach',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Your Rural Spark assistant',
                  style: TextStyle(fontSize: 11, color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'New conversation',
            onPressed: _startNewChat,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isThinking && index == _messages.length) {
                  return const ThinkingBubble();
                }

                return MessageBubble(message: _messages[index]);
              },
            ),
          ),

          if (_messages.length == 1)
            SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: AppColors.lightGreen,
                      side: BorderSide.none,
                      avatar: const Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: AppColors.darkGreen,
                      ),
                      label: Text(suggestion),
                      onPressed: () => _sendMessage(suggestion),
                    ),
                  );
                },
              ),
            ),

          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Ask your business coach...',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(52, 52),
                    ),
                    onPressed: _isThinking ? null : () => _sendMessage(),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 650),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: message.isError
              ? const Color(0xFFFFEBEE)
              : message.isUser
              ? AppColors.darkGreen
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: message.isUser
              ? null
              : Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: SelectableText(
          message.message,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.black,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class ThinkingBubble extends StatelessWidget {
  const ThinkingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Coach is thinking...',
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final bool isError;

  const ChatMessage({
    required this.message,
    required this.isUser,
    this.isError = false,
  });
}
