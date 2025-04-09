import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prostuti/core/configs/app_themes.dart';
import 'package:prostuti/features/leaderboard/model/leaderboard_model.dart';

class TopLeaderboardItem extends StatelessWidget {
  final LeaderboardData student;
  final int rank;

  const TopLeaderboardItem({
    super.key,
    required this.student,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    // Get background color and medal asset based on rank
    final bgColor = _getRankBgColor(rank, context);
    final medalAsset = _getMedalAsset(rank);

    // Get student name - handle both string IDs and StudentData objects
    final String studentName = _getStudentName(student.studentId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Medal icon - with error handling
            _buildMedalIcon(medalAsset),
            const SizedBox(width: 12),

            // Student avatar
            _buildStudentAvatar(student.studentId),
            const SizedBox(width: 12),

            // Student name
            Expanded(
              child: Text(
                studentName,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Score
            Text(
              "${student.totalScore ?? 0} মার্কস",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  /// Build medal icon with fallback
  Widget _buildMedalIcon(String assetPath) {
    return Image.asset(
      assetPath,
      width: 32,
      height: 32,
      errorBuilder: (context, error, stackTrace) {
        // Fallback widget if asset loading fails
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getMedalColor(rank),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build student avatar with fallback
  Widget _buildStudentAvatar(dynamic studentId) {
    // Check if studentId is a StudentData object with image
    if (studentId is StudentData && studentId.image?.path != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(studentId.image!.path!),
      );
    }

    // Fallback default avatar
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: const AssetImage('assets/images/test_dp.jpg'),
    );
  }

  /// Extract student name from different potential formats
  String _getStudentName(dynamic studentId) {
    if (studentId is StudentData && studentId.name != null) {
      return studentId.name!;
    } else if (studentId is String) {
      return "Student #${studentId.toString().substring(0, 5)}...";
    }
    return "Unknown Student";
  }

  Color _getRankBgColor(int rank, BuildContext context) {
    switch (rank) {
      case 1:
        return Theme.of(context).leaderboardFirst; // Peach
      case 2:
        return Theme.of(context).leaderboardSecond;
      case 3:
        return Theme.of(context).leaderboardThird;
      default:
        return Colors.white;
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  String _getMedalAsset(int rank) {
    switch (rank) {
      case 1:
        return 'assets/icons/gold_medal.png';
      case 2:
        return 'assets/icons/silver_medal.png';
      case 3:
        return 'assets/icons/bronze_medal.png';
      default:
        return 'assets/icons/bronze_medal.png';
    }
  }
}

class RegularLeaderboardItem extends StatelessWidget {
  final LeaderboardData student;
  final int rank;
  final bool isCurrentUser;

  const RegularLeaderboardItem({
    super.key,
    required this.student,
    required this.rank,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get student name - handle both string IDs and StudentData objects
    final String studentName = _getStudentName(student.studentId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFFE6EFFD) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rank number
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                rank.toString().padLeft(2, '0'),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(width: 12),

            // Student avatar
            _buildStudentAvatar(student.studentId),
            const SizedBox(width: 12),

            // Student name
            Expanded(
              child: Text(
                studentName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Score
            Text(
              "${student.totalScore ?? 0} মার্কস",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build student avatar with fallback
  Widget _buildStudentAvatar(dynamic studentId) {
    // Check if studentId is a StudentData object with image
    if (studentId is StudentData && studentId.image?.path != null) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(studentId.image!.path!),
      );
    }

    // Fallback default avatar
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: const AssetImage('assets/images/test_dp.jpg'),
    );
  }

  /// Extract student name from different potential formats
  String _getStudentName(dynamic studentId) {
    if (studentId is StudentData && studentId.name != null) {
      return studentId.name!;
    } else if (studentId is String) {
      return "Student #${studentId.toString().substring(0, 5)}...";
    }
    return "Unknown Student";
  }
}
