import 'package:flutter/material.dart';
import 'package:cliff_pickleball/features/auth/screens/login_screen.dart';
import 'package:cliff_pickleball/features/community/screens/add_mod_screen.dart';
import 'package:cliff_pickleball/features/community/screens/community_screen.dart';
import 'package:cliff_pickleball/features/community/screens/create_community_screen.dart';
import 'package:cliff_pickleball/features/community/screens/edit_community_screen.dart';
import 'package:cliff_pickleball/features/community/screens/mod_tool_screen.dart';
import 'package:cliff_pickleball/features/home/home_screen.dart';
import 'package:cliff_pickleball/features/post/screens/add_post_type_screen.dart';
import 'package:cliff_pickleball/features/post/screens/comment_screen.dart';
import 'package:cliff_pickleball/features/user/screens/edit_profile_screen.dart';
import 'package:cliff_pickleball/features/user/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/create-community': (_) => const MaterialPage(
          child: CreateCommunityScreen(),
        ),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditUserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
            type: routeData.pathParameters['type']!,
          ),
        ),
    '/post/:postId/comments': (routeData) => MaterialPage(
          child: CommentsScreen(
            postId: routeData.pathParameters['postId']!,
          ),
        ),
  },
);
