import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prostuti/common/widgets/common_widgets/common_widgets.dart';
import 'package:prostuti/core/services/localization_service.dart';
import 'package:prostuti/core/services/nav.dart';
import 'package:prostuti/features/chat/viewmodel/broadcast_viewmodel.dart';
import 'package:prostuti/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:prostuti/features/chat/widgets/broadcast_item.dart';
import 'package:prostuti/features/chat/widgets/chat_connection_status.dart'; // New import
import 'package:prostuti/features/chat/widgets/conversation_item.dart';

import 'broadcast_view.dart';
import 'chat_message_view.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView>
    with SingleTickerProviderStateMixin, CommonWidgets {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
          _searchQuery = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.l10n?.searchHint ?? 'Search...',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                autofocus: true,
              )
            : Text(context.l10n?.chatTitle ?? 'Chat'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n?.activeBroadcasts ?? 'Active Conversations'),
            Tab(text: context.l10n?.pendingBroadcasts ?? 'Pending Questions'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Add connection status indicator at the top
          const ChatConnectionStatus(),

          // Main content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Conversations Tab
                ConversationsTab(searchQuery: _searchQuery),

                // Pending Broadcasts Tab
                BroadcastsTab(searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Nav().push(const CreateBroadcastView());
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}

// Tab for Active Conversations
class ConversationsTab extends ConsumerWidget {
  final String searchQuery;

  const ConversationsTab({Key? key, this.searchQuery = ''}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsNotifierProvider);

    return conversationsAsync.when(
      data: (conversations) {
        // Filter conversations based on search query
        final filteredConversations = searchQuery.isEmpty
            ? conversations
            : conversations.where((conversation) {
                final participantName =
                    conversation.participant?.name?.toLowerCase() ?? '';
                final lastMessage =
                    conversation.lastMessage?.message?.toLowerCase() ?? '';
                final subject = conversation.subject?.toLowerCase() ?? '';

                return participantName.contains(searchQuery) ||
                    lastMessage.contains(searchQuery) ||
                    subject.contains(searchQuery);
              }).toList();

        if (filteredConversations.isEmpty) {
          // Check if empty due to no conversations or due to filtering
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n?.noConversations ?? 'No conversations yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n?.startConversation ??
                        'Start by asking a question',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else {
            // Empty due to filtering
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n?.noSearchResults ??
                        'No matching conversations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: () => ref
              .read(conversationsNotifierProvider.notifier)
              .refreshConversations(),
          child: ListView.builder(
            itemCount: filteredConversations.length,
            itemBuilder: (context, index) {
              final conversation = filteredConversations[index];
              return ConversationItem(
                conversation: conversation,
                onTap: () {
                  Nav().push(
                    ChatMessageView(
                      conversationId: conversation.conversationId ?? '',
                      recipientId: conversation.acceptedBy ?? '',
                      recipientName:
                          conversation.participant?.name ?? 'Teacher',
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('${context.l10n?.error ?? 'Error'}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.refresh(conversationsNotifierProvider);
              },
              child: Text(context.l10n?.retry ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab for Pending Broadcasts
class BroadcastsTab extends ConsumerWidget {
  final String searchQuery;

  const BroadcastsTab({Key? key, this.searchQuery = ''}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastsAsync = ref.watch(broadcastNotifierProvider);

    return broadcastsAsync.when(
      data: (broadcasts) {
        // Filter broadcasts based on search query
        final filteredBroadcasts = searchQuery.isEmpty
            ? broadcasts
            : broadcasts.where((broadcast) {
                final message = broadcast.message?.toLowerCase() ?? '';
                final subject = broadcast.subject?.toLowerCase() ?? '';

                return message.contains(searchQuery) ||
                    subject.contains(searchQuery);
              }).toList();

        if (filteredBroadcasts.isEmpty) {
          // Check if empty due to no broadcasts or due to filtering
          if (broadcasts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.forum_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n?.noBroadcasts ?? 'No active requests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n?.createBroadcast ??
                        'Create a new question to get help',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Nav().push(const CreateBroadcastView());
                    },
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n?.askQuestion ?? 'Ask a Question'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Empty due to filtering
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n?.noSearchResults ?? 'No matching questions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(broadcastNotifierProvider.notifier).refreshBroadcasts(),
          child: ListView.builder(
            itemCount: filteredBroadcasts.length,
            itemBuilder: (context, index) {
              final broadcast = filteredBroadcasts[index];
              return BroadcastItem(
                broadcast: broadcast,
                onPressed: broadcast.status == 'accepted'
                    ? () {
                        Nav().push(
                          ChatMessageView(
                            conversationId: broadcast.conversationId ?? '',
                            recipientId: broadcast.acceptedBy ?? '',
                            recipientName: 'Teacher',
                          ),
                        );
                      }
                    : null,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('${context.l10n?.error ?? 'Error'}: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.refresh(broadcastNotifierProvider);
              },
              child: Text(context.l10n?.retry ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
