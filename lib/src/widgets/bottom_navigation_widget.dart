import 'dart:convert';
import 'dart:developer';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_consultant_for_lawyers/src/models/logged_in_lawyer_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../api_services/get_service.dart';
import '../api_services/logic.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/logged_in_user_controller.dart';
import '../controllers/sign_out_user_controller.dart';
import '../controllers/signin_controller.dart';
import '../localization/language_constraints.dart';
import '../models/logged_in_user_model.dart';
import '../repositories/lawyer_appointment_history_repo.dart';
import '../repositories/sign_out_user_repo.dart';
import '../routes.dart';
import '../screens/appointment_history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/wallet_screen.dart';
import 'appbar_widget.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final loggedInUserLogic = Get.put(LoggedInUserController());
  final signInLogic = Get.put(SigninController());
  final signOutUserLogic = Get.put(SignOutUserController());
  int _currentIndex = 1;

  @override
  void initState() {
    if (Get.find<GeneralController>().storageBox.hasData('userData')) {
      Get.find<GeneralController>().currentLawyerModel =
          GetLoggedInLawyerDataModel.fromJson(jsonDecode(
              Get.find<GeneralController>().storageBox.read('userData')));
      log("${Get.find<GeneralController>().storageBox.read('userData')} Bottom User Data");
      getMethod(context, "$getLawyerAppointmentHistory?page=1", null, true,
          getAllLawyerAppointmentHistoryRepo);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetScreens = <Widget>[
      Get.find<GeneralController>().storageBox.read('authToken') != null
          ? AppointmentHistoryScreen()
          :  Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  getTranslated("pleaseLoginToSeeAppointmentHistory", context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.appbarTextStyle2,
                ),
              ),
            ),
      HomeScreen(userWaitingOnTap: () {
        setState(() => _currentIndex = 0);
      }),
      Get.find<GeneralController>().storageBox.read('authToken') != null
          ? WalletScreen()
          :  Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  getTranslated( "pleaseLoginToSeeWallet", context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.appbarTextStyle2,
                ),
              ),
            ),
    ];
    return GetBuilder<LoggedInUserController>(builder: (loggedInUserLogic) {
      return WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          inAsyncCall: Get.find<GeneralController>().formLoaderController,
          child: Scaffold(
            backgroundColor: AppColors.white,
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                richTextSpan: TextSpan(
                  text: _currentIndex == 1
                      ? getTranslated('lawAdvisor', context)
                      : _currentIndex == 0
                          ?  getTranslated('appointmentHistory', context)
                          : _currentIndex == 2
                              ?  getTranslated('wallet', context)
                              : '',
                  style: AppTextStyles.appbarTextStyle2,
                ),
                leadingIcon: "assets/icons/Sort.png",
                leadingOnTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            body: Center(
              child: widgetScreens.elementAt(_currentIndex),
            ),
            drawer: Drawer(
              backgroundColor: AppColors.offWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                        gradient: AppColors.gradientOne), //BoxDecoration
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Get.find<GeneralController>()
                                      .storageBox
                                      .read('authToken') !=
                                  null
                              ? Get.find<GeneralController>()
                                          .currentLawyerModel!
                                          .loginInfo!
                                          .image !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: const AssetImage(
                                        "assets/icons/user-avatar.png",
                                      ),
                                      foregroundImage: NetworkImage(
                                          '$mediaUrl${Get.find<GeneralController>().currentLawyerModel!.loginInfo!.image}'),
                                      radius: 35.h,
                                      backgroundColor: AppColors.transparent,
                                      foregroundColor: AppColors.transparent,
                                    )
                                  : Image.asset(
                                      "assets/icons/user-avatar.png",
                                      height: 60.h,
                                    )
                              : Image.asset(
                                  "assets/icons/user-avatar.png",
                                  height: 60.h,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Get.find<GeneralController>()
                                          .storageBox
                                          .read('authToken') !=
                                      null
                                  ? Text(
                                      "${Get.find<GeneralController>().currentLawyerModel!.name} ",
                                      style: AppTextStyles.bodyTextStyle5,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Get.toNamed(PageRoutes.signinScreen);
                                      },
                                      child:  Text(
                                        getTranslated("signIn", context),
                                        style: AppTextStyles.bodyTextStyle5,
                                      ),
                                    ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                Get.find<GeneralController>()
                                            .storageBox
                                            .read('authToken') !=
                                        null
                                    // ? "${loggedInUserLogic.loggedInUserModel.data!.email}"
                                    ? "${Get.find<GeneralController>().currentLawyerModel!.email} "
                                    : "",
                                style: AppTextStyles.subHeadingTextStyle3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ), //DrawerHeader
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          isThreeLine: false,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -1, horizontal: -3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          leading: const ImageIcon(
                            AssetImage("assets/icons/Time.png"),
                            color: AppColors.secondaryColor,
                          ),
                          title:  Text(
                            getTranslated('scheduleAppSlots', context),

                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                          onTap: Get.find<GeneralController>()
                                      .storageBox
                                      .read('authToken') !=
                                  null
                              ? () {
                                  Get.toNamed(PageRoutes.scheduleAppSlots);
                                }
                              : () {
                                  Get.find<GeneralController>()
                                      .showMessageDialog(context);
                                },
                        ),
                        Get.find<GeneralController>()
                                    .storageBox
                                    .read('authToken') !=
                                null
                            ? ListTile(
                                isThreeLine: false,
                                dense: true,
                                visualDensity: const VisualDensity(
                                    vertical: -3, horizontal: -3),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                leading: const ImageIcon(
                                  AssetImage("assets/icons/User.png"),
                                  color: AppColors.secondaryColor,
                                ),
                                title:  Text(
                                  getTranslated('profile', context),

                                  style: AppTextStyles.subHeadingTextStyle1,
                                ),
                                onTap: () {
                                  Get.toNamed(PageRoutes.lawyerProfileScreen);
                                },
                              )
                            : const SizedBox(),
                        // ListTile(
                        //   isThreeLine: false,
                        //   dense: true,
                        //   visualDensity:
                        //       const VisualDensity(vertical: -1, horizontal: -3),
                        //   contentPadding: const EdgeInsets.symmetric(
                        //       horizontal: 12, vertical: 0),
                        //   leading: const ImageIcon(
                        //     AssetImage("assets/icons/Bell_pin.png"),
                        //     color: AppColors.secondaryColor,
                        //   ),
                        //   title: const Text(
                        //     'Notifications',
                        //     style: AppTextStyles.subHeadingTextStyle1,
                        //   ),
                        //   onTap: () {
                        //     Get.toNamed(PageRoutes.notificationsScreen);
                        //   },
                        // ),
                        // ListTile(
                        //   isThreeLine: false,
                        //   dense: true,
                        //   visualDensity:
                        //       const VisualDensity(vertical: -1, horizontal: -3),
                        //   contentPadding: const EdgeInsets.symmetric(
                        //       horizontal: 12, vertical: 0),
                        //   leading: const ImageIcon(
                        //     AssetImage("assets/icons/Wallet_alt.png"),
                        //     color: AppColors.secondaryColor,
                        //   ),
                        //   title: const Text(
                        //     'Wallet',
                        //     style: AppTextStyles.subHeadingTextStyle1,
                        //   ),
                        //   onTap: () {
                        //     setState(() => _currentIndex = 2);
                        //     Get.back();
                        //     // Get.toNamed(PageRoutes.walletScreen);
                        //   },
                        // ),
                        ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Folders_light.png"),
                              color: AppColors.secondaryColor,
                            ),
                            title:  Text(
                              getTranslated('appointmentHistory', context),

                              style: AppTextStyles.subHeadingTextStyle1,
                            ),
                            onTap: Get.find<GeneralController>()
                                        .storageBox
                                        .read('authToken') !=
                                    null
                                ? () {
                                    setState(() => _currentIndex = 0);
                                    Get.back();
                                  }
                                : () {
                                    Get.find<GeneralController>()
                                        .showMessageDialog(context);
                                  }),
                        ListTile(
                          isThreeLine: false,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -1, horizontal: -3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          leading: const ImageIcon(
                            AssetImage("assets/icons/blog-icon.png"),
                            color: AppColors.secondaryColor,
                          ),
                          title:  Text(
                            getTranslated('blogs', context),
                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                          onTap: () {
                            Get.toNamed(PageRoutes.blogsScreen);
                          },
                        ),
                        ListTile(
                          isThreeLine: false,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -1, horizontal: -3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          leading: const ImageIcon(
                            AssetImage("assets/icons/Group.png"),
                            color: AppColors.secondaryColor,
                          ),
                          title:  Text(
                            getTranslated('aboutUs', context),
                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                          onTap: () {
                            Get.toNamed(PageRoutes.aboutusScreen);
                          },
                        ),
                        ListTile(
                          isThreeLine: false,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -1, horizontal: -3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          leading: const ImageIcon(
                            AssetImage("assets/icons/Message.png"),
                            color: AppColors.secondaryColor,
                          ),
                          title:  Text(
                            getTranslated('contactUs', context),

                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                          onTap: () {
                            Get.toNamed(PageRoutes.contactusScreen);
                          },
                        ),
                        ListTile(
                          isThreeLine: false,
                          dense: true,
                          visualDensity:
                              const VisualDensity(vertical: -1, horizontal: -3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          leading: const ImageIcon(
                            AssetImage("assets/icons/Chield_alt.png"),
                            color: AppColors.secondaryColor,
                          ),
                          title: Text(
                            getTranslated('privacyPolicy', context),

                            style: AppTextStyles.subHeadingTextStyle1,
                          ),
                          onTap: () {
                            Get.toNamed(PageRoutes.privacyPolicyScreen);
                          },
                        ),

                        Get.find<GeneralController>()
                                    .storageBox
                                    .read('authToken') !=
                                null
                            ? ListTile(
                                isThreeLine: false,
                                dense: true,
                                visualDensity: const VisualDensity(
                                    vertical: -1, horizontal: -3),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                leading: const ImageIcon(
                                  AssetImage(
                                      "assets/icons/Sign_out_circle.png"),
                                  color: AppColors.secondaryColor,
                                ),
                                title:  Text(
                                  getTranslated('logout', context),
                                  style: AppTextStyles.subHeadingTextStyle1,
                                ),
                                onTap: () {
                                  signOutUserLogic
                                      .updateSignOutLoaderController(true);
                                  getMethod(context, signOutURL, null, true,
                                      signOutUserRepo);

                                  // Get.toNamed(PageRoutes.homeScreen);
                                },
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavyBar(
              selectedIndex: _currentIndex,
              backgroundColor: AppColors.offWhite,
              showElevation: true,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (index) => setState(() => _currentIndex = index),
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Folders_light.png"),
                    size: 28,
                    color: AppColors.secondaryColor,
                  ),
                  title:  Text(
                    getTranslated('apponintme', context),

                    style: AppTextStyles.bodyTextStyle2,
                  ),
                  activeColor: AppColors.primaryColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Home.png"),
                    size: 30,
                    color: AppColors.secondaryColor,
                  ),
                  title:  Text(
                    getTranslated('home', context),

                    style: AppTextStyles.bodyTextStyle2,
                  ),
                  activeColor: AppColors.primaryColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Wallet_alt.png"),
                    color: AppColors.secondaryColor,
                  ),
                  title:  Text(
                    getTranslated("wallet", context),
                    style: AppTextStyles.bodyTextStyle2,
                  ),
                  activeColor: AppColors.primaryColor,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
