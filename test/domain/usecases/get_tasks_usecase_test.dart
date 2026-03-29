import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_project/core/error/app_exception.dart';
import 'package:task_project/domain/entities/task.dart';
import 'package:task_project/domain/entities/sub_task.dart';
import 'package:task_project/domain/repositories/task_repository.dart';
import 'package:task_project/domain/usecases/get_tasks_usecase.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockRepo;
  late GetTasksUseCase useCase;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = GetTasksUseCase(mockRepo);
  });

  const fakeTask = Task(
    id: 1,
    title: 'Redesign onboarding flow',
    description: 'Update the first-run experience',
    priority: TaskPriority.high,
    status: TaskStatus.inProgress,
    tags: ['ux', 'mobile'],
    commentCount: 4,
    attachmentCount: 2,
    subTasks: <SubTask>[],
    dueDate: '2026-04-10',
    assigneeId: 2,
    projectId: 1,
  );

  group('GetTasksUseCase', () {
    test('returns list of tasks when repository succeeds', () async {
      when(() => mockRepo.getTasks()).thenAnswer((_) async => [fakeTask]);
      final result = await useCase.call();
      expect(result, isA<List<Task>>());
      expect(result.length, 1);
      expect(result.first.title, 'Redesign onboarding flow');
      expect(result.first.priority, TaskPriority.high);
      verify(() => mockRepo.getTasks()).called(1);
    });

    test('returns empty list when repository returns no tasks', () async {
      when(() => mockRepo.getTasks()).thenAnswer((_) async => []);
      final result = await useCase.call();
      expect(result, isEmpty);
    });

    test('propagates NetworkException from repository', () async {
      when(() => mockRepo.getTasks()).thenThrow(const NetworkException());
      expect(() => useCase.call(), throwsA(isA<NetworkException>()));
    });

    test('propagates ServerException from repository', () async {
      when(() => mockRepo.getTasks())
          .thenThrow(const ServerException(statusCode: 500));
      expect(() => useCase.call(), throwsA(isA<ServerException>()));
    });
  });
}