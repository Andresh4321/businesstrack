# BusinessTrack Mobile App - Clean Architecture Implementation

## Overview

This document outlines the clean architecture implementation for the BusinessTrack Flutter mobile application, integrating messaging and user features with proper separation of concerns.

## Project Structure

### Features

The application is organized into multiple features, each following clean architecture principles:

```
lib/
├── features/
│   ├── messaging/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── messaging_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── message_api_model.dart
│   │   │   └── repositories/
│   │   │       └── messaging_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── message_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── messaging_repository.dart
│   │   │   └── usecases/
│   │   │       └── messaging_usecases.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── messaging_page.dart
│   │       │   └── conversation_page.dart
│   │       ├── providers/
│   │       │   └── messaging_providers.dart
│   │       └── widgets/
│   ├── users/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── user_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_api_model.dart
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── user_repository.dart
│   │   │   └── usecases/
│   │   │       └── user_usecases.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── user_profile_page.dart
│   │       │   ├── notifications_page.dart
│   │       │   └── ai_assistant_page.dart
│   │       ├── providers/
│   │       │   └── user_providers.dart
│   │       └── widgets/
│   └── [other features...]
└── core/
    ├── api/
    │   └── api_endpoints.dart
    ├── constants/
    │   └── app_constants.dart
    ├── error/
    │   ├── exceptions.dart
    │   └── failures.dart
    └── [other core utilities...]
```

## Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Core business objects (MessageEntity, UserEntity, etc.)
- **Repositories**: Abstract contracts for data access
- **Use Cases**: Application business rules and logic

### 2. **Data Layer** (Implementation)
- **Remote Data Sources**: API communication with the backend
- **Models**: Data transfer objects (API models)
- **Repositories**: Concrete implementations of domain repositories

### 3. **Presentation Layer** (UI)
- **Pages**: Full screen widgets
- **Widgets**: Reusable UI components
- **Providers**: Riverpod state management

## Features Implemented

### Messaging Feature

#### Entities
- `MessageEntity`: Represents a single message
- `ConversationEntity`: Represents a conversation between two users

#### Models
- `MessageApiModel`: Maps API responses to entities
- `ConversationApiModel`: Maps conversation data from API

#### Data Sources
- `MessagingRemoteDataSource`: Handles API calls to `/api/messages` endpoints
  - Check if user exists
  - Get or create conversations
  - Send messages
  - Get conversation messages
  - Get conversations list
  - Get unread message count
  - Get message notifications

#### Use Cases
- `CheckUserExistsUsecase`
- `GetOrCreateConversationUsecase`
- `SendMessageUsecase`
- `GetConversationUsecase`
- `GetConversationsListUsecase`
- `GetUnreadCountUsecase`
- `GetNotificationsUsecase`

#### Providers (Riverpod)
- `messagingRepositoryProvider`: Provides the messaging repository
- `conversationsListProvider`: FutureProvider for conversations list
- `unreadCountProvider`: FutureProvider for unread message count
- `messagesProvider`: FutureProvider.family for specific conversation messages
- `notificationsProvider`: FutureProvider for message notifications

### Users Feature

#### Entities
- `UserEntity`: User profile information
- `NotificationEntity`: Notification data (currently not used, notifications come from messaging)
- `AIAssistantEntity`: AI Assistant query and response history

#### Models
- `UserApiModel`: Maps user API responses
- `NotificationApiModel`: Maps notification data
- `AIAssistantApiModel`: Maps AI Assistant data

#### Data Sources
- `UserRemoteDataSource`: Handles API calls to `/api/auth` endpoints
  - Get user profile (`/api/auth/whoami`)
  - Update user profile (`/api/auth/profile`)
  - Query AI Assistant (stub for future implementation)
  - Get AI Assistant history (stub for future implementation)

#### Use Cases
- `GetUserProfileUsecase`
- `UpdateUserProfileUsecase`
- `QueryAIAssistantUsecase`
- `GetAIAssistantHistoryUsecase`

#### Providers (Riverpod)
- `userRepositoryProvider`: Provides the user repository
- `userProfileProvider`: FutureProvider for user profile
- `aiAssistantHistoryProvider`: FutureProvider for AI conversation history
- `aiAssistantQueryProvider`: FutureProvider.family for AI queries

## Backend Endpoints

### Messaging Endpoints (`/api/messages`)
- `POST /api/messages/check-user` - Check if user exists by email
- `POST /api/messages/conversation` - Get or create conversation
- `POST /api/messages/send` - Send a message
- `GET /api/messages/:conversationId` - Get messages from conversation
- `GET /api/messages/` - Get all conversations
- `GET /api/messages/count/unread` - Get unread message count
- `GET /api/messages/notifications/list` - Get message notifications

### User Endpoints (`/api/auth`)
- `GET /api/auth/whoami` - Get current user profile
- `PUT /api/auth/profile` - Update user profile (requires implementation on backend)

### AI Assistant Endpoints (Future)
- `POST /api/ai-assistant/query` - Query AI Assistant
- `GET /api/ai-assistant/history` - Get AI Assistant history

## State Management

### Riverpod Providers

All state management is done through Riverpod providers:

```dart
// Example: Watching conversations list
final conversations = ref.watch(conversationsListProvider);

conversations.when(
  data: (data) => /* Display data */,
  loading: () => /* Show loading */,
  error: (error, stack) => /* Show error */,
);
```

### Provider Types Used

1. **Provider**: Regular providers for dependencies (repositories, use cases)
2. **FutureProvider**: Async data fetching
3. **FutureProvider.family**: Parameterized async data fetching

## Error Handling

### Exception Hierarchy
- `ServerException`: Thrown by data sources on server errors
- `ClientException`: Thrown for client-side errors

### Failure Objects
- `ServerFailure`: Maps server exceptions to domain-level failures

All failures are wrapped in `Either<Failure, T>` using the `dartz` package.

## Dependencies

Key packages used:
- `flutter_riverpod: ^3.0.3` - State management
- `dio: ^5.4.1` - HTTP client
- `dartz: ^0.10.1` - Functional programming (Either, Option)
- `equatable`: For value equality in entities

## Integration Points

### With Backend
- Base URL: `http://10.0.2.2:5000` (Android Emulator)
- Supports different URLs for physical devices and iOS simulator
- Automatic token-based authentication through middleware

### With Existing Features
- Integrates with existing auth system
- Uses shared Dio instance
- Compatible with existing error handling

## Future Enhancements

1. **Implement AI Assistant Backend Endpoints**
   - Create `/api/ai-assistant/query` endpoint
   - Create `/api/ai-assistant/history` endpoint

2. **Add Local Caching**
   - Cache messages using Hive
   - Offline message drafts

3. **Real-time Messaging**
   - WebSocket integration for live conversations
   - Real-time notification updates

4. **Enhanced UI Components**
   - Message input with file attachments
   - Rich text message formatting
   - Message reactions/reactions

5. **Performance Optimizations**
   - Pagination for messages and conversations
   - Message lazy loading
   - Image caching with Flutter Cache Manager

## Testing

To test the features:

1. Ensure backend is running on `http://10.0.2.2:5000`
2. Run the app: `flutter run`
3. Login with test credentials
4. Navigate to messaging and user profile pages
5. Test messaging, notifications, and AI assistant features

## Notes

- Notifications are currently sourced from the messaging system
- AI Assistant features use stub endpoints that will return placeholder responses if backend endpoints aren't available
- The architecture follows SOLID principles and clean architecture best practices
- All providers are lazily initialized and automatically managed by Riverpod
