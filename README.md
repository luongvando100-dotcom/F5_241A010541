# Lab F5 - Danh sách và lưới trong Flutter

Ứng dụng Flutter Material 3 minh họa `ListView.builder`, `Dismissible`,
`GridView.builder`, model dữ liệu, tìm kiếm và trạng thái rỗng.

## Chạy ứng dụng

```powershell
flutter pub get
flutter devices
flutter run -d <device-id>
```

Chọn ID của Android emulator hoặc thiết bị đang kết nối từ kết quả `flutter devices`.

## Kiểm tra

```powershell
flutter analyze
flutter test
```

Sáu ảnh minh họa tạm thời nằm trong `assets/images/`. Trước khi nộp, hãy thay
chúng bằng ảnh sản phẩm dưới 200 KB, giữ nguyên tên `p1.png` đến `p6.png`.
Nếu một ảnh bị thiếu, ứng dụng sẽ hiển thị ô thay thế thay vì gặp lỗi.

## Demo

Mở tab Danh sách, cuộn, thêm sản phẩm, vuốt xóa một dòng ở giữa danh sách,
thử tìm kiếm, chuyển sang tab Lưới rồi xoay ngang thiết bị.
