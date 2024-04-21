import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkText extends StatelessWidget {
  final String description;
  final bool IsShowingDes;

  const LinkText({
    Key? key,
    required this.description,
    required this.IsShowingDes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
        children: _buildTextSpans(description),
      ),
      maxLines: IsShowingDes ? 50 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp linkRegExp = RegExp(
      r'(?:(?:https?|ftp):\/\/|www\.)[\w/\-?=%.]+\.[\w/\-?=%.]+',
    );
    final Iterable<Match> matches = linkRegExp.allMatches(text);

    int currentPos = 0;
    for (Match match in matches) {
      final String linkText = match.group(0)!;
      final int start = match.start;
      final int end = match.end;

      if (start > currentPos) {
        spans.add(
          TextSpan(
            text: text.substring(currentPos, start),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: linkText,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Uri uri = Uri.parse(linkText);
              if (uri.scheme.isEmpty) {
                // If the link does not have a scheme (e.g., http, https), prepend "https://" for compatibility
                launchUrl(Uri.parse("https://$linkText"));
              }
              try {
                launchUrl(Uri.parse(linkText));
              } catch (e) {
                throw 'Error launching URL: $e';
              }
            },
        ),
      );

      currentPos = end;
    }

    if (currentPos < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentPos),
        ),
      );
    }

    return spans;
  }
}

class LinkText1 extends StatelessWidget {
  final String description;
  final bool IsShowingDes;

  const LinkText1({
    Key? key,
    required this.description,
    required this.IsShowingDes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: Colors.black,
        ),
        children: _buildTextSpans(description),
      ),
      maxLines: IsShowingDes ? 50 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp linkRegExp = RegExp(
      r'(?:(?:https?|ftp):\/\/|www\.)[\w/\-?=%.]+\.[\w/\-?=%.]+',
    );
    final Iterable<Match> matches = linkRegExp.allMatches(text);

    int currentPos = 0;
    for (Match match in matches) {
      final String linkText = match.group(0)!;
      final int start = match.start;
      final int end = match.end;

      if (start > currentPos) {
        spans.add(
          TextSpan(
            text: text.substring(currentPos, start),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: linkText,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 12,

            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Uri uri = Uri.parse(linkText);
              if (uri.scheme.isEmpty) {
                // If the link does not have a scheme (e.g., http, https), prepend "https://" for compatibility
                launchUrl(Uri.parse("https://$linkText"));
              }
              try {
                launchUrl(Uri.parse(linkText));
              } catch (e) {
                throw 'Error launching URL: $e';
              }
            },
        ),
      );

      currentPos = end;
    }

    if (currentPos < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentPos),
        ),
      );
    }

    return spans;
  }
}
