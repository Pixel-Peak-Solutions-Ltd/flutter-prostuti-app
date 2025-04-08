import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/core/configs/app_colors.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/features/chat/viewmodel/chat_viewmodel.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String conversationId;
  final String recipientId;
  final Function(String) onSendMessage;

  const ChatInputField({
    Key? key,
    required this.conversationId,
    required this.recipientId,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  final TextEditingController _messageController = TextEditingController();
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_messageController.text.isNotEmpty && !_isTyping) {
      _isTyping = true;
      final messagesNotifier = ref.read(
        chatMessagesNotifierProvider(widget.conversationId).notifier,
      );
      messagesNotifier.sendTypingIndicator(widget.conversationId);
    }

    // Reset the timer
    if (_typingTimer?.isActive ?? false) {
      _typingTimer!.cancel();
    }

    // Schedule a timer to stop typing after 1.5 seconds of inactivity
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isTyping) {
        _isTyping = false;
        final messagesNotifier = ref.read(
          chatMessagesNotifierProvider(widget.conversationId).notifier,
        );
        messagesNotifier.sendStopTypingIndicator(widget.conversationId);
      }
    });
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    widget.onSendMessage(message);
    _messageController.clear();

    // Stop typing indicator
    if (_isTyping) {
      _isTyping = false;
      final messagesNotifier = ref.read(
        chatMessagesNotifierProvider(widget.conversationId).notifier,
      );
      messagesNotifier.sendStopTypingIndicator(widget.conversationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.backgroundSecondaryDark
                    : AppColors.backgroundPrimaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.borderNormalLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: context.l10n?.typeMessage ?? 'Type a message...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.backgroundActionPrimaryLight,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _handleSendMessage,
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
