import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key, required this.images});
  final List<String> images;

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

  final _controller = CarouselSliderController();
  final _current = ValueNotifier<int>(0);

  static const _img = 'https://i.postimg.cc/QtN3YYmp/banner-1.jpg';
  static const _slides = [_img, _img, _img];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.images.length,
          itemBuilder: (_, i, __) => _BannerCard(imageUrl: widget.images[i]),
          options: CarouselOptions(
            viewportFraction: 0.88,
            aspectRatio: 3.2,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),

            onPageChanged: (i, _) => setState(() => _current.value = i),
          ),
        ),

        Positioned(
          bottom: 10,
          child: ValueListenableBuilder<int>(
            valueListenable: _current,
            builder: (_, idx, __) {
              return Row(
                children: List.generate(_slides.length, (i) {
                  final active = i == idx;
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
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),

          Positioned.fill(
            child: Align(
              alignment: const Alignment(1, -0.05),

            ),
          ),
        ],
      ),
    );
  }
}
