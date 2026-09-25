import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _ChatLine {
  const _ChatLine({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatLine> _messages = [
    const _ChatLine(isUser: false, text: 'Hey explorer. I can help you navigate lore, compare characters, or find your next obsession.'),
  ];
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _controller.text).trim();
    if (text.isEmpty || _isTyping) return;
    _controller.clear();
    setState(() {
      _messages.add(_ChatLine(text: text, isUser: true));
      _isTyping = true;
    });
    _jumpToBottom();
    await Future<void>.delayed(const Duration(milliseconds: 760));
    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add(_ChatLine(isUser: false, text: 'Great question. I would start with the themes, the rivalries and the small details that reward a second watch. I can turn that into a spoiler-safe lore route for you next.'));
    });
    _jumpToBottom();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
        titleSpacing: 0,
        title: Row(children: [const FandomLogo(size: 34), const SizedBox(width: 10), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Verse Guide', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text('AI fan helper', style: TextStyle(fontSize: 11, color: AppColors.mint))])]),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) return const _TypingBubble();
                final line = _messages[index];
                return _MessageBubble(line: line);
              },
            ),
          ),
          if (_messages.length == 1 && !_isTyping)
            SizedBox(
              height: 42,
              child: ListView(
                padding: const EdgeInsets.only(left: 20, right: 20),
                scrollDirection: Axis.horizontal,
                children: [
                  _Prompt(text: 'Explain an anime ending', onTap: () => _send('Explain an anime ending')),
                  _Prompt(text: 'Find something like One Piece', onTap: () => _send('Find something like One Piece')),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'Ask the Verse Guide...', prefixIcon: Icon(Icons.auto_awesome_rounded)),
                    ),
                  ),
                  const SizedBox(width: 9),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(color: AppColors.lavender, shape: BoxShape.circle),
                    child: IconButton(onPressed: _isTyping ? null : () => _send(), icon: const Icon(Icons.arrow_upward_rounded, color: AppColors.ink)),
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.line});
  final _ChatLine line;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: line.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          mainAxisAlignment: line.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!line.isUser) ...[const FandomLogo(size: 27), const SizedBox(width: 8)],
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: line.isUser ? AppColors.lavender : AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(line.isUser ? 20 : 5),
                    bottomRight: Radius.circular(line.isUser ? 5 : 20),
                  ),
                  border: Border.all(color: line.isUser ? AppColors.lavender : AppColors.line),
                ),
                child: Text(line.text, style: TextStyle(color: line.isUser ? AppColors.ink : AppColors.text, height: 1.38)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FandomLogo(size: 27),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
          child: const SizedBox(width: 32, height: 15, child: LinearProgressIndicator(minHeight: 3, backgroundColor: AppColors.line, valueColor: AlwaysStoppedAnimation(AppColors.lavender))),
        ),
      ],
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: onTap,
        avatar: const Icon(Icons.auto_awesome_rounded, color: AppColors.lavender, size: 15),
        label: Text(text),
      ),
    );
  }
}
