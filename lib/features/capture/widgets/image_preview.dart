import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class ImagePreview extends StatefulWidget {
  final XFile? selectedImage;
  final Uint8List? imageDataBytes; // Direct image bytes for web

  const ImagePreview({super.key, this.selectedImage, this.imageDataBytes});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(ImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedImage != widget.selectedImage ||
        oldWidget.imageDataBytes != widget.imageDataBytes) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    // If we have direct image bytes (for web), use them
    if (widget.imageDataBytes != null) {
      setState(() {
        _imageBytes = widget.imageDataBytes;
      });
      return;
    }

    // Otherwise, try to load from XFile (for mobile)
    if (widget.selectedImage != null) {
      try {
        final bytes = await widget.selectedImage!.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      } catch (e) {
        print('Error loading image: $e');
        setState(() {
          _imageBytes = null;
        });
      }
    } else {
      setState(() {
        _imageBytes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_imageBytes != null) {
      imageWidget = Image.memory(_imageBytes!, fit: BoxFit.cover);
    } else {
      imageWidget = Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, size: 64, color: Colors.grey),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      ),
    );
  }
}
