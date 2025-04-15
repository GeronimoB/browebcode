import 'package:bro_app_to/Screens/player/request/request_notifier.dart';
import 'package:bro_app_to/components/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:bro_app_to/components/app_bar_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../agent/user_profile/user_profile_to_agent.dart';

class RequestScreen extends ConsumerStatefulWidget {
  final String userId;
  const RequestScreen({required this.userId, super.key});

  @override
  ConsumerState<RequestScreen> createState() => RequestScreenState();
}

class RequestScreenState extends ConsumerState<RequestScreen> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(requestProvider.notifier).loadRequests(widget.userId);
    });
  }

  void _onScroll() {
    if (_scrollController.offset > 50) {
      setState(() {
        _appBarColor = Colors.black.withOpacity(0.9);
      });
    } else {
      setState(() {
        _appBarColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestProvider);
    return Center(
      child: Container(
        width: 530,
        constraints: const BoxConstraints(maxWidth: 530),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SizedBox(
              width: double.infinity,
              child: AppBar(
                scrolledUnderElevation: 0,
                backgroundColor: _appBarColor,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: appBarTitle('SOLICITUDES'),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF00E050),
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 44, 44, 44),
                  Color.fromARGB(255, 0, 0, 0),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: requestState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF05FF00)),
                    ),
                  )
                : requestState.errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                        requestState.errorMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ))
                    : requestState.requests.isEmpty
                        ? const Center(
                            child: Text(
                            'No hay solicitudes disponibles',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ))
                        : ListView.builder(
                            itemCount: requestState.requests.length,
                            itemBuilder: (context, index) {
                              final request = requestState.requests[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[800],
                                  backgroundImage: request.image.isNotEmpty
                                      ? NetworkImage(request.image)
                                      : null,
                                  child: request.image.isEmpty
                                      ? const Icon(Icons.person,
                                          color: Colors.white)
                                      : null,
                                ),
                                title: Text(
                                  request.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  request.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () async {
                                        final result = await ref
                                            .read(requestProvider.notifier)
                                            .acceptRequest(
                                                request.id, widget.userId);
                                        if (result != null) {
                                          showSucessSnackBar(context, result);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final result = await ref
                                            .read(requestProvider.notifier)
                                            .rejectRequest(
                                                request.id, widget.userId);
                                        if (result != null) {
                                          showSucessSnackBar(context, result);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ),
      ),
    );
  }
}
