import 'package:actual/common/const/colors.dart';
import 'package:actual/rating/model/rating_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  // NetworkImage, AssetImage 등
  final ImageProvider avatarImage;
  final int rating;
  final String email;
  final String content;
  final List<Image> images;

  RatingCard({
    super.key,
    required this.avatarImage,
    required this.rating,
    required this.email,
    required this.content,
    this.images = const [],
  });

  factory RatingCard.fromModel(RatingModel model) {
    return RatingCard(
      avatarImage: NetworkImage(model.user.imageUrl),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
      images: model.imgUrls.map((e) => Image.network(e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          rating: rating,
          email: email,
        ),
        _Body(
          content: content,
        ),
        if (images.length > 0)
          SizedBox(
            height: 130,
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header({
    super.key,
    required this.avatarImage,
    required this.rating,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: BODY_TEXT_COLOR,
            ),
          ),
        )
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: images
            .mapIndexed(
              (index, e) => Padding(
                padding: EdgeInsets.only(
                    right: index == images.length - 1 ? 0 : 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: e,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
