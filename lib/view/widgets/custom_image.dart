import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageType { asset, network, file }

class CustomImage extends StatelessWidget {
  const CustomImage(this.image,
      {super.key,
      this.imageType = ImageType.asset,
      this.width = 100,
      this.height = 100,
      this.fit = BoxFit.cover,
      this.radius = 0,
      this.padding = 0,
      this.bgColor,
      this.borderRadius,
      this.isBoxShadow = true});
  final String image;
  final ImageType imageType;
  final double width;
  final double height;
  final double padding;
  final Color? bgColor;
  final double radius;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final bool isBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        boxShadow: [
          if (isBoxShadow)
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: .3,
              blurRadius: .3,
              offset: const Offset(0, .5), // changes position of shadow
            ),
        ],
      ),
      child: checkImageType(),
    );
  }

  Widget checkImageType() {
    Widget child;
    switch (imageType) {
      case ImageType.network:
        child = CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => const BlankImageWidget(),
          errorWidget: (context, url, error) => const BlankImageWidget(),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
              image: DecorationImage(image: imageProvider, fit: fit),
            ),
          ),
        );
        break;
      case ImageType.file:
        child = Image.file(File(image));
        break;
      default:
        child = Image(
          image: AssetImage(image),
          fit: fit,
        );
        break;
    }
    return child;
  }
}

class BlankImageWidget extends StatelessWidget {
  const BlankImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0),
      child: Center(
        child: SizedBox(
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            elevation: 0.0,
          ),
        ),
      ),
    );
  }
}
