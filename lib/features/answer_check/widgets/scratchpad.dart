import 'package:flutter/material.dart';

class Scratchpad extends StatefulWidget {
  final double height;
  final Color penColor;
  final double strokeWidth;

  const Scratchpad({
    super.key,
    this.height = 300,
    this.penColor = Colors.black,
    this.strokeWidth = 3.0,
  });

  @override
  State<Scratchpad> createState() => _ScratchpadState();
}

class _ScratchpadState extends State<Scratchpad> {
  final List<List<Offset?>> _paths = [];

  void _addPoint(Offset point) {
    setState(() {
      if (_paths.isNotEmpty) {
        _paths.last.add(point);
      }
    });
  }

  void _startStroke(Offset point) {
    setState(() {
      _paths.add([point]);
    });
  }

  void _endStroke() {
    setState(() {
      // Nothing needed here for now
    });
  }

  void _clear() {
    setState(() {
      _paths.clear();
    });
  }

  void _undo() {
    setState(() {
      if (_paths.isNotEmpty) {
        _paths.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: GestureDetector(
                onPanStart: (details) {
                  final box = context.findRenderObject() as RenderBox;
                  final point = box.globalToLocal(details.globalPosition);
                  // Adjust for header height (approx 48) if needed, but since we are inside Expanded, simple local position might need offset fix
                  // Actually, GestureDetector inside a layout needs careful coordinate handling.
                  // Let's use localPosition from details.
                  _startStroke(details.localPosition);
                },
                onPanUpdate: (details) {
                  _addPoint(details.localPosition);
                },
                onPanEnd: (details) => _endStroke(),
                child: CustomPaint(
                  painter: _ScratchpadPainter(_paths, widget.penColor, widget.strokeWidth),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Scratchpad',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: _paths.isEmpty ? null : _undo,
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _paths.isEmpty ? null : _clear,
                  tooltip: 'Clear All',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScratchpadPainter extends CustomPainter {
  final List<List<Offset?>> paths;
  final Color color;
  final double strokeWidth;

  _ScratchpadPainter(this.paths, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    for (final path in paths) {
      if (path.isEmpty) continue;
      
      final pathObj = Path();
      pathObj.moveTo(path.first!.dx, path.first!.dy);
      
      for (int i = 1; i < path.length; i++) {
        if (path[i] == null) continue;
        pathObj.lineTo(path[i]!.dx, path[i]!.dy);
      }
      
      canvas.drawPath(pathObj, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScratchpadPainter oldDelegate) {
    return true; // Simple repaint for now
  }
}
