import 'package:flutter/material.dart';
import 'package:e_commerce_project/SQLite/fuction_data.dart';

class MyImageSlider extends StatefulWidget {
  final Function(int) onChange;
  final int productId;

  const MyImageSlider({super.key, required this.productId, required this.onChange});

  @override
  _MyImageSliderState createState() => _MyImageSliderState();
}

class _MyImageSliderState extends State<MyImageSlider> {
  late Future<List<Map<String, dynamic>>> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = DatabaseHelper().getImageByProductID(widget.productId); // Gọi hàm lấy hình ảnh khi màn hình load
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Hiển thị loading khi dữ liệu đang tải
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Nếu có lỗi
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No images available')); // Nếu không có hình ảnh nào
            } else {
              List<Map<String, dynamic>> images = snapshot.data!;
              return SizedBox(
                height: 550,
                child: PageView.builder(
                  itemCount: images.length, // Đếm số lượng ảnh
                  onPageChanged: widget.onChange, // Gọi hàm khi thay đổi trang
                  itemBuilder: (context, index) {
                    String imageUrl = images[index]['imageURL'] ?? 'https://via.placeholder.com/150';
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover, // Đảm bảo ảnh vừa với khung
                          alignment: Alignment.center,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ]
    );
  }
}
