part of '../policies_screen.dart';

class _IntroParagraph extends StatelessWidget {
  const _IntroParagraph();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13.5,
          color: _textMain,
          height: 1.65,
          fontWeight: FontWeight.w400,
        ),
        children: [
          const TextSpan(
            text: 'Tất cả thành viên khi tham gia đã đồng ý toàn bộ nội dung dưới đây. '
                'BQL có quyền cập nhật với thông báo trước tối thiểu ',
          ),
          const TextSpan(
            text: '7 ngày',
            style: TextStyle(
              color: _accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(text: '. Mọi đề xuất gửi về '),
          const TextSpan(
            text: '#gop-y',
            style: TextStyle(color: _accent, fontWeight: FontWeight.w700),
          ),
          const TextSpan(text: ' trên Discord.'),
        ],
      ),
    );
  }
}
