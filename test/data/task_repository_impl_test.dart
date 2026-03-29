import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_project/core/error/app_exception.dart';
import 'package:task_project/data/datasources/remote/task_remote_datasource.dart';
import 'package:task_project/data/models/task_model.dart';
import 'package:task_project/data/repositories/task_repository_impl.dart';
import 'package:task_project/domain/entities/task.dart';

class MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

void main() {
  late MockTaskRemoteDataSource mockDataSource;
  late TaskRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockTaskRemoteDataSource();
    repository = TaskRepositoryImpl(mockDataSource);
  });

  final fakeModel = TaskModel(
    id: '1',
    title: 'Redesign onboarding flow',
    description: 'Update first-run experience',
    priority: 'high',
    statusCode: 'in_progress',
    tags: ['ux', 'mobile'],
    commentCount: 4,
    attachmentCount: 2,
    subTasks: const [],
    dueDate: '2026-04-10',
    assigneeId: '2',
    projectId: '1',
  );

  group('TaskRepositoryImpl.getTasks', () {
    test('maps DTO list to domain entity list', () async {
      when(() => mockDataSource.getTasks()).thenAnswer((_) async => [fakeModel]);

      final result = await repository.getTasks();

      expect(result, isA<List<Task>>());
      expect(result.first.title, 'Redesign onboarding flow');
      expect(result.first.priority, TaskPriority.high);
      expect(result.first.status, TaskStatus.inProgress);
      expect(result.first.tags, ['ux', 'mobile']);
    });

    test('rethrows AppException from data source', () async {
      when(() => mockDataSource.getTasks()).thenThrow(const NetworkException());

      expect(() => repository.getTasks(), throwsA(isA<NetworkException>()));
    });

    test('wraps unknown exceptions in UnknownException', () async {
      when(() => mockDataSource.getTasks()).thenThrow(Exception('mystery'));

      expect(() => repository.getTasks(), throwsA(isA<UnknownException>()));
    });
  });

  group('TaskRepositoryImpl.getTaskById', () {
    test('maps single DTO to domain entity', () async {
      when(() => mockDataSource.getTaskById('1')).thenAnswer((_) async => fakeModel);

      final result = await repository.getTaskById(1);

      expect(result.id, 1);
      expect(result.title, 'Redesign onboarding flow');
    });

    test('rethrows NotFoundException from data source', () async {
      when(() => mockDataSource.getTaskById('99')).thenThrow(const NotFoundException());

      expect(() => repository.getTaskById(99), throwsA(isA<NotFoundException>()));
    });
  });
}
