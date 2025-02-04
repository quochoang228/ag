🔥 API Gateway bây giờ hỗ trợ đầy đủ tất cả các phương thức HTTP:
✅ GET - Lấy dữ liệu
✅ POST - Gửi dữ liệu
✅ PUT - Cập nhật dữ liệu
✅ DELETE - Xóa dữ liệu

🔥 Các tính năng nâng cao:
✅ Xác thực & Ủy quyền (JWT, OAuth2)
✅ Rate Limiting
✅ Caching
✅ Logging Request/Response
✅ Retry khi gặp lỗi tạm thời
✅ Tracking API Events
✅ Theo dõi số lần request thất bại liên tiếp
✅ Tự động chặn request khi lỗi vượt quá ngưỡng cho phép
✅ Tự động mở lại sau thời gian cooldown

# Sử dụng ApiGateway

`
final apiGateway = ApiGateway(
  getAccessToken: () async => "your_access_token",
  refreshAccessToken: () async => "new_access_token",
  failureThreshold: 3,  // Sau 3 lần lỗi liên tiếp, circuit breaker sẽ mở
  circuitResetTimeout: Duration(seconds: 30),  // Sau 30s, circuit breaker sẽ reset
  onTrack: (event, data) {
    print("📊 Tracking Event: $event - $data");
  }
);

void main() async {
  try {
    final response = await apiGateway.get("https://api.example.com/data");
    print("✅ Data: ${response.data}");
  } catch (e) {
    print("❌ Error: $e");
  }
}
`