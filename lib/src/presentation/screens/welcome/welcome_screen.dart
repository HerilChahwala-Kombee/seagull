import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/asset_constant.dart';
import '../../../core/constants/color_constant.dart';
import '../../../core/constants/app_string_constant.dart';
import '../../../core/constants/dimension_constant.dart';
import '../../../core/routers/my_app_route_constant.dart';
import 'widget/feature_item.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(DimensionConstant.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: DimensionConstant.paddingXXL),
                Center(
                  child: SvgPicture.asset(
                    AssetConstant.appLogo,
                    height: DimensionConstant.logoM,
                  ),
                ),
                const SizedBox(height: DimensionConstant.paddingXL),
                Text(
                  AppStringConstant.welcomeTitle,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DimensionConstant.paddingXS),
                Text(
                  AppStringConstant.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DimensionConstant.paddingXXL),
                const FeatureItem(
                  icon: AssetConstant.collaborationIcon,
                  title: AppStringConstant.featureCollaborationTitle,
                  description: AppStringConstant.featureCollaborationDesc,
                ),
                const SizedBox(height: DimensionConstant.paddingM),
                const FeatureItem(
                  icon: AssetConstant.securityIcon,
                  title: AppStringConstant.featureSecurityTitle,
                  description: AppStringConstant.featureSecurityDesc,
                ),
                const SizedBox(height: DimensionConstant.paddingM),
                const FeatureItem(
                  icon: AssetConstant.analyticsIcon,
                  title: AppStringConstant.featureAnalyticsTitle,
                  description: AppStringConstant.featureAnalyticsDesc,
                ),
                const SizedBox(height: DimensionConstant.paddingXXL),
                ElevatedButton(
                  onPressed: () => context.go(Routes.register),
                  child: Text(AppStringConstant.signUp),
                ),
                const SizedBox(height: DimensionConstant.paddingM),
                OutlinedButton(
                  onPressed: () => context.go(Routes.login),
                  child: Text(AppStringConstant.login),
                ),
                const SizedBox(height: DimensionConstant.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: DimensionConstant.paddingXS),
                          child: SvgPicture.asset(
                            AssetConstant.starFilled,
                            height: DimensionConstant.iconXS,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: DimensionConstant.paddingS),
                    Text(
                      AppStringConstant.rating,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: DimensionConstant.paddingS),
                    Text(
                      AppStringConstant.downloads,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
