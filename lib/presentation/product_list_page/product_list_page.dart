import '../product_list_page/widgets/productcontainer1_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:ryan_dedi_pratama_s_application1/core/app_export.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/custom_elevated_button.dart';

// ignore_for_file: must_be_immutable
class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillGray,
          child: Column(
            children: [
              SizedBox(height: 23.v),
              Column(
                children: [
                  CustomElevatedButton(
                    text: "Our Collections",
                  ),
                  SizedBox(height: 14.v),
                  _buildProductContainer(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProductContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: 257.v,
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.h,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Productcontainer1ItemWidget();
        },
      ),
    );
  }
}
