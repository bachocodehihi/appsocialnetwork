import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/main/tabs/contact/group/group_controller.dart';

class ContactGroupView extends StatefulWidget {
  const ContactGroupView({super.key});

  @override
  State<ContactGroupView> createState() => _ContactGroupViewState();
}

class _ContactGroupViewState extends State<ContactGroupView> {
  late ContactGroupController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContactGroupController();
    _controller.fetchGroups();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: cs.error),
                SizedBox(height: 8.h),
                Text(
                  'Lỗi: ${_controller.error}',
                  style: TextStyle(color: cs.error),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: _controller.fetchGroups,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Your groups',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _controller.goToCreateGroup(context),
                  icon: Icon(Icons.add_circle_outlined,
                      size: 25.sp, color: cs.primary),
                  label: Text(
                    'Create',
                    style: TextStyle(fontSize: 15.sp, color: cs.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            if (_controller.groups.isEmpty)
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Icon(Icons.group_outlined,
                        size: 48, color: cs.onSurfaceVariant),
                    SizedBox(height: 8.h),
                    Text(
                      'No groups yet',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

            ..._controller.groups.map((group) {
              final members = group['members'] as List? ?? [];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundImage: group['avatar'] != null &&
                          group['avatar'].toString().isNotEmpty
                      ? NetworkImage(group['avatar'])
                      : null,
                  backgroundColor: cs.primaryContainer,
                  child: group['avatar'] == null ||
                          group['avatar'].toString().isEmpty
                      ? Text(
                          group['name'].toString().substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  group['name'] ?? '',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${members.length} members',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                onTap: () {
                },
                trailing: ElevatedButton(
                  onPressed: () => _controller.goToChat(context, group),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                  ),
                  child: const Text('Message'),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}