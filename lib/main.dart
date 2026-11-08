import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F5 - Danh sách sản phẩm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0468D7),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class SanPham {
  final int id;
  final String ten;
  final String moTa;
  final int gia;
  final String anh;

  const SanPham({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.gia,
    required this.anh,
  });
}

const List<SanPham> duLieuMau = [
  SanPham(
    id: 1,
    ten: 'Áo thun VHU',
    moTa: 'Cotton 100%, in logo trường',
    gia: 180000,
    anh: 'assets/images/p1.png',
  ),
  SanPham(
    id: 2,
    ten: 'Bình giữ nhiệt',
    moTa: 'Inox 500ml, giữ nóng 6 giờ',
    gia: 250000,
    anh: 'assets/images/p2.png',
  ),
  SanPham(
    id: 3,
    ten: 'Sổ tay sinh viên',
    moTa: '200 trang, bìa cứng',
    gia: 75000,
    anh: 'assets/images/p3.png',
  ),
  SanPham(
    id: 4,
    ten: 'Balo laptop',
    moTa: 'Chống nước, ngăn 15.6 inch',
    gia: 420000,
    anh: 'assets/images/p4.png',
  ),
  SanPham(
    id: 5,
    ten: 'Móc khóa gỗ',
    moTa: 'Khắc laser tên trường',
    gia: 35000,
    anh: 'assets/images/p5.png',
  ),
  SanPham(
    id: 6,
    ten: 'Cốc sứ in hình',
    moTa: 'Dung tích 350ml',
    gia: 95000,
    anh: 'assets/images/p6.png',
  ),
];

String dinhDangGia(int gia) {
  final digits = gia.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${gia < 0 ? '-' : ''}$buffer đ';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<SanPham> _sanPham = List.of(duLieuMau);
  int _tab = 0;
  int _idTiepTheo = duLieuMau.length + 1;
  String _tuKhoa = '';

  List<SanPham> get _ketQuaTimKiem {
    final query = _tuKhoa.trim().toLowerCase();
    if (query.isEmpty) return _sanPham;
    return _sanPham
        .where((sanPham) => sanPham.ten.toLowerCase().contains(query))
        .toList();
  }

  void _themSanPham() {
    setState(() {
      final id = _idTiepTheo++;
      _sanPham.insert(
        0,
        SanPham(
          id: id,
          ten: 'Sản phẩm mới $id',
          moTa: 'Sản phẩm vừa được thêm',
          gia: 50000 * (id - duLieuMau.length),
          anh: duLieuMau.first.anh,
        ),
      );
    });
  }

  void _xoaSanPham(SanPham sanPham) {
    final index = _sanPham.indexWhere((item) => item.id == sanPham.id);
    if (index == -1) return;

    setState(() => _sanPham.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xóa ${sanPham.ten}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tab == 0 ? 'Danh sách sản phẩm' : 'Album ảnh'),
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          ProductListTab(
            products: _ketQuaTimKiem,
            isEmpty: _sanPham.isEmpty,
            query: _tuKhoa,
            onQueryChanged: (value) => setState(() => _tuKhoa = value),
            onAdd: _themSanPham,
            onRemove: _xoaSanPham,
          ),
          AlbumTab(products: _sanPham),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              key: const ValueKey('add-product'),
              tooltip: 'Thêm sản phẩm',
              onPressed: _themSanPham,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Danh sách',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Lưới',
          ),
        ],
      ),
    );
  }
}

class ProductListTab extends StatelessWidget {
  final List<SanPham> products;
  final bool isEmpty;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onAdd;
  final ValueChanged<SanPham> onRemove;

  const ProductListTab({
    super.key,
    required this.products,
    required this.isEmpty,
    required this.query,
    required this.onQueryChanged,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            key: const ValueKey('product-search'),
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Tìm theo tên sản phẩm',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Xóa tìm kiếm',
                      onPressed: () => onQueryChanged(''),
                      icon: const Icon(Icons.clear),
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: isEmpty
              ? _EmptyState(
                  message: 'Danh sách trống',
                  actionLabel: 'Thêm sản phẩm',
                  onAction: onAdd,
                )
              : products.isEmpty
                  ? _EmptyState(
                      message: 'Không tìm thấy sản phẩm',
                      actionLabel: 'Xóa tìm kiếm',
                      onAction: () => onQueryChanged(''),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final sanPham = products[index];
                        return Dismissible(
                          key: ValueKey<int>(sanPham.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => onRemove(sanPham),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: AnhSanPham(
                                duongDan: sanPham.anh,
                                kichThuoc: 56,
                              ),
                              title: Text(
                                sanPham.ten,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                sanPham.moTa,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                dinhDangGia(sanPham.gia),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48),
          const SizedBox(height: 12),
          Text(message),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

class AlbumTab extends StatelessWidget {
  final List<SanPham> products;

  const AlbumTab({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('Chưa có sản phẩm để hiển thị'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final sanPham = products[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: AnhSanPham(duongDan: sanPham.anh)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sanPham.ten,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(dinhDangGia(sanPham.gia)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnhSanPham extends StatelessWidget {
  final String duongDan;
  final double? kichThuoc;

  const AnhSanPham({
    super.key,
    required this.duongDan,
    this.kichThuoc,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      duongDan,
      width: kichThuoc,
      height: kichThuoc,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: kichThuoc,
        height: kichThuoc,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}
