import 'package:businesstrack/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:businesstrack/features/messaging/presentation/pages/conversation_page.dart';
import 'package:businesstrack/features/messaging/domain/usecases/messaging_usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingPage extends ConsumerStatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends ConsumerState<MessagingPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isCheckingUser = false;
  bool _userNotFound = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showNewConversationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('💬 ', style: TextStyle(fontSize: 24)),
            const Text('New Conversation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recipient Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'supplier@example.com',
                border: const OutlineInputBorder(),
                errorText: _userNotFound ? _errorMessage : null,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                if (_userNotFound) {
                  setState(() {
                    _userNotFound = false;
                    _errorMessage = '';
                  });
                }
              },
            ),
            if (_userNotFound)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _emailController.clear();
              setState(() {
                _userNotFound = false;
                _errorMessage = '';
              });
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isCheckingUser ? null : _startNewConversation,
            child: _isCheckingUser
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  Future<void> _startNewConversation() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _userNotFound = true;
        _errorMessage = 'Please enter an email';
      });
      return;
    }

    setState(() {
      _isCheckingUser = true;
      _userNotFound = false;
    });

    try {
      // Check if user exists
      final checkUserUsecase = ref.read(checkUserExistsUsecaseProvider);
      final checkResult = await checkUserUsecase.call(email);

      await checkResult.fold(
        (failure) async {
          setState(() {
            _userNotFound = true;
            _errorMessage = failure.message;
            _isCheckingUser = false;
          });
        },
        (exists) async {
          if (!exists) {
            setState(() {
              _userNotFound = true;
              _errorMessage = '$email is not registered in the app';
              _isCheckingUser = false;
            });
            return;
          }

          // Create or get conversation
          final getOrCreateUsecase = ref.read(
            getOrCreateConversationUsecaseProvider,
          );
          final result = await getOrCreateUsecase.call(email);

          result.fold(
            (failure) {
              setState(() {
                _userNotFound = true;
                _errorMessage = failure.message;
                _isCheckingUser = false;
              });
            },
            (conversation) {
              Navigator.pop(context);
              _emailController.clear();
              setState(() {
                _isCheckingUser = false;
                _userNotFound = false;
              });

              // Navigate to conversation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationPage(
                    conversationId: conversation.conversationId,
                    receiverName: conversation.otherUserName,
                    receiverId: conversation.otherUserId,
                  ),
                ),
              ).then((_) {
                // Refresh conversations list
                ref.invalidate(conversationsListProvider);
              });
            },
          );
        },
      );
    } catch (e) {
      setState(() {
        _userNotFound = true;
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isCheckingUser = false;
      });
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationsList = ref.watch(conversationsListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Stay connected', style: TextStyle(fontSize: 12)),
          ],
        ),
        elevation: 2,
      ),
      body: conversationsList.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 80,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a new conversation to begin messaging',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    (conversation.otherUserName.isNotEmpty
                            ? conversation.otherUserName[0]
                            : 'U')
                        .toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  conversation.otherUserName.isNotEmpty
                      ? conversation.otherUserName
                      : 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  conversation.lastMessage ?? 'No messages',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conversation.unread == true
                        ? theme.textTheme.bodyMedium?.color
                        : theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontWeight: conversation.unread == true
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(conversation.lastMessageTime),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                    if (conversation.unread == true) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationPage(
                        conversationId: conversation.conversationId,
                        receiverName: conversation.otherUserName,
                        receiverId: conversation.otherUserId,
                      ),
                    ),
                  ).then((_) {
                    // Refresh conversations list when returning
                    ref.invalidate(conversationsListProvider);
                  });
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(conversationsListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewConversationDialog,
        tooltip: 'New Message',
        child: const Icon(Icons.add),
      ),
    );
  }
}
