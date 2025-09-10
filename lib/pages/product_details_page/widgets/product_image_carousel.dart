import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.images,
    this.height = 300,
    this.viewportFraction = 1
  });

  final List<String> images;
  final double height;
  final double viewportFraction;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images.isEmpty ? <String>[] : widget.images;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: CarouselSlider.builder(
            carouselController: _controller,
            itemCount: imgs.length,
            itemBuilder: (_, i, __) => ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
              child: Image.network(imgs[i], fit: BoxFit.contain, width: double.infinity),
            ),
            options: CarouselOptions(
              height: widget.height,
              viewportFraction: widget.viewportFraction,
              enlargeCenterPage: false,
              enableInfiniteScroll: imgs.length > 1,
              autoPlay: imgs.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (i, _) => setState(() => _current = i),
            ),
          ),
        ),

        if (imgs.length > 1)
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(imgs.length, (i) {
                final active = i == _current;
                return GestureDetector(
                  onTap: () => _controller.animateToPage(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: active ? 22 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF53B175) : const Color(0xFFC8C8C8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
