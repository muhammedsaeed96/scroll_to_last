class CreateCourse extends StatelessWidget {
  CreateCourse({super.key});

  final c = Get.find<CourseController>();
  final _storageController = Get.find<StorageController>();
  final _adminController = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    final isAdmin = _storageController.userType.value == AccountType.admin;

    return PopScope(
      onPopInvoked: (_) => c.clearCourse(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          appBar: AppBar(),
          press: () {
            c.clearCourse();
            Get.back();
          },
          title: Text(
            AppStrings.createCourseStr,
            style: TextStyles.textSubHeadSemiBoldStyle,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: AppSizes.w26,
            right: AppSizes.w26,
            top: AppSizes.length24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAdmin && c.memberId == null) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppStrings.courseNameStr,
                    style: TextStyles.textMediumBodySemiBold300Style,
                  ),
                ),
                SizedBox(height: AppSizes.length4),
                Form(
                  key: c.createCourseFormKey,
                  child: CustomTextFormField(
                    digitsOnly: false,
                    hintText: AppStrings.courseNameExampleStr,
                    controller: c.courseNameController,
                    validator: (v) => v.toString().isValidText,
                  ),
                ),
                SizedBox(height: AppSizes.length14),
              ],
              Obx(
                () => ViewOnlyTextField(
                  onTap: bsSelTrainGoal,
                  val: c.currentTrainGoalTitle,
                  title: AppStrings.exerciseGoalStr,
                  pb: AppSizes.length14,
                  showArrow: true,
                ),
              ),
              Obx(
                () => ViewOnlyTextField(
                  onTap: bsSelFitnessLevel,
                  val: c.currentFitnessLevelTitle,
                  title: AppStrings.yourFitnessLevelStr,
                  pb: AppSizes.length30,
                  showArrow: true,
                ),
              ),
              Obx(
                () {
                  return ExpansionPanelList(
                    elevation: 0,
                    dividerColor: Colors.transparent,
                    // expandIconColor: AppColors.darkRiftColor_400,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) {
                      c.editExpansionStatus(index, isExpanded);
                    },
                    children: List.generate(
                      c.courseDayOfRoutines.length,
                      (dayIndex) => ExpansionPanel(
                        headerBuilder: (_, bool isExpanded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.routineDaysNames[dayIndex],
                                style: TextStyles.textLargeBodyMedium400Style,
                              ),
                              CustomInkwell(
                                radius: AppSizes.length20,
                                tap: () => c.removeDay(dayIndex),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: AppSizes.length40,
                                  height: AppSizes.length40,
                                  child: Image.asset(
                                    AssetsPath.deleteImg,
                                    width: AppSizes.length24,
                                    height: AppSizes.length24,
                                    color: AppColors.darkRiftColor_300,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        body: c.getDayOfRoutines[dayIndex].restDay
                            ? Text(
                                AppStrings.resetDayStr,
                                style:
                                    TextStyles.textLargeBodySemiBoldPurpleStyle,
                              )
                            : Column(
                                children: [
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, exerciseIndex) {
                                      return CardExerciseDetails(
                                        dayIndex: dayIndex,
                                        exerciseIndex: exerciseIndex,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: AppSizes.length16,
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: c.courseDayOfRoutines[dayIndex]
                                        .courseExercises.length,
                                  ),
                                  SizedBox(height: AppSizes.length16),
                                  ColorButton(
                                    width: double.infinity,
                                    height: AppSizes.length56,
                                    buttonText: AppStrings.addExercisesStr,
                                    backgroundColor:
                                        AppColors.darkRiftColorBgBox,
                                    iconColor: AppColors.primaryColorPurple,
                                    textStyle: TextStyles
                                        .textLargeBodySemiBoldPurpleStyle,
                                    press: () {
                                      bsExerciseSelection(c, dayIndex);
                                    },
                                    icon: true,
                                  ),
                                  SizedBox(height: AppSizes.length10),
                                ],
                              ),
                        isExpanded: c.courseDaysExpanded[dayIndex],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        _showSaveBtn ? AppSizes.length24 : AppSizes.length40,
                    right: AppSizes.w26,
                    left: AppSizes.w26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextIconOutlineButton(
                        width: (SizeConfig.screenWidth -
                                AppSizes.w26 -
                                AppSizes.w26 -
                                AppSizes.w12) *
                            0.44,
                        height: AppSizes.length56,
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.darkRiftColor_500,
                        ),
                        text: AppStrings.addDayStr,
                        press: c.addNewDay,
                      ),
                      SizedBox(width: AppSizes.w12),
                      TextIconOutlineButton(
                        width: (SizeConfig.screenWidth -
                                AppSizes.w26 -
                                AppSizes.w26 -
                                AppSizes.w12) *
                            0.56,
                        height: AppSizes.length56,
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.darkRiftColor_500,
                        ),
                        text: AppStrings.addRestDayStr,
                        press: () => c.addNewDay(true),
                      ),
                    ],
                  ),
                ),
                _showSaveBtn
                    ? ContainerBorderTopButton(
                        btnBgColor: AppColors.primaryColorPurple,
                        text: AppStrings.saveStr,
                        press: () => _saveBtnPress(context),
                        // loading: c.isLoading.value,
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  bool get _showSaveBtn {
    final dayOfRoutinesNotEmpty = c.courseDayOfRoutines.isNotEmpty;

    return dayOfRoutinesNotEmpty &&
        c.currentFitnessLevelTitle.isNotEmpty &&
        c.currentTrainGoalTitle.isNotEmpty;
  }

  //handle save btn click
  void _saveBtnPress(BuildContext context) {
    // c.selCourse.value = null;

    //create course to member user if it is id not null
    if (c.memberId != null) {
      //to clear selected course template because user edit on selected course
      //to prevent create selected course to user instead of edited course
      c.selCourse.value = null;
      _adminController.goToMemberProfileWhenCaptainSelCourseToUser();
      return;
    }

    //check current account type(Admin or User)
    final isAdmin = _storageController.userType.value == AccountType.admin;

    //if is admin then execute create course for gym method
    if (isAdmin) {
      c.createCourseForGym(context);
    } else {
      //if type user then it mean the user create course to himself
      c.createCourseToUserByHimself(context: context);
    }
  }
}
