import 'package:demo/const/space_helper.dart';
import 'package:demo/const/themes/colors.dart';
import 'package:demo/riverpod/Saving%20Tips/model/savinr_tips_model.dart';
import 'package:demo/riverpod/auth/controller/auth_controller.dart';
import 'package:demo/riverpod/auth/screen/loginscreen.dart';
import 'package:demo/riverpod/home/widgets/stepper_graph.dart';
import 'package:demo/riverpod/provider.dart';
import 'package:demo/const/widgets/internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/routes/routes.dart';
import '../Saving Tips/controller/saving_tips_controller.dart';
import 'widgets/column_graphwidget.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  List<SavingTips> data = [];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingTipsRepository = ref.watch(savingTipsRepositeryProvider);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {},
            child: Text(
              'Strompris',
              style: GoogleFonts.montserrat(
                  fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          actions: [
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
              onTap: () {
                AuthController().signout(context);
                AuthController().clearLocalData();
                Routes.pushreplace(screen: const LoginScreen());
              },
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          vSpaceMin,
          Text(
            'Price Predictor',
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.w500),
          ),
          vSpaceMedium,
          const ColumnGraphWidget(),
          vSpaceRegular,
          Text(
            'Price Graph',
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.w500),
          ),
          vSpaceRegular,
          const StepperGraphWidget(),
          vSpaceMedium,
          Text(
            'Savings Tips',
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.w500),
          ),
          vSpaceRegular,
          FutureBuilder(
              future: savingTipsRepository.getTips(),
              initialData: data,
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapShot.hasError) {
                  return InternetChecking();
                } else if (snapShot.hasData) {
                  data = snapShot.data ?? [];
                  print(data);
                  return SafeArea(
                      child: data.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: 16, left: 16),
                              child: Container(
                                  // height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, top: 8),
                                      child: Text(
                                        data.first.savingstips,
                                        style: GoogleFonts.nunitoSans(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    vSpaceRegular
                                  ])))
                          : Text("Saving Tips is Empty"));
                }
                return SizedBox();
              }),
          vSpaceRegular
        ]))));
  }
}
