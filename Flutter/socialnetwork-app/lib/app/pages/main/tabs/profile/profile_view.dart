import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/app/pages/main/tabs/profile/profile_controller.dart';
import 'package:socialnetwork/app/widgets/avatar/fullscreen.dart';
import 'package:socialnetwork/app/widgets/item/information.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileController();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? 0 : 24.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.setting),
                    icon: Icon(
                      Icons.settings_outlined, 
                      size: 30.sp,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.avatar.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvatarFullScreen(imageUrl: controller.avatar),
                            ),
                          );
                        }
                      },
                      child: Hero(
                        tag: 'avatar',
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: controller.avatar.isNotEmpty
                              ? NetworkImage(controller.avatar)
                              : null,
                          child: controller.avatar.isEmpty
                              ? Icon(
                                Icons.person_outlined, 
                                size: 30.sp
                              )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      controller.username,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildStatItem(
                      controller.friendsCount.toString(),
                      'Friends',
                      onTap: () {
                        controller.goToFriends(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      controller.followersCount.toString(), 
                      'Followers', 
                      onTap: () {
                        controller.goToFollowers(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      controller.followingCount.toString(), 
                      'Following', 
                      onTap: () {
                        controller.goToFollowing(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      controller.postCount.toString(),
                      'Posts', 
                      onTap: () {

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.goToAdd(context);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Add profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(44.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.goToQRCode(context);
                      },
                      icon: const Icon(
                        Icons.qr_code_outlined, 
                        size: 18
                      ),
                      label: const Text('QR code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(44.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 20.h),

              if (controller.dob.isNotEmpty)
                InformationItem(
                  value: controller.dob,
                  title: 'Birthday', 
                  icon: Icons.cake_outlined,
                ),

              if (controller.gender.isNotEmpty)
                InformationItem(
                  value: controller.gender, 
                  title: 'Gender', 
                  icon: Icons.wc_outlined,
                ),

              if (controller.email.isNotEmpty) 
                InformationItem(
                  value: controller.email,
                  title: 'Email', 
                  icon: Icons.email_outlined,
                ),

              if (controller.address.isNotEmpty) 
                InformationItem(
                  value: controller.address, 
                  title: 'Address', 
                  icon: Icons.location_on_outlined,
                ),

              if (controller.phone.isNotEmpty) 
                InformationItem(
                  value: controller.phone, 
                  title: 'Phone', 
                  icon: Icons.phone_outlined,
                ),
                
              if (controller.job.isNotEmpty) 
                InformationItem(
                  value: controller.job, 
                  title: 'Job', 
                  icon: Icons.work_outline_outlined,
                ),

              if (controller.nationality.isNotEmpty) 
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  title: 'Nationality',
                  value: controller.email,
                ),

              SizedBox(height: 5.h),

              Text(
                'All posts',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStatItem(
    String value, 
    String label, 
    {VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ), 
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(icon, color: cs.onPrimaryContainer),
        ),
        title: Text(title, style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant)),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: cs.onSurface,
          ),
        ),
      ),
    );
  }
}

