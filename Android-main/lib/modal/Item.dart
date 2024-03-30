class DataItems {
  final String id;
  final String name;
  final DateTime date;

  DataItems({
    required this.id,
    required this.name,
    required this.date,
  });
}

// Đây là một lớp đơn giản trong Dart được sử dụng để đại diện cho các mục dữ liệu. Lớp này có ba thuộc tính:

// id: Một chuỗi đại diện cho ID của mục dữ liệu. Thường được sử dụng để xác định một cách duy nhất mỗi mục dữ liệu trong hệ thống.

// name: Một chuỗi đại diện cho tên hoặc mô tả của mục dữ liệu.

// date: Một đối tượng DateTime đại diện cho ngày và giờ liên quan đến mục dữ liệu.

// Constructor của lớp này chấp nhận ba tham số được gắn nhãn là id, name, và date. Tất cả các tham số này là bắt buộc (required), điều này có nghĩa là khi tạo một thể hiện của lớp DataItems, bạn phải cung cấp giá trị cho các tham số này.
