// Chat Appointment Slots Widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/generate_schedule_slots_controller.dart';

import '../localization/language_constraints.dart';
import '../repositories/generate_appointment_schedule_slots_repo.dart';
import 'button_widget.dart';

import 'text_form_field_widget.dart';

class ChatAppointmentSlotsWidget extends StatefulWidget {
  const ChatAppointmentSlotsWidget({super.key});

  @override
  State<ChatAppointmentSlotsWidget> createState() =>
      _ChatAppointmentSlotsWidgetState();
}

class _ChatAppointmentSlotsWidgetState
    extends State<ChatAppointmentSlotsWidget> {
  final logic = Get.put(GenerateScheduleSlotsController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenerateScheduleSlotsController>(
        builder: (generateScheduleSlotsController) {
      return ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
        inAsyncCall:
            generateScheduleSlotsController.generateScheduleSlotsLoader,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 14),
                      child: Text(
                        getTranslated("consultationFee",context),
                        style: AppTextStyles.bodyTextStyle10,
                      ),
                    ),
                    TextFormFieldWidget(
                      hintText: '${getTranslated("enterYourFeesIn",context)} \$',
                      validator: (value) {
                        if ((value ?? "").isEmpty) {
                          return 'Fee is Required';
                        }
                        return null;
                      },
                      controller:
                          generateScheduleSlotsController.liveChatFeeController,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ButtonWidgetOne(
                            onTap: () {
                              generateScheduleSlotsController
                                  .updateGenerateScheduleSlotsLoader(true);
                              postMethod(
                                  context,
                                  generateAppointmentScheduleSlotsUrl,
                                  {
                                    "appointment_type_id": 3,
                                    "is_schedule_required": 0,
                                    "appointment_type": "chat",
                                    "fee": generateScheduleSlotsController
                                        .liveChatFeeController.text,
                                  },
                                  true,
                                  generateAppointmentScheduleSlotsRepo);
                            },
                            buttonText: getTranslated("save",context),
                            buttonTextStyle: AppTextStyles.bodyTextStyle8,
                            borderRadius: 10,
                            buttonColor: AppColors.primaryColor),
                      ),
                    ),
                    SizedBox(width: 18.w),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ButtonWidgetOne(
                            onTap: () {},
                            buttonText: getTranslated("reset",context),
                            buttonTextStyle: AppTextStyles.bodyTextStyle8,
                            borderRadius: 10,
                            buttonColor: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
