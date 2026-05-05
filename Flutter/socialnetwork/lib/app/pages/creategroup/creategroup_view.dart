import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/creategroup/creategroup_controller.dart';
import 'package:socialnetwork/data/network/api/contact_api.dart';
import 'package:socialnetwork/data/network/api/group_api.dart';
import 'package:socialnetwork/data/network/dio_client.dart';
import 'package:socialnetwork/data/repositories/contact_repository_imp.dart';
import 'package:socialnetwork/data/repositories/group_repository_imp.dart';
import 'package:socialnetwork/domain/usecases/contact/contact_usecase.dart';
import 'package:socialnetwork/domain/usecases/group/group_usecase.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  late final CreateGroupController _controller;
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dio = DioClient.createDio();
    final contactUsecase = ContactUsecase(ContactRepositoryImp(ContactApi(dio)));
    final groupUsecase = GroupUsecase(GroupRepositoryImp(GroupApi(dio)));
    _controller = CreateGroupController(contactUsecase, groupUsecase);
    _controller.fetchFriends();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateGroup(BuildContext context) async {
    final result = await _controller.createGroup(_groupNameController.text);
    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo nhóm thành công!')),
      );
      Navigator.pop(context, result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error ?? 'Tạo nhóm thất bại')),
      );
    }
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

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kIsWeb ? 0 : 24.w,
                vertical: 16.h,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 25,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Create group',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 24.w),
              child: TextField(
                controller: _groupNameController,
                onChanged: (_) => _controller.notifyListeners(),
                decoration: InputDecoration(
                  labelText: 'Group name',
                  hintText: 'Enter group name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final count = _controller.selectedIds.length;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 24.w),
                  child: Text(
                    count == 0
                        ? 'Select members'
                        : '$count member${count > 1 ? 's' : ''} selected',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: count == 0 ? cs.onSurfaceVariant : cs.primary,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  if (_controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_controller.error != null && _controller.friends.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: cs.error),
                          SizedBox(height: 8.h),
                          Text(
                            'Error: ${_controller.error}',
                            style: TextStyle(color: cs.error),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: _controller.fetchFriends,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final friends = _controller.friends;
                  if (friends.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline_outlined,
                              size: 48, color: cs.onSurfaceVariant),
                          SizedBox(height: 8.h),
                          Text(
                            'No friends found',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 24.w),
                    itemCount: friends.length,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      final id = friend['id'] as String;
                      final isSelected = _controller.selectedIds.contains(id);

                      return InkWell(
                        onTap: () => _controller.toggleSelect(id),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cs.primary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? cs.primary.withOpacity(0.4)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: friend['avatar'] != null
                                    ? NetworkImage(friend['avatar'])
                                    : null,
                                backgroundColor: cs.primaryContainer,
                                child: friend['avatar'] == null
                                    ? Text(
                                        friend['name']!
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: cs.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  friend['name']!,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) => _controller.toggleSelect(id),
                                activeColor: cs.primary,
                                shape: const CircleBorder(),
                                side: BorderSide(
                                  color: cs.onSurfaceVariant,
                                  width: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                final count = _controller.selectedIds.length;
                final canCreate =
                    count >= 2 && _groupNameController.text.trim().isNotEmpty;

                return Container(
                  padding: EdgeInsets.all(kIsWeb ? 16 : 24.w),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (canCreate && !_controller.isCreating)
                          ? () => _handleCreateGroup(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                        disabledBackgroundColor:
                            cs.onSurface.withOpacity(0.12),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _controller.isCreating
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.onPrimary,
                              ),
                            )
                          : Text(
                              count < 2
                                  ? 'Select at least 2 members'
                                  : 'Create group ($count members)',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}