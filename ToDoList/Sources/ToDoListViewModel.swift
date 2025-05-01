import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType

    // MARK: - Properties

    @Published
    var selectedFilter: FilterChoice = .all

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository

        toDoItems = repository.loadToDoItems()

        applyFilter()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    private var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    @Published
    var filteredItems = [ToDoItem]()

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)

        applyFilter()
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()

            applyFilter()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }

        applyFilter()
    }

    /// Apply the filter to update the list.
    func applyFilter() {
        switch selectedFilter {
        case .all:
            filteredItems = toDoItems

        case .completed:
            filteredItems = toDoItems.filter { item in
                item.isDone
            }

        case .notCompleted:
            filteredItems = toDoItems.filter { item in
                !item.isDone
            }
        }
    }
}
