import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressItemWidget extends StatelessWidget {
  final String addressTitle;
  final String addressDetails;
  const AddressItemWidget({super.key, required this.addressTitle, required this.addressDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 9.h),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [

          Icon(Icons.location_on_outlined, size: 26.sp, color: Colors.black54,),
          const WidthSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(addressTitle, style: AppStyles.black15BoldStyle.copyWith(fontSize: 18.sp),),
              const HeightSpace(5),
              Text(addressDetails, style: AppStyles.grey12MediumStyle.copyWith(fontSize: 13.sp),),
            ],
          ),

        ],
      )
    );
  }
}







