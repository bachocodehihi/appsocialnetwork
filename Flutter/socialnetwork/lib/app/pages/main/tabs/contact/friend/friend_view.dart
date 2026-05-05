import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/pages/main/tabs/contact/friend/friend_controller.dart';
import 'package:socialnetwork/data/repositories/contact_repository_imp.dart';
import 'package:socialnetwork/data/network/api/contact_api.dart';
import 'package:socialnetwork/data/network/dio_client.dart';
import 'package:socialnetwork/domain/usecases/contact/contact_usecase.dart';
class ContactFriendView extends StatefulWidget {
  const ContactFriendView({super.key});
  @override
  State<ContactFriendView> createState() => _ContactFriendViewState();
}

class _ContactFriendViewState extends State<ContactFriendView> {
  late final ContactFriendController _controller;

  @override
  void initState() {
    super.initState();

    final repository = ContactRepositoryImp(ContactApi(DioClient.createDio()));
    final usecase = ContactUsecase(repository);
    _controller = ContactFriendController(usecase);
    
    _controller.fetchFriends();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        if (_controller.isLoading) return Center(child: CircularProgressIndicator());
        if (_controller.error != null) return Center(child: Text('Lỗi: ${_controller.error}'));
        
        final friends = _controller.friends;
        if (friends.isEmpty) return Center(child: Text('No friends found'));
        
        return ListView.separated(
          itemCount: friends.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final friend = friends[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: friend['avatar'] != null 
                  ? NetworkImage(friend['avatar']) 
                  : null,
                child: friend['avatar'] == null 
                  ? Text(friend['name']!.substring(0, 1)) 
                  : null,
              ),
              title: Text(friend['name']!),
              subtitle: Text(friend['status']!),
              trailing: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(Colors.grey[300]),
                ),
                child: const Text('Message'),
              ),
            );
          },
        );
      },
    );
  }
}
