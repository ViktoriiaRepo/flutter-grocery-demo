import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuggestProduct {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  const SuggestProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });
}

class SearchSuggestInput extends StatefulWidget {
  const SearchSuggestInput({
    super.key,
    required this.fetch,
    this.hintText = 'Search Store',
    this.popupElevation = 8,
    this.popupRadius = 12,
    this.debounceMs = 300,
    this.maxVisibleItems = 5,
    this.rowHeight = 56,
    this.dividerHeight = 1,
  });

  final Future<List<SuggestProduct>> Function(String query) fetch;
  final String hintText;
  final double popupElevation;
  final double rowHeight;
  final double popupRadius;
  final int debounceMs;
  final int maxVisibleItems;
  final double dividerHeight;

  @override
  State<SearchSuggestInput> createState() => _SearchSuggestInputState();
}

class _SearchSuggestInputState extends State<SearchSuggestInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _link = LayerLink();
  final _fieldKey = GlobalKey();

  OverlayEntry? _overlay;
  Timer? _debounce;
  bool _loading = false;
  List<SuggestProduct> _items = const [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _hideOverlay();
      if (_focusNode.hasFocus && _controller.text.trim().isNotEmpty) {
        _showOrUpdateOverlay();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.debounceMs), () async {
      final q = text.trim();
      if (q.length < 2) {
        setState(() => _items = const []);
        _showOrUpdateOverlay();
        return;
      }
      setState(() => _loading = true);

      final typedBefore = _controller.text.trim();

      try {
        final list = await widget.fetch(q);
        if (!mounted || typedBefore != _controller.text.trim()) return;
        setState(() {
          _items = list;
          _loading = false;
        });
      } catch (_) {
        if (!mounted || typedBefore != _controller.text.trim()) return;
        setState(() {
          _items = const [];
          _loading = false;
        });
      }

      _showOrUpdateOverlay();
    });
  }

  void _showOrUpdateOverlay() {
    if (!_focusNode.hasFocus) return;

    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? MediaQuery.of(context).size.width;
    final fieldH = box?.size.height ?? 56;

    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (_) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hideOverlay,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: Offset(0, fieldH + 8),
              child: Material(
                elevation: widget.popupElevation,
                borderRadius: BorderRadius.circular(widget.popupRadius),
                clipBehavior: Clip.antiAlias,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: width,
                    maxWidth: width,
                  ),
                  child: _buildSuggestions(),
                ),
              ),
            ),
          ],
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_overlay!);
    } else {
      _overlay!.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  Widget _buildSuggestions() {
    if (_loading) {
      return const SizedBox(height: 56, child: Center(child: LinearProgressIndicator()));
    }
    if (_items.isEmpty) {
      return const SizedBox(height: 56, child: Center(child: Text('No results')));
    }

    final q = _controller.text.trim();
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _items.length + 1,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        if (i == _items.length) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text('See all results for "$q"'),
            onTap: () {
              _hideOverlay();
              context.goNamed('productsSearch', queryParameters: {'q': q});
            },
          );
        }
        final it = _items[i];
        return ListTile(
          leading: it.imageUrl.isEmpty
              ? const SizedBox(width: 40, height: 40)
              : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(it.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
          ),
          title: Text(it.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: it.price > 0 ? Text('\$${it.price.toStringAsFixed(2)}') : null,
          onTap: () {
            _hideOverlay();
            context.pushNamed('product', pathParameters: {'id': it.id});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: Container(
        key: _fieldKey,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onSubmitted: (v) {
            _hideOverlay();
            context.goNamed('productsSearch', queryParameters: {'q': v.trim()});
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color(0xFFF2F3F2),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
