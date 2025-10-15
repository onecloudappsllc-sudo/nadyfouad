import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';

class PaginatedListWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  const PaginatedListWidget({
    Key? key, required this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.itemView, this.enabledPagination = true, this.reverse = false, this.limit = 10,
  }) : super(key: key);

  @override
  State<PaginatedListWidget> createState() => _PaginatedListWidgetState();
}

class _PaginatedListWidgetState extends State<PaginatedListWidget> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent
          && widget.totalSize != null && !_isLoading && widget.enabledPagination) {
        if(mounted && !ResponsiveHelper.isDesktop(context)) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();
    if (_offset! < pageSize && !_offsetList.contains(_offset!+1)) {

      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for(int index=1; index<=widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    return Column(children: [

      widget.reverse ? const SizedBox() : widget.itemView,

      (ResponsiveHelper.isDesktop(context) && (widget.totalSize == null || _offset! >= (widget.totalSize! / 10).ceil() || _offsetList.contains(_offset!+1))) ? SizedBox(
        height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0,
      ) : Center(child: Padding(
        padding: (_isLoading || ResponsiveHelper.isDesktop(context)) ?  const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        child: _isLoading ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : (ResponsiveHelper.isDesktop(context) && widget.totalSize != null) ? InkWell(
          onTap: _paginate,
          child: Container(
            width: 150,
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeSmall,
              horizontal: Dimensions.paddingSizeLarge,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Text(getTranslated('see_more', context), style: poppinsMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).primaryColor,
            )),

          ),
        ) : const SizedBox(),
      )),

      widget.reverse ? widget.itemView : const SizedBox(),

    ]);
  }
}
