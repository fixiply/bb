import 'package:flutter/material.dart';

// Internal package
import 'package:bb/utils/constants.dart';

class ShimmerContainer extends StatefulWidget {
  final int crossAxisCount;
  ShimmerContainer({Key? key, this.crossAxisCount = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShimmerContainerState();
  }
}

class _ShimmerContainerState extends State<ShimmerContainer> {

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    double height = MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top;
    if (widget.crossAxisCount > 0) {
      for (var i = 0; i < (height / 168).round() * widget.crossAxisCount; i++) {
        children.add(_buildEmpty());
      }
      return Container(
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          children: children,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0
          ),
        )
      );
    }
    for (var i = 0; i < (height / 270).round(); i++) {
      children.add(_buildEmpty());
    }
    return Container(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: children,
      )
    );
  }

  _buildEmpty() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.crossAxisCount > 0 ? 180 : 220,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FillColor
            )
          ),
          if (widget.crossAxisCount == 0) const SizedBox(height: 8),
          if (widget.crossAxisCount == 0) Container(
            height: 30,
            width: MediaQuery.of(context).size.height / 2.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FillColor
            )
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FillColor
            )
          ),
        ]
      )
    );
  }
}