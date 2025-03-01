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

import 'dart:async';
import 'dart:typed_data';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/config.dart';
import '/domain/model/user.dart';
import '/l10n/l10n.dart';
import '/provider/gql/exceptions.dart' show CreateChatDirectLinkException;
import '/themes.dart';
import '/ui/page/home/page/my_profile/widget/background_preview.dart';
import '/ui/widget/svg/svg.dart';
import '/ui/widget/text_field.dart';
import '/ui/widget/widget_button.dart';
import '/util/message_popup.dart';
import '/util/platform_utils.dart';

/// [ReactiveTextField] displaying the provided [link].
///
/// If [link] is `null`, generates and displays a random [ChatDirectLinkSlug].
class DirectLinkField extends StatefulWidget {
  const DirectLinkField(this.link, {super.key, this.onSubmit, this.background});

  /// [ChatDirectLink] to display.
  final ChatDirectLink? link;

  /// Callback, called when [ChatDirectLinkSlug] is submitted.
  final FutureOr<void> Function(ChatDirectLinkSlug?)? onSubmit;

  /// Bytes of the background to display under the widget.
  final Uint8List? background;

  @override
  State<DirectLinkField> createState() => _DirectLinkFieldState();
}

/// State of an [DirectLinkField] maintaining the [_state].
class _DirectLinkFieldState extends State<DirectLinkField> {
  /// Generated [ChatDirectLinkSlug], used in the [_state], if any.
  String? _generated;

  /// State of the [ReactiveTextField].
  late final TextFieldState _state;

  /// Indicator whether editing of the [ChatDirectLinkSlug] is enabled
  /// currently.
  bool _editing = false;

  @override
  void initState() {
    if (widget.link == null) {
      _generated = ChatDirectLinkSlug.generate(10).val;
      _editing = true;
    }

    _state = TextFieldState(
      text: widget.link?.slug.val ?? _generated,
      approvable: true,
      submitted: widget.link != null,
      onChanged: (s) {
        s.error.value = null;

        try {
          ChatDirectLinkSlug(s.text);
        } on FormatException {
          s.error.value = 'err_incorrect_input'.l10n;
        }
      },
      onSubmitted: (s) async {
        ChatDirectLinkSlug? slug;
        try {
          slug = ChatDirectLinkSlug(s.text);
        } on FormatException {
          s.error.value = 'err_incorrect_input'.l10n;
        }

        setState(() => _editing = false);

        if (slug == null || slug == widget.link?.slug) {
          return;
        }

        if (s.error.value == null) {
          s.editable.value = false;
          s.status.value = RxStatus.loading();

          try {
            await widget.onSubmit?.call(slug);
            s.status.value = RxStatus.success();
            await Future.delayed(const Duration(seconds: 1));
            s.status.value = RxStatus.empty();
          } on CreateChatDirectLinkException catch (e) {
            s.status.value = RxStatus.empty();
            s.error.value = e.toMessage();
          } catch (e) {
            s.status.value = RxStatus.empty();
            MessagePopup.error(e);
            s.unsubmit();
            rethrow;
          } finally {
            s.editable.value = true;
          }
        }
      },
    );

    super.initState();
  }

  @override
  void didUpdateWidget(DirectLinkField oldWidget) {
    if (!_state.focus.hasFocus &&
        !_state.changed.value &&
        _state.editable.value) {
      _state.unchecked = widget.link?.slug.val;

      if (oldWidget.link != widget.link) {
        _editing = widget.link == null;
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).style;

    final Widget child;

    if (_editing) {
      child = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ReactiveTextField(
          key: const Key('LinkField'),
          state: _state,
          label: '${Config.link}/',
        ),
      );
    } else {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: style.primaryBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.background == null
                        ? const SvgImage.asset(
                            'assets/images/background_light.svg',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(widget.background!, fit: BoxFit.cover),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 14),
                  _info(context, Text(DateTime.now().yMd)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                    child: WidgetButton(
                      onPressed: () {
                        final share = '${Config.link}/${_state.text}';

                        if (PlatformUtils.isMobile) {
                          Share.share(share);
                        } else {
                          PlatformUtils.copy(text: share);
                          MessagePopup.success('label_copied'.l10n);
                        }
                      },
                      child: MessagePreviewWidget(
                        fromMe: true,
                        style: style.fonts.medium.regular.primary,
                        text: '${Config.link}/${_state.text}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 6, 0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: style.secondaryBorder,
                          color: style.readMessageColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: QrImageView(
                          data: '${Config.link}/${widget.link?.slug.val}',
                          version: QrVersions.auto,
                          size: 300.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                    child: MessagePreviewWidget(
                      fromMe: true,
                      text: 'label_clicks_count'
                          .l10nfmt({'count': widget.link?.usageCount ?? 0}),
                      style: style.fonts.medium.regular.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: WidgetButton(
                  onPressed: () {
                    final share = '${Config.link}/${_state.text}';

                    if (PlatformUtils.isMobile) {
                      Share.share(share);
                    } else {
                      PlatformUtils.copy(text: share);
                      MessagePopup.success('label_copied'.l10n);
                    }
                  },
                  child: Text(
                    PlatformUtils.isMobile ? 'btn_share'.l10n : 'btn_copy'.l10n,
                    style: style.fonts.small.regular.primary,
                  ),
                ),
              ),
              if (widget.onSubmit != null) ...[
                const SizedBox(width: 8),
                WidgetButton(
                  onPressed: () {
                    setState(() {
                      widget.onSubmit?.call(null);
                      _state.unsubmit();
                      _state.changed.value = true;
                      _editing = true;
                    });
                  },
                  child: Text(
                    'btn_delete'.l10n,
                    style: widget.onSubmit == null
                        ? style.fonts.small.regular.secondary
                        : style.fonts.small.regular.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      );
    }

    return AnimatedSizeAndFade(
      sizeDuration: const Duration(milliseconds: 300),
      fadeDuration: const Duration(milliseconds: 300),
      child: child,
    );
  }

  /// Builds a wrapper around the [child] visually representing a [ChatInfo]
  /// message.
  Widget _info(BuildContext context, Widget child) {
    final style = Theme.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: style.systemMessageBorder,
            color: style.systemMessageColor,
          ),
          child: DefaultTextStyle(
            style: style.systemMessageStyle,
            child: child,
          ),
        ),
      ),
    );
  }
}
