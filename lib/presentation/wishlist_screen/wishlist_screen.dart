import '../wishlist_screen/widgets/productcontainer_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:ryan_dedi_pratama_s_application1/core/app_export.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/app_bar/appbar_leading_image.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/app_bar/appbar_title.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/app_bar/custom_app_bar.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class WishlistScreen extends StatelessWidget {
  WishlistScreen({Key? key}) : super(key: key);

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 3.v),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.only(left: 25.h, right: 27.h),
                      child: CustomSearchView(controller: searchController)),
                  SizedBox(height: 20.v),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 25.h),
                          child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "4",
                                    style: CustomTextStyles
                                        .titleSmallMontserratBlack900Bold),
                                TextSpan(
                                    text: " Items",
                                    style: CustomTextStyles
                                        .titleSmallMontserratBlack900Bold)
                              ]),
                              textAlign: TextAlign.left))),
                  SizedBox(height: 14.v),
                  _buildProductContainer(context)
                ]))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 52.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeft,
            margin: EdgeInsets.only(left: 24.h, top: 14.v, bottom: 13.v),
            onTap: () {
              onTapArrowLeft(context);
            }),
        centerTitle: true,
        title: AppbarTitle(text: "Wishlist"));
  }

  /// Section Widget
  Widget _buildProductContainer(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 1.h),
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 257.v,
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.h),
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return ProductcontainerItemWidget();
            }));
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
