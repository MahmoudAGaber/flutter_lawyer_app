import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/localization/language_constraints.dart';
import 'package:resize/resize.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/general_controller.dart';
import '../controllers/lawyer_appointment_history_controller.dart';
import '../localization/LocalizationProvider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback userWaitingOnTap;
  const HomeScreen({super.key, required this.userWaitingOnTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {
  int isLawyerListSelected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 9, 18, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 30),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientOne,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                             getTranslated("welcometoLawAdvisor", context),
                            style: AppTextStyles.bodyTextStyle6,
                          ),
                          SizedBox(height: 6.h),
                          generalController.storageBox.read('authToken') != null
                              ? Row(
                                children: [

                                  Text(
                                      "${generalController.currentLawyerModel!.name.toString().capitalize}",
                                      style: AppTextStyles.bodyTextStyle5,
                                    ),
                                ],
                              )
                              : Container(),
                        ],
                      ),
                      generalController.storageBox.read('authToken') != null
                          ? Column(
                              children: [
                                 Text(
                                  getTranslated("status", context),
                                  style: AppTextStyles.bodyTextStyle6,
                                ),
                                generalController.currentLawyerModel!.loginInfo!
                                                .isOnline ==
                                            1 ||
                                        generalController.currentLawyerModel!
                                                .loginInfo!.isOnline !=
                                            null
                                    ?  Text(
                                  getTranslated("online", context),
                                        style: AppTextStyles.bodyTextStyle6,
                                      )
                                    :  Text(
                                  getTranslated("offline", context),
                                        style: AppTextStyles.bodyTextStyle6,
                                      )
                              ],
                            )
                          : const Text(
                              "",
                              style: AppTextStyles.bodyTextStyle6,
                            )
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                ListTile(
                  dense: true,
                  onTap: widget.userWaitingOnTap,
                  tileColor: AppColors.offWhite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  leading: Text(
                    "${Get.find<LawyerAppointmentHistoryController>().lawyerAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Accepted").toList().length}",
                    style: AppTextStyles.bodyTextStyle10,
                  ),
                  title: Text(
                    getTranslated("userWaiting", context),
                    style: AppTextStyles.bodyTextStyle11,
                  ),
                  trailing: Image.asset(
                    "assets/icons/Expand_right.png",
                    color: AppColors.primaryColor,
                    height: 32.h,
                  ),
                ),
                SizedBox(height: 24.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Expanded(
                //       child: Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                //         decoration: BoxDecoration(
                //             color: AppColors.offWhite,
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(color: AppColors.primaryColor)),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Align(
                //               alignment: Alignment.topRight,
                //               child: Image.asset(
                //                 "assets/icons/Wallet_alt.png",
                //                 color: AppColors.primaryColor,
                //               ),
                //             ),
                //             SizedBox(height: 4.h),
                //             Text(
                //               "\$500",
                //               style: AppTextStyles.headingTextStyle2,
                //             ),
                //             SizedBox(height: 4.h),
                //             Text(
                //               "Your Wallet Amount",
                //               style: AppTextStyles.bodyTextStyle11,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 18),
                //     Expanded(
                //       child: Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                //         decoration: BoxDecoration(
                //             color: AppColors.offWhite,
                //             borderRadius: BorderRadius.circular(10),
                //             border: Border.all(color: AppColors.primaryColor)),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Align(
                //               alignment: Alignment.topRight,
                //               child: Image.asset(
                //                 "assets/icons/Wallet_alt.png",
                //                 color: AppColors.primaryColor,
                //               ),
                //             ),
                //             SizedBox(height: 4.h),
                //             Text(
                //               "50",
                //               style: AppTextStyles.headingTextStyle2,
                //             ),
                //             SizedBox(height: 4.h),
                //             Text(
                //               "Total Invitations",
                //               style: AppTextStyles.bodyTextStyle11,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(8.w, 18.h, 8.w, 18.h),
                        decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                "assets/icons/Folders_light.png",
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${Get.find<LawyerAppointmentHistoryController>().lawyerAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList().length}",
                              style: AppTextStyles.headingTextStyle2,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              getTranslated("pendingAppointments", context),
                              style: AppTextStyles.bodyTextStyle11,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(8.w, 18.h, 8.w, 18.h),
                        decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                "assets/icons/Folders_light.png",
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${Get.find<LawyerAppointmentHistoryController>().lawyerAllAppointmentHistoryListForPagination.length}",
                              style: AppTextStyles.headingTextStyle2,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              getTranslated("totalAppointments", context),
                              style: AppTextStyles.bodyTextStyle11,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
