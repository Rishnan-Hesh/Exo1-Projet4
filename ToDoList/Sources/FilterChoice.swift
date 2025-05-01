enum FilterChoice: String, CaseIterable, Identifiable {
    case all
    case completed
    case notCompleted

    var id: String {
        self.rawValue
    }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .completed:
            return "Completed"
        case .notCompleted:
            return "Not Completed"
        }
    }
}
