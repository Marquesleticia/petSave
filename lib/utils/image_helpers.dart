import 'dart:convert';
import 'package:flutter/widgets.dart';

ImageProvider petImageProvider(String imageUrl) {
  if (imageUrl.startsWith('data:image')) {
    final data = imageUrl.substring(imageUrl.indexOf(',') + 1);
    return MemoryImage(base64Decode(data));
  }
  return NetworkImage(imageUrl);
}
