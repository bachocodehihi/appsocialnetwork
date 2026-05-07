# Social Network App
Ứng dụng mạng xã hội full-stack được xây dựng bằng Flutter và Node.js.

# Frontend (Flutter)

## Chức năng

### Xác thực người dùng
- Xác minh email bằng OTP (mã 6 số)
- Đăng ký & đăng nhập bảo mật
- Quên mật khẩu bằng OTP
- Kiểm tra dữ liệu biểu mẫu
- Hiện/ẩn mật khẩu

### Hồ sơ người dùng
- Cập nhật thông tin cá nhân
- Thay đổi avatar
- Cập nhật ngày sinh, giới tính, nghề nghiệp, quốc tịch
- Xem hồ sơ người dùng

### Chức năng mạng xã hội
- Tìm kiếm người dùng theo thời gian thực
- Hệ thống kết bạn
- Theo dõi / bỏ theo dõi người dùng
- Hiển thị thống kê người dùng (bài viết, bạn bè, followers)
- Nhắn tin thời gian thực
- Quét mã QR để xem thông tin người dùng

### Thông báo
- Push notification bằng Firebase Cloud Messaging (FCM)
- Nhận thông báo ngay cả khi ứng dụng đã tắt
- Quản lý FCM token

### UI/UX
- Responsive cho mobile & web
- Hỗ trợ giao diện sáng/tối
- Dialog tùy chỉnh
- Loading state & error banner
- Responsive UI bằng Flutter ScreenUtil

# Backend (Node.js + MongoDB)

## Chức năng

### Authentication & Security
- JWT Authentication
- OTP verification system
- Password strength validation
- Middleware bảo mật (CORS, Helmet)

### Account Management
- API cập nhật hồ sơ người dùng
- Upload avatar bằng Cloudinary
- Tạo & lưu QR code người dùng
- Quản lý FCM token

### Cloud & DevOps
- Cấu hình môi trường bằng `.env`
- Tích hợp Cloudinary
- RESTful API architecture

# Công nghệ sử dụng

## Frontend
- Flutter
- GetX
- Flutter ScreenUtil
- Firebase Messaging

## Backend
- Node.js
- Express.js
- MongoDB
- JWT
- Cloudinary
- Socket.IO

# Cấu trúc dự án
Flutter/socialnetwork-app
Nodejs/backend-socialnetwork

# Tác giả
Developed by Bach Do
