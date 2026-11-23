import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
    required this.messageType,
  });

  final String message;
  final String messageType;

  @override
  Widget build(BuildContext context) {
    final bool isMe = messageType == 'me';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - val)),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isMe
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          margin: EdgeInsets.symmetric(vertical: 2.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isMe ? null : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isMe ? 16.r : 3.r),
              bottomRight: Radius.circular(isMe ? 3.r : 16.r),
            ),
            border: isMe
                ? null
                : Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: isMe
                    ? const Color(0xFF2563EB).withOpacity(0.18)
                    : Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : const Color(0xFF0F172A),
              fontSize: 13.5.sp,
              height: 1.35,
              fontWeight: isMe ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
