import 'package:flutter/material.dart';
import 'package:ryan_dedi_pratama_s_application1/core/app_export.dart';
import 'package:ryan_dedi_pratama_s_application1/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class Productcontainer1ItemWidget extends StatelessWidget {
  const Productcontainer1ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle27,
            height: 163.v,
            width: 175.h,
            radius: BorderRadius.circular(
              16.h,
            ),
          ),
          SizedBox(height: 7.v),
          Padding(
            padding: EdgeInsets.only(left: 5.h),
            child: Text(
              "Produk x",
              style: theme.textTheme.titleSmall,
            ),
          ),
          SizedBox(height: 3.v),
          Container(
            width: 47.h,
            margin: EdgeInsets.only(left: 5.h),
            child: Text(
              "Keterangan\nsingkat",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodySmall8,
            ),
          ),
          SizedBox(height: 1.v),
          Padding(
            padding: EdgeInsets.only(left: 5.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.v),
                  child: Text(
                    "RP 100.000",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 36.h),
                  child: CustomIconButton(
                    height: 24.v,
                    width: 25.h,
                    padding: EdgeInsets.all(6.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFavorite,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: CustomIconButton(
                    height: 24.v,
                    width: 25.h,
                    padding: EdgeInsets.all(3.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgCart,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }
}
