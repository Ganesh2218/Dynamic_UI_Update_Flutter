import 'dart:async';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  final List<dynamic> banners;

  const BannerWidget({required this.banners, Key? key}) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late PageController _pageController;
  late Timer _autoSlideTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize auto-slide
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        int nextIndex = (_currentIndex + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox(); // Return an empty widget if there are no banners
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return GestureDetector(
                onTap: () {
                  debugPrint("Redirecting to ${banner['redirectPage']}");
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      banner['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'images/banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
