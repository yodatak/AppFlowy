import 'package:app_flowy/workspace/domain/i_workspace.dart';
import 'package:flowy_sdk/protobuf/flowy-workspace/app_create.pb.dart';
import 'package:flowy_sdk/protobuf/flowy-workspace/errors.pb.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

part 'menu_watch.freezed.dart';

class MenuWatchBloc extends Bloc<MenuWatchEvent, MenuWatchState> {
  final IWorkspaceWatch watcher;
  MenuWatchBloc(this.watcher) : super(const MenuWatchState.initial());

  @override
  Stream<MenuWatchState> mapEventToState(MenuWatchEvent event) async* {
    yield* event.map(
      started: (_) async* {
        watcher.startWatching(
          addAppCallback: (appsOrFail) => _handleAppsOrFail(appsOrFail),
        );
      },
      appsReceived: (e) async* {
        yield e.appsOrFail.fold(
          (apps) => MenuWatchState.loadApps(apps),
          (error) => MenuWatchState.loadFail(error),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await watcher.stopWatching();
    return super.close();
  }

  void _handleAppsOrFail(Either<List<App>, WorkspaceError> appsOrFail) {
    appsOrFail.fold(
      (apps) => add(MenuWatchEvent.appsReceived(left(apps))),
      (error) => add(MenuWatchEvent.appsReceived(right(error))),
    );
  }
}

@freezed
abstract class MenuWatchEvent with _$MenuWatchEvent {
  const factory MenuWatchEvent.started() = _Started;
  const factory MenuWatchEvent.appsReceived(
      Either<List<App>, WorkspaceError> appsOrFail) = AppsReceived;
}

@freezed
abstract class MenuWatchState with _$MenuWatchState {
  const factory MenuWatchState.initial() = _Initial;

  const factory MenuWatchState.loadApps(
    List<App> apps,
  ) = _LoadApps;

  const factory MenuWatchState.loadFail(
    WorkspaceError error,
  ) = _LoadFail;
}