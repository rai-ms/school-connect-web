import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ParallaxListView extends StatefulWidget {
  const ParallaxListView({super.key});

  @override
  State<ParallaxListView> createState() => _ParallaxListViewState();
}

class _ParallaxListViewState extends State<ParallaxListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simulating snapshot data with image URLs
    List<String> imageUrls = [
      'https://d3pc1xvrcw35tl.cloudfront.net/sm/images/1260x945/tandav-shiv_202402285725.jpg',
      'https://d3pc1xvrcw35tl.cloudfront.net/sm/images/1260x945/tandav-shiv_202402285725.jpg',
      'https://d3pc1xvrcw35tl.cloudfront.net/sm/images/1260x945/tandav-shiv_202402285725.jpg',
      'https://d3pc1xvrcw35tl.cloudfront.net/sm/images/1260x945/tandav-shiv_202402285725.jpg',
      'https://d3pc1xvrcw35tl.cloudfront.net/sm/images/1260x945/tandav-shiv_202402285725.jpg',
    ];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return SizedBox(
                height: 300,
                child: ParallaxImage(
                  imageUrl: imageUrls[index],
                  scrollOffset: _scrollController.offset,
                ),
              );
            },
            childCount: imageUrls.length,
          ),
        ),
      ],
    );
  }
}

class ParallaxImage extends StatelessWidget {
  final String imageUrl;
  final double scrollOffset;
  final GlobalKey imageKey = GlobalKey();

  ParallaxImage({
    super.key,
    required this.imageUrl,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        globalKey: imageKey,
        scrollableState: Scrollable.of(context),
        itemContext: context,
      ),
      children: [
        CachedNetworkImage(
          key: imageKey,
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          memCacheWidth: 100,
          memCacheHeight: 100,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollableState;
  final GlobalKey globalKey;
  final BuildContext itemContext;


  ParallaxFlowDelegate({
    required this.globalKey,
    required this.scrollableState,
    required this.itemContext
  });

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollableState.context.findRenderObject() as RenderBox;
    final itemBox = itemContext.findRenderObject() as RenderBox;
    final itemOffset = itemBox.localToGlobal(itemBox.size.centerLeft(Offset.zero), ancestor: scrollableBox);
    final viewPortDimension = scrollableState.position.viewportDimension;
    final scrollFraction = (itemOffset.dy/ viewPortDimension).clamp(0, 1);
    final verticalAlignment = Alignment(0, scrollFraction*2-1);
    final imageBox = globalKey.currentContext?.findRenderObject() as RenderBox;
    final childRect = verticalAlignment.inscribe(imageBox.size, Offset.zero & context.size);
    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(
          0,
          childRect.top
        )
      ).transform
    );
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return (scrollableState != oldDelegate.scrollableState ||
    itemContext != oldDelegate.itemContext ||
    globalKey != oldDelegate.globalKey);
  }
}