import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_demo/banner_widget.dart';

class Dashboard extends StatefulWidget {
  final Map<String, dynamic> uiData;

  const Dashboard({super.key, required this.uiData});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    final sectionsOrder = widget.uiData['sectionsOrder'] ?? [];
    final appBarColor = Color(int.parse(widget.uiData['pageProperties']['appbar_color'].replaceFirst('#', '0xFF')));
    final statusBarColor = Color(int.parse(widget.uiData['pageProperties']['statusbar_color'].replaceFirst('#', '0xFF')));

    // Change StatusBar color dynamically
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: Brightness.light,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65),
            child: SafeArea(
              child: AppBar(
                elevation: 0,
                flexibleSpace: Container(
                  margin: const EdgeInsets.only(top: 10, left: 5,right: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "Delivery to\n201301",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.shopping_cart, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: sectionsOrder.length,
            itemBuilder: (context, index) {
              return _buildSection(sectionsOrder[index]);
            },
          ),
        ));

  }

  Widget _buildSection(String sectionName) {
    switch (sectionName) {
      case 'banner':
        return BannerWidget(banners: widget.uiData["bannerSlider"],);
      case 'categories':
        return _buildCategories();
      case 'bestDeals':
        return _buildBestDeals();
      case 'offersAndDiscounts':
        return _buildOffersAndDiscounts();
      case 'dealsOfTheDay':
        return _buildDealsOfTheDay();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategories() {
    final categories = widget.uiData['categories'];

    // If the categories list is empty, return a SizedBox
    if (categories.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "BUY FURNITURE",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          const SizedBox(height: 10,),

          // GridView.builder to display the category items
          GridView.builder(
            shrinkWrap: true, // Allows the grid to take only as much space as needed
            physics: const NeverScrollableScrollPhysics(), // Disables scrolling for the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 items per row
              crossAxisSpacing: 8, // Horizontal spacing between items
              mainAxisSpacing: 8, // Vertical spacing between items
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      category['icon'],
                      height: 40,
                      width: 40,
                      errorBuilder: (context, object, stack) =>
                      const Icon(Icons.image, size: 40),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category['name'],
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBestDeals() {
    final bestDeals = widget.uiData['bestDeals'];

    if (bestDeals.isEmpty) return const SizedBox();

    // Get the screen width for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate crossAxisCount based on screen width
    final crossAxisCount = screenWidth < 600 ? 2 : 3;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3 / 2,
      ),
      itemCount: bestDeals.length,
      itemBuilder: (context, index) {
        final deal = bestDeals[index];
        return GestureDetector(
          onTap: () => debugPrint("Redirecting to ${deal['redirectPage']}"),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDEEAF7), Color(0xFFC4D7F2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        deal['icon'],
                        height: 40,
                        width: 40,
                        errorBuilder: (context, object, stack) => const Icon(Icons.image, size: 40),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      deal['deals_type'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      deal['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }

  Widget _buildOffersAndDiscounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Offers & Discounts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.uiData['offersAndDiscounts'].length,
            itemBuilder: (context, index) {
              final offer = widget.uiData['offersAndDiscounts'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(int.parse(offer['backgroundColor'].replaceFirst('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Icon
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            IconData(
                              int.parse(offer['iconCode']),
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Offer Title
                              Text(
                                offer['offer'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 5),
                              // Offer Details
                              Text(
                                offer['details'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 17,)
      ],
    );
  }

  Widget _buildDealsOfTheDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Deals of the Day',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250, // Adjust height for the card
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.uiData['dealsOfTheDay'].length,
            itemBuilder: (context, index) {
              final deal = widget.uiData['dealsOfTheDay'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          deal['image'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, size: 120),
                        ),
                      ),
                      // Product Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          deal['name'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Spacer(),
                      // Discount and Price
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Discount Percentage
                            Text(
                              '${deal['discount']}% off',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            // Price
                            Text(
                              '₹ ${deal['price']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /*int _calculateRealIndex(int index, int length) {
    if (index == 0) return length - 1; // Wrap to last
    if (index == length + 1) return 0; // Wrap to first
    return index - 1; // Adjust for padding slides
  }
  Widget _buildBanner(BuildContext context) {
    final dynamicUIProvider = Provider.of<DynamicUIProvider>(context, listen: true);
    final bannerSlider = dynamicUIProvider.uiData['bannerSlider'] ?? [];
    final currentPage = dynamicUIProvider.currentPage;

    if (bannerSlider.isEmpty) return const SizedBox();

    final pageController = PageController(initialPage: currentPage);

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: bannerSlider.length + 2, // Extra slides for infinite looping
            onPageChanged: (index) {
              final newIndex = _calculateRealIndex(index, bannerSlider.length);
              dynamicUIProvider.updateCurrentPage(newIndex);
            },
            itemBuilder: (context, index) {
              final realIndex = _calculateRealIndex(index, bannerSlider.length);
              final slide = bannerSlider[realIndex];
              return GestureDetector(
                onTap: () => debugPrint("Redirecting to ${slide['redirectPage']}"),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      slide['image'],
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
                bannerSlider.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
}
