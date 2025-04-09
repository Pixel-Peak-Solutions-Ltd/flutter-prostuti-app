// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
//
// import '../../../core/configs/app_colors.dart';
//
//
// class LeaderboardSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 8),
//         LeaderboardCard(
//           name: 'শিক্ষার্থী নিশাত',
//           score: '২৩০২',
//           rank: 'assets/icons/leaderboard_first_icon.png',
//           image: 'assets/images/test_dp.jpg',
//           backgroundColor: AppColors.leaderboardFirstLight,
//         ),
//         LeaderboardCard(
//           name: 'শিক্ষার্থী সুমন',
//           score: '২৪৫৯',
//           rank: 'assets/icons/leaderboard_second_icon.png',
//           image: 'assets/images/test_dp.jpg',
//           backgroundColor: AppColors.leaderboardSecondLight,
//         ),
//         LeaderboardCard(
//           name: 'শিক্ষার্থী সানজিদা',
//           score: '২২৯৭',
//           rank: 'assets/icons/leaderboard_third_icon.png',
//           image: 'assets/images/test_dp.jpg',
//           backgroundColor: AppColors.leaderboardThirdLight,
//         ),
//       ],
//     );
//   }
// }
//
// class LeaderboardCard extends StatefulWidget {
//   final String name;
//   final String score;
//   final String rank;
//   final String image;
//   final Color backgroundColor;
//
//   const LeaderboardCard(
//       {super.key,
//         required this.name,
//         required this.score,
//         required this.rank,
//         required this.image,
//         required this.backgroundColor});
//
//   @override
//   State<LeaderboardCard> createState() => _LeaderboardCardState();
// }
//
// class _LeaderboardCardState extends State<LeaderboardCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: widget.backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Image.asset(
//             widget.rank.toString(),
//             height: 36,
//             width: 36,
//           ),
//           CircleAvatar(
//             backgroundImage: AssetImage(
//               widget.image.toString(),
//             ),
//           ),
//           Text(widget.name, style: TextStyle(fontSize: 16)),
//           const Gap(10),
//           Text('${widget.score} মার্কস', style: TextStyle(fontSize: 16)),
//           const Gap(25),
//         ],
//       ),
//     );
//   }
// }
