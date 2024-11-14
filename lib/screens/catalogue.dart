import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk membaca file
import 'product_detail_page.dart'; // Pastikan Anda mengimpor halaman ProductDetailPage

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk membaca file deskripsi produk dari assets
  Future<String> _loadDescription() async {
    return await rootBundle.loadString('assets/parfum1.txt');
  }

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'image': 'assets/parfum1.jpg',
        'title': 'Scent of Valhalla : Odin Thorne',
        'description': 'Deskripsi singkat produk A.',
        'price': 'Rp 9.800.000',
      },
      {
        'image': 'assets/parfum2.jpg',
        'title': 'Scent of Valhalla : Thor Charges',
        'description': 'Deskripsi singkat produk B.',
        'price': 'Rp 8.600.000',
      },
      {
        'image': 'assets/parfum3.jpg',
        'title': 'Scent of Valhalla : Loki Tricks',
        'description': 'Deskripsi singkat produk C.',
        'price': 'Rp 7.400.000',
      },
      {
        'image': 'assets/parfum4.jpg',
        'title': 'Scent of Valhalla : Hela Tears',
        'description': 'Deskripsi singkat produk D.',
        'price': 'Rp 8.400.000',
      },
      {
        'image': 'assets/parfum5.jpg',
        'title': 'Scent of Valhalla : Fenrir Howls',
        'description': 'Deskripsi singkat produk E.',
        'price': 'Rp 6.400.000',
      },
      {
        'image': 'assets/parfum6.jpg',
        'title': 'Scent of Valhalla : Freya Aura',
        'description': 'Deskripsi singkat produk F.',
        'price': 'Rp 7.200.000',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Catalog",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () async {
                    String description =
                        await _loadDescription(); // Ambil deskripsi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          image: product['image']!,
                          title: product['title']!,
                          description:
                              description, // Kirim deskripsi ke halaman detail
                          price: product['price']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    color: Colors.grey[100],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'product_image_$index',
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.asset(
                                product['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title']!,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold, // Bold pada judul
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product['price']!,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
