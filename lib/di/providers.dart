import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/dio_client.dart';
import '../data/datasources/remote/task_remote_datasource.dart';
import '../data/datasources/remote/project_remote_datasource.dart';
import '../data/datasources/remote/user_remote_datasource.dart';
import '../data/repositories/task_repository_impl.dart';
import '../data/repositories/project_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/repositories/project_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_tasks_usecase.dart';
import '../domain/usecases/get_task_detail_usecase.dart';
import '../domain/usecases/get_projects_usecase.dart';
import '../domain/usecases/get_users_usecase.dart';
import '../domain/usecases/get_user_detail_usecase.dart';

// ── Network

final dioProvider = Provider<Dio>((ref) => DioClient.instance.dio);

// Data sources

final taskDataSourceProvider = Provider<TaskRemoteDataSource>(
  (ref) => TaskRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final projectDataSourceProvider = Provider<ProjectRemoteDataSource>(
  (ref) => ProjectRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final userDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSourceImpl(ref.watch(dioProvider)),
);

// ── Repositories (UI depends on the abstract interface, never the impl)

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(ref.watch(taskDataSourceProvider)),
);

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => ProjectRepositoryImpl(ref.watch(projectDataSourceProvider)),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.watch(userDataSourceProvider)),
);

// Use case

final getTasksUseCaseProvider = Provider(
  (ref) => GetTasksUseCase(ref.watch(taskRepositoryProvider)),
);

final getTaskDetailUseCaseProvider = Provider(
  (ref) => GetTaskDetailUseCase(ref.watch(taskRepositoryProvider)),
);

final getProjectsUseCaseProvider = Provider(
  (ref) => GetProjectsUseCase(ref.watch(projectRepositoryProvider)),
);

final getUsersUseCaseProvider = Provider(
  (ref) => GetUsersUseCase(ref.watch(userRepositoryProvider)),
);

final getProjectDetailUseCaseProvider = Provider(
  (ref) => GetProjectDetailUseCase(ref.watch(projectRepositoryProvider)),
);
final getUserDetailUseCaseProvider = Provider(
  (ref) => GetUserDetailUseCase(ref.watch(userRepositoryProvider)),
);