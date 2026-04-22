part of '../policies_screen.dart';

class _Section {
  final IconData icon;
  final String title;
  final List<String> bullets;
  const _Section({
    required this.icon,
    required this.title,
    required this.bullets,
  });
}

const _sections = [
  _Section(
    icon: Icons.access_time_rounded,
    title: 'Yêu cầu giờ học',
    bullets: [
      'Tối thiểu 20 giờ học mỗi tuần, trung bình khoảng 3 tiếng mỗi ngày.',
      'Log giờ học trước 23:59 Chủ nhật — không log dồn, không log ảo.',
      'Giờ thực chiến, review bài cũ và ôn tập đều được tính vào tổng giờ.',
      'BQL kiểm tra ngẫu nhiên mỗi tháng, số liệu gian lận bị xử lý ngay.',
    ],
  ),
  _Section(
    icon: Icons.warning_amber_rounded,
    title: 'Hệ thống cảnh báo',
    bullets: [
      'Cảnh báo 1: Tuần đầu không đủ giờ — nhắc nhở qua kênh Discord.',
      'Cảnh báo 2: Vi phạm lần hai liên tiếp — ghi nhận chính thức vào hồ sơ.',
      'Cảnh báo 3: Vi phạm lần ba liên tiếp — kick khỏi nhóm không hoàn tiền.',
      'Duy trì đủ giờ 4 tuần liên tục sẽ được reset về 0 cảnh báo.',
    ],
  ),
  _Section(
    icon: Icons.calendar_month_outlined,
    title: 'Quy trình xin nghỉ',
    bullets: [
      'Báo phép tối thiểu 3 ngày trước qua kênh #xin-phep trên Discord.',
      'Mỗi tháng được nghỉ phép tối đa 1 tuần không tính vào cảnh báo.',
      'Không báo phép trước vẫn tính là tuần vi phạm bình thường.',
      'Trường hợp khẩn cấp: nhắn riêng BQL trong 24 giờ kể từ khi xảy ra.',
    ],
  ),
  _Section(
    icon: Icons.people_outline_rounded,
    title: 'Văn hóa & ứng xử',
    bullets: [
      'Hỗ trợ, chia sẻ tài liệu và kinh nghiệm với thành viên khác.',
      'Phản hồi nhận xét hoặc yêu cầu của BQL trong vòng 48 giờ.',
      'Không spam, không toxic, không tiết lộ nội dung nhóm ra bên ngoài.',
      'Tham dự ít nhất 1 buổi họp nhóm online mỗi tháng nếu có tổ chức.',
    ],
  ),
  _Section(
    icon: Icons.edit_note_rounded,
    title: 'Nội dung học & báo cáo',
    bullets: [
      'Ghi chú ngắn gọn chủ đề đã học khi log giờ mỗi ngày.',
      'Chia sẻ ít nhất 1 insight hoặc tài liệu lên kênh #study-log mỗi tuần.',
      'Không sao chép ghi chú người khác — phải là trải nghiệm học thực tế.',
      'Vắng bài kiểm tra định kỳ không báo trước bị trừ 0.5 điểm xếp hạng.',
    ],
  ),
  _Section(
    icon: Icons.leaderboard_rounded,
    title: 'Quy tắc xếp hạng',
    bullets: [
      'Bảng xếp hạng cập nhật mỗi thứ Hai sau khi BQL tổng kết tuần.',
      'Điểm được tính bằng giờ học nhân hệ số chất lượng ghi chú và tương tác.',
      'Top 3 mỗi tháng nhận phần thưởng và badge đặc biệt hiển thị trên hồ sơ.',
      'Khiếu nại kết quả xếp hạng chỉ được chấp nhận trong 48 giờ sau công bố.',
    ],
  ),
];
