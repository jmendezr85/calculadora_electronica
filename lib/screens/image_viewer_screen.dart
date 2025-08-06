// lib/screens/image_viewer_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final List<String> galleryImages; // Opcional: para galería de imágenes
  final int initialIndex; // Opcional: para galería de imágenes

  const ImageViewerScreen({
    super.key,
    required this.imagePath,
    this.title = 'Imagen',
    this.galleryImages = const [],
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Si hay múltiples imágenes en la galería, usa PhotoViewGallery.builder
    if (galleryImages.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.black, // Fondo oscuro para la AppBar
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        // PhotoViewGallery.builder es ideal para una colección de imágenes
        body: PhotoViewGallery.builder(
          itemCount: galleryImages.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: AssetImage(galleryImages[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 5.0,
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(
                tag: galleryImages[index],
              ),
            );
          },
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          pageController: PageController(initialPage: initialIndex),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black, // Fondo negro para las imágenes
          ),
        ),
      );
    } else {
      // Si es una sola imagen, usa PhotoView simple
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.black, // Fondo oscuro para la AppBar
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: Colors.black, // Fondo negro para la imagen
          child: PhotoView(
            imageProvider: AssetImage(imagePath),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 5.0,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: imagePath),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black, // Fondo negro para la imagen
            ),
          ),
        ),
      );
    }
  }
}
