import 'package:e_com/core/styling/app_styles.dart';
import 'package:e_com/core/widgets/spacing_widgets.dart';
import 'package:e_com/features/address/widgets/address_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Address",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            const HeightSpace(26),
            Text("Saved Address", style: AppStyles.black15BoldStyle.copyWith(fontSize: 18.sp)),
            const HeightSpace(16),
            Expanded(
              child: ListView(
                children: [

                  AddressItemWidget(addressDetails: "Example Address Details", addressTitle: "Home",),
                  const HeightSpace(11),
                  AddressItemWidget(addressDetails: "Example Address Details", addressTitle: "Office",),
                  const HeightSpace(11),
                  AddressItemWidget(addressDetails: "Example Address Details", addressTitle: "Home",),
                  const HeightSpace(11),
                  AddressItemWidget(addressDetails: "Example Address Details", addressTitle: "Office",),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
