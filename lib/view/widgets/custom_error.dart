import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_app/core/utils/app_asset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Lottie.asset(AppAsset.errorBuilder),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                kDebugMode
                    ? errorDetails.summary.toString()
                    : AppLocalizations.of(context)!.somethingWentWrong,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.weApologizeForTheInconvenience,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                AppLocalizations.of(context)!
                    .weAreWorkingToResolveTheIssueAsQuicklyAsPossible,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
