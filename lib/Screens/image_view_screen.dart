import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatelessWidget {
  final String? image; // Make it nullable just in case
  const ImageViewScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final bool isValidImage = image != null && image!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (isValidImage)
            PhotoView(
              imageProvider: NetworkImage(image!),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(Icons.broken_image, color: Colors.white, size: 50),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            )
          else
            Center(
              child: Icon(Icons.image_not_supported,
                  color: Colors.white, size: 60),
            ),
          Positioned(
            top: 0,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
