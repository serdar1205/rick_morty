import 'package:flutter/material.dart';
import 'package:rick_morty/core/constants/colors/app_colors.dart';
import 'package:rick_morty/features/domain/entities/character_entity.dart';
import 'shimmer_image.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final CharacterEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mainbuttonColor3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 13),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: ImageWithShimmer(
                  imageUrl: item.image,
                  width: double.infinity,
                  height: 180,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.black26,
                  shape: CircleBorder(),
                  child: IconButton(
                    onPressed: onTap,
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        item.isFavorite ? Icons.star : Icons.star_border,
                        key: ValueKey(item.isFavorite),
                        color: AppColors.likeColor,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16)),
                  ),
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.species,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
