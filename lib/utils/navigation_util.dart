import 'package:flutter/material.dart';

/// 앱 전체에서 사용할 네비게이션 유틸리티
class NavigationUtil {
  /// 공통 네비게이션 바를 생성하는 위젯
  static Widget buildNavigationBar({
    required BuildContext context,
    String? title,
    Widget? leading,
    List<Widget>? actions,
    Color? backgroundColor,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 뒤로가기 버튼 또는 커스텀 leading
            if (showBackButton)
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            else if (leading != null)
              leading,

            const SizedBox(width: 16),

            // 제목
            if (title != null)
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // 액션 버튼들
            if (actions != null) ...actions,
          ],
        ),
      ),
    );
  }

  /// 글래스모피즘 스타일의 네비게이션 바
  static Widget buildGlassNavigationBar({
    required BuildContext context,
    String? title,
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 뒤로가기 버튼 또는 커스텀 leading
            if (showBackButton)
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              )
            else if (leading != null)
              leading,

            const SizedBox(width: 16),

            // 제목
            if (title != null)
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // 액션 버튼들
            if (actions != null) ...actions,
          ],
        ),
      ),
    );
  }

  /// 홈으로 이동하는 네비게이션
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  /// 특정 라우트로 이동
  static void navigateTo(BuildContext context, String route,
      {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  /// 뒤로가기 (안전한 방식)
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      goToHome(context);
    }
  }
}
