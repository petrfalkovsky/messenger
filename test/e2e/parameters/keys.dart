// Copyright © 2022-2024 IT ENGINEERING MANAGEMENT INC,
//                       <https://github.com/team113>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

// ignore_for_file: constant_identifier_names
import 'package:gherkin/gherkin.dart';

/// [Key]s available in the [WidgetKeyParameter].
enum WidgetKey {
  AddEmail,
  AddMemberButton,
  AddPhone,
  AddToContactsButton,
  AddToFavoriteButton,
  AlertDialog,
  AlertNoButton,
  AlertYesButton,
  Approve,
  AudioCall,
  AuthView,
  Block,
  Blocklist,
  BlocklistLoading,
  BlocklistView,
  ChangeAvatar,
  ChangeLanguage,
  ChangePassword,
  ChangePasswordButton,
  ChatAvatar,
  ChatDirectLinkExpandable,
  ChatForwardView,
  ChatInfoScrollable,
  ChatMessage,
  ChatMonolog,
  ChatView,
  Chats,
  ChatsButton,
  ChatsLoading,
  ChatsMenu,
  ChatsTab,
  ClearHistoryButton,
  CloseButton,
  ConfirmLogoutButton,
  ConfirmLogoutView,
  ConfirmationCode,
  ConfirmationPhone,
  ConfirmedEmail,
  ConfirmedPhone,
  Contacts,
  ContactsButton,
  ContactsLoading,
  ContactsMenu,
  ContactsTab,
  CopyButton,
  CurrentPasswordField,
  DangerZone,
  Delete,
  DeleteAccount,
  DeleteAvatar,
  DeleteButton,
  DeleteChats,
  DeleteContacts,
  DeleteEmail,
  DeleteForAll,
  DeleteMemberButton,
  DeletePhone,
  EditButton,
  Email,
  EmailsExpandable,
  ExpandSigning,
  FavoriteChatButton,
  FavoriteContactButton,
  ForwardButton,
  ForwardField,
  HideChatButton,
  HideForMe,
  HomeView,
  IntroductionView,
  Language,
  Language_en,
  Language_ru,
  LoginButton,
  LoginField,
  LoginView,
  LogoutButton,
  MenuButton,
  MenuListView,
  MenuTab,
  MessageField,
  MonologButton,
  MoreButton,
  MuteChatButton,
  MuteChatsButton,
  Muted,
  MyProfileButton,
  MyProfileScrollable,
  MyProfileView,
  NameField,
  NewPasswordField,
  NoMessages,
  NumCopyable,
  PasswordButton,
  PasswordExpandable,
  PasswordField,
  PasswordStage,
  Phone,
  PhonesExpandable,
  PresenceDropdown,
  Proceed,
  PublicInformation,
  RecoveryCodeField,
  RecoveryField,
  RenameChatField,
  RepeatPasswordField,
  Resend,
  Restore,
  Search,
  SearchButton,
  SearchField,
  SearchLoading,
  SearchScrollable,
  SearchSubmitButton,
  SearchTextField,
  SearchView,
  Select,
  SelectChatsButton,
  SelectContactsButton,
  Selected,
  Send,
  SendForward,
  SetPassword,
  SetPasswordButton,
  SettingsButton,
  ShowBlocklist,
  SignInButton,
  Signing,
  StartButton,
  SuccessStage,
  Unblock,
  UnconfirmedEmail,
  UnconfirmedPhone,
  UnfavoriteChatButton,
  UnfavoriteContactButton,
  UnmuteChatButton,
  UnmuteChatsButton,
  Unmuted,
  Unselected,
  UserScrollable,
  UsernameField,
  VerifyEmail,
  VerifyPhone,
}

/// [CustomParameter] of [WidgetKey]s representing a [Key] of a [Widget].
class WidgetKeyParameter extends CustomParameter<WidgetKey> {
  WidgetKeyParameter()
      : super(
          'key',
          RegExp(
            '`(${WidgetKey.values.map((e) => e.name).join('|')})`',
            caseSensitive: true,
          ),
          (c) => WidgetKey.values.firstWhere((e) => e.name == c),
        );
}
