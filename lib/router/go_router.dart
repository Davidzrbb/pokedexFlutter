import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandbox_app/ui/screens/sign_in.dart';
import 'package:sandbox_app/ui/screens/sign_up.dart';
import 'package:sandbox_app/ui/screens/welcome.dart';

import '../business/auth.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignIn(),
        ),
      ),
      GoRoute(
        path: '/sign_in',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignIn(),
        ),
      ),
      GoRoute(
        path: '/sign_up',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignUp(),
        ),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Welcome(),
        ),
      ),
    ],
    redirect: (context, state) async {
      if (await Auth().isSignedIn()) {
        return '/welcome';
      }
      return null;
    });
