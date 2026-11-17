import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sabios_app/core/theme/app_colors.dart';
import 'package:sabios_app/core/widgets/brand_logo.dart';

void main() {
  test('Gerar app_icon.ico', () async {
    const double size = 256.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));

    final bgPaint = Paint()..color = AppColors.primaryTeal;
    canvas.drawRect(const Rect.fromLTWH(0, 0, size, size), bgPaint);

    const double symbolSize = size * 0.58;
    const double offset = (size - symbolSize) / 2;

    canvas.save();
    canvas.translate(offset, offset);
    const SabiosSymbolPainter(color: AppColors.accentGold)
        .paint(canvas, const Size(symbolSize, symbolSize));
    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final header = ByteData(22);
    header.setUint16(0, 0, Endian.little);
    header.setUint16(2, 1, Endian.little);
    header.setUint16(4, 1, Endian.little);
    header.setUint8(6, 0);
    header.setUint8(7, 0);
    header.setUint8(8, 0);
    header.setUint8(9, 0);
    header.setUint16(10, 1, Endian.little);
    header.setUint16(12, 32, Endian.little);
    header.setUint32(14, pngBytes.length, Endian.little);
    header.setUint32(18, 22, Endian.little);

    final icoBuilder = BytesBuilder();
    icoBuilder.add(header.buffer.asUint8List());
    icoBuilder.add(pngBytes);

    final file = File('windows/runner/resources/app_icon.ico');
    await file.create(recursive: true);
    await file.writeAsBytes(icoBuilder.toBytes());
  });
}
