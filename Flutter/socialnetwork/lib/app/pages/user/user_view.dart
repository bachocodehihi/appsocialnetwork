import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/user/user_controller.dart';
import 'package:socialnetwork/app/widgets/avatar/avatarfullscreen.dart';
import 'package:socialnetwork/data/enums/friend_status.dart';
import 'package:socialnetwork/app/pages/main/tabs/message/chat/user/user_page.dart';
class UserView extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserView({super.key, this.userData});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late final UserController _userController;

  @override
  void initState() {
    super.initState();
    _userController = UserController(user: widget.userData ?? {});
  }

  void _openAvatarFullScreen() { 
    if (_userController.avatarUrl.isEmpty) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => AvatarFullScreen(imageUrl: _userController.avatarUrl),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void _showRespondDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Accept'),
              onTap: () async {
                await _userController.acceptRequest();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Reject'),
              onTap: () async {
                await _userController.rejectRequest();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  void _showFriendOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Unfriend'),
              onTap: () async {
                await _userController.unfriend();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRequestedOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Cancel request'),
              onTap: () async {
                await _userController.cancelFriendRequest();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
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
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_outlined,
                          size: 25, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _openAvatarFullScreen,
                        child: Hero(
                          tag: 'avatar',
                          child: CircleAvatar(
                            radius: 50.r,
                            backgroundColor: cs.surfaceContainerHighest,
                            backgroundImage: _userController.avatarUrl.isNotEmpty
                                ? NetworkImage(_userController.avatarUrl)
                                : null,
                            child: _userController.avatarUrl.isEmpty
                                ? Icon(Icons.person_outline, 
                                    size: 50.r, color: cs.onSurfaceVariant)
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _userController.username,
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
                        _userController.friendsCount.toString(),
                        'Friends',
                        onTap: () {
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        _userController.followersCount.toString(), 
                        'Followers', 
                        onTap: () {
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        _userController.followingCount.toString(), 
                        'Following', 
                        onTap: () {
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        _userController.postCount.toString(),
                        'Posts', 
                        onTap: () {

                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {},
                    //     icon: const Icon(Icons.person_add_alt_outlined, size: 18),
                    //     label: const Text('Add friend'),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blue,
                    //       foregroundColor: Colors.white,
                    //       minimumSize: Size.fromHeight(44.h),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.r),
                    //       ),
                    //     ).copyWith(
                    //       overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: _userController,
                        builder: (context, _) {
                          switch (_userController.status) {
                            case FriendStatus.none:
                              return ElevatedButton(
                                onPressed: _userController.sendFriendRequest,
                                child: Text('Add friend'),
                              );

                            case FriendStatus.requested:
                              return ElevatedButton(
                                onPressed: () => _showRequestedOptions(),
                                child: Text('Requested'),
                              );

                            case FriendStatus.received:
                              return ElevatedButton(
                                onPressed: () => _showRespondDialog(),
                                child: Text('Respond'),
                              );

                            case FriendStatus.friend:
                              return ElevatedButton(
                                onPressed: () => _showFriendOptions(),
                                child: Text('Friend'),
                              );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatUserPage(
                                receiverId: _userController.userId,
                                receiverName: _userController.username,
                                receiverAvatar: _userController.avatarUrl,
                                isFriend: _userController.status == FriendStatus.friend,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.message_outlined, 
                          size: 18
                        ),
                        label: const Text('Message'),
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
                  'Information',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 20.h),
                if (_userController.birthday.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.cake_outlined,
                    title: 'Birthday',
                    value: _userController.birthday,
                  ),
                if (_userController.gender.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.wc_outlined,
                    title: 'Gender',
                    value: _userController.gender,
                  ),
                if (_userController.email.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: _userController.email,
                  ),
                if (_userController.address.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: _userController.address,
                  ),
                if (_userController.phone.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: _userController.phone,
                  ),
                if (_userController.job.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.work_outline_outlined,
                    title: 'Job',
                    value: _userController.job,
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
                SizedBox(height: 20.h),
              ],
            ),
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

