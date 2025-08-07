// File: lib/controllers/task_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/features/authentication/screens/todo_list/models/task_model.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class TaskController extends GetxController {
  final DBHelper _dbHelper = DBHelper.getInstance;

  var allTasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var searchQuery = ''.obs;
  var currentFilter = 'All'.obs;
  var currentSort = 'Due Date'.obs;
  var isMultiSelectMode = false.obs;
  var selectedTaskIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    // Listen for changes in search query, filter, or sort to re-apply logic
    debounce(
      searchQuery,
      (_) => applyFiltersAndSort(),
      time: const Duration(milliseconds: 300),
    );
    ever(currentFilter, (_) => applyFiltersAndSort());
    ever(currentSort, (_) => applyFiltersAndSort());
  }

  Future<void> fetchTasks() async {
    final tasksData = await _dbHelper.getAllTasks();
    allTasks.assignAll(tasksData.map((map) => Task.fromMap(map)).toList());
    applyFiltersAndSort();
  }

  void applyFiltersAndSort() {
    List<Task> tempFiltered = List.from(allTasks);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      tempFiltered =
          tempFiltered.where((task) {
            final title = task.title.toLowerCase();
            final subject = (task.subject ?? '').toLowerCase();
            final description = (task.description ?? '').toLowerCase();
            final query = searchQuery.toLowerCase();

            return title.contains(query) ||
                subject.contains(query) ||
                description.contains(query);
          }).toList();
    }

    // Apply category filter
    switch (currentFilter.value) {
      case 'Pending':
        tempFiltered = tempFiltered.where((task) => !task.isCompleted).toList();
        break;
      case 'Completed':
        tempFiltered = tempFiltered.where((task) => task.isCompleted).toList();
        break;
      case 'High Priority':
        tempFiltered =
            tempFiltered.where((task) => task.priority == 'High').toList();
        break;
      case 'Due Today':
        final today = DateTime.now();
        tempFiltered =
            tempFiltered.where((task) {
              final dueDate = task.dueDate;
              if (dueDate == null) return false;
              return dueDate.year == today.year &&
                  dueDate.month == today.month &&
                  dueDate.day == today.day;
            }).toList();
        break;
      case 'Overdue':
        final today = DateTime.now();
        tempFiltered =
            tempFiltered.where((task) {
              final dueDate = task.dueDate;
              if (dueDate == null) return false;
              return dueDate.isBefore(
                    DateTime(today.year, today.month, today.day),
                  ) &&
                  !task.isCompleted;
            }).toList();
        break;
    }

    // Apply sorting
    switch (currentSort.value) {
      case 'Due Date':
        tempFiltered.sort((a, b) {
          final dateA = a.dueDate;
          final dateB = b.dueDate;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateA.compareTo(dateB);
        });
        break;
      case 'Priority':
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        tempFiltered.sort((a, b) {
          final priorityA = priorityOrder[a.priority] ?? 3;
          final priorityB = priorityOrder[b.priority] ?? 3;
          return priorityA.compareTo(priorityB);
        });
        break;
      case 'Created Date':
        tempFiltered.sort((a, b) {
          final dateA = a.createdAt;
          final dateB = b.createdAt;
          return dateB.compareTo(dateA); // Newest first
        });
        break;
      case 'Alphabetical':
        tempFiltered.sort((a, b) {
          final titleA = a.title.toLowerCase();
          final titleB = b.title.toLowerCase();
          return titleA.compareTo(titleB);
        });
        break;
    }

    // Separate completed and pending tasks for display order
    final pendingTasks =
        tempFiltered.where((task) => !task.isCompleted).toList();
    final completedTasks =
        tempFiltered.where((task) => task.isCompleted).toList();

    filteredTasks.assignAll([...pendingTasks, ...completedTasks]);
  }

  Future<void> addTask(Task task) async {
    final newId = await _dbHelper.insertTask(task.toMap());
    // Assign the new ID to the task object
    final taskWithId = task.copyWith(id: newId);
    allTasks.add(taskWithId);
    applyFiltersAndSort();
    Get.snackbar(
      'Success',
      'Task added successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task.toMap(), task.id!);
    final index = allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      allTasks[index] = task;
    }
    applyFiltersAndSort();
    Get.snackbar(
      'Success',
      'Task updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> toggleTaskComplete(int taskId) async {
    final taskIndex = allTasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final updatedTask = allTasks[taskIndex].copyWith(
        isCompleted: !allTasks[taskIndex].isCompleted,
        updatedAt: DateTime.now(),
      );
      await _dbHelper.updateTask(updatedTask.toMap(), updatedTask.id!);
      allTasks[taskIndex] = updatedTask; // Update the task in the RxList
      applyFiltersAndSort(); // Re-sort/filter to reflect completion status change
    }
  }

  Future<void> deleteTask(int taskId) async {
    final taskToDelete = allTasks.firstWhere((t) => t.id == taskId);
    await _dbHelper.deleteTask(taskId);
    allTasks.removeWhere((task) => task.id == taskId);
    applyFiltersAndSort();

    Get.snackbar(
      'Deleted',
      'Task deleted',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () async {
          await _dbHelper.insertTask(taskToDelete.toMap());
          allTasks.add(taskToDelete);
          applyFiltersAndSort();
          Get.back(); // Dismiss the snackbar
        },
        child: const Text('Undo', style: TextStyle(color: Colors.white)),
      ),
    );
    // If in multi-select mode and the deleted task was selected, deselect it.
    selectedTaskIds.remove(taskId);
    if (selectedTaskIds.isEmpty) {
      isMultiSelectMode.value = false;
    }
  }

  Future<void> duplicateTask(Task task) async {
    final duplicatedTask = task.copyWith(
      id: null, // Let the database generate a new ID
      title: '${task.title} (Copy)',
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final newId = await _dbHelper.insertTask(duplicatedTask.toMap());
    final taskWithId = duplicatedTask.copyWith(id: newId);
    allTasks.add(taskWithId);
    applyFiltersAndSort();
    Get.snackbar(
      'Success',
      'Task duplicated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setReminder(Task task) {
    Get.snackbar(
      'Reminder Set',
      'Reminder set for "${task.title}" (Feature to be implemented)',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleMultiSelect(int taskId) {
    if (selectedTaskIds.contains(taskId)) {
      selectedTaskIds.remove(taskId);
    } else {
      selectedTaskIds.add(taskId);
    }
    isMultiSelectMode.value = selectedTaskIds.isNotEmpty;
  }

  void exitMultiSelectMode() {
    isMultiSelectMode.value = false;
    selectedTaskIds.clear();
  }

  Future<void> markSelectedComplete() async {
    for (final taskId in selectedTaskIds) {
      final taskIndex = allTasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final updatedTask = allTasks[taskIndex].copyWith(
          isCompleted: true,
          updatedAt: DateTime.now(),
        );
        await _dbHelper.updateTask(updatedTask.toMap(), updatedTask.id!);
        allTasks[taskIndex] = updatedTask;
      }
    }
    applyFiltersAndSort();
    exitMultiSelectMode();
    Get.snackbar(
      'Success',
      'Selected tasks marked as complete',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> deleteSelectedTasks() async {
    final tasksToDelete =
        allTasks.where((task) => selectedTaskIds.contains(task.id)).toList();
    for (final taskId in selectedTaskIds) {
      await _dbHelper.deleteTask(taskId);
    }
    allTasks.removeWhere((task) => selectedTaskIds.contains(task.id));
    applyFiltersAndSort();
    exitMultiSelectMode();

    Get.snackbar(
      'Deleted',
      '${tasksToDelete.length} tasks deleted',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: () async {
          for (final task in tasksToDelete) {
            await _dbHelper.insertTask(task.toMap());
          }
          allTasks.addAll(tasksToDelete);
          applyFiltersAndSort();
          Get.back(); // Dismiss the snackbar
        },
        child: const Text('Undo', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
  }

  void setSort(String sort) {
    currentSort.value = sort;
  }
}
