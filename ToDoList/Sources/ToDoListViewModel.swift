import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var allItems: [ToDoItem] = []  // Liste complète

    private var selectedFilterIndex = 0  // Indice du filtre sélectionné

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allItems = repository.loadToDoItems()  // Charge les items initiaux
        self.toDoItems = allItems  // Affiche la liste complète au début
    }

    // MARK: - Outputs

    /// Publisher pour la liste des tâches à afficher, filtrée en fonction de l'indice.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)  // Sauvegarde après modification
        }
    }

    // MARK: - Inputs

    /// Ajouter un nouvel élément à la liste.
    func add(item: ToDoItem) {
        allItems.append(item)
        applyFilter(at: selectedFilterIndex)  // Applique le filtre après l'ajout
    }

    /// Modifie le statut de complétion d'un élément.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isDone.toggle()  // Change le statut "done"
            applyFilter(at: selectedFilterIndex)  // Applique le filtre après modification
        }
    }

    /// Supprimer un élément de la liste.
    func removeTodoItem(_ item: ToDoItem) {
        allItems.removeAll { $0.id == item.id }  // Retire l'élément de la liste complète
        applyFilter(at: selectedFilterIndex)  // Applique le filtre après suppression
    }

    /// Applique un filtre en fonction de l'indice donné (0 = tous, 1 = non faits, 2 = terminés).
    func applyFilter(at index: Int) {
        selectedFilterIndex = index  // Mémorise le filtre sélectionné
        
        switch index {
        case 0:
            // Affiche tous les éléments
            toDoItems = allItems
        case 1:
            // Affiche uniquement les éléments non terminés
            toDoItems = allItems.filter { !$0.isDone }
        case 2:
            // Affiche uniquement les éléments terminés
            toDoItems = allItems.filter { $0.isDone }
        default:
            // Par défaut, affiche tous les éléments
            toDoItems = allItems
        }
    }
}

