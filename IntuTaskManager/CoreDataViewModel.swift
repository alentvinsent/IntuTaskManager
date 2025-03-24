import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var tasks: [TaskEntity] = []
    @Published var sortOption: SortOption = .title
    @Published var filterOption: FilterOption = .all
    @Published var completionPercentage: Double = 0.0
    
    enum SortOption: String, CaseIterable {
        case title, priority, dueDate
    }
    
    enum FilterOption: String, CaseIterable {
        case all
        case pending
        case completed
    }
    
    init() {
        self.container = NSPersistentContainer(name: "TasksContainer")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading CoreData \(error)")
            } else {
                print("Successfully loaded CoreData.")
                self.getTasks()
            }
        }
    }
    
    func getTasks() {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        
        switch filterOption {
        case .pending:
            let statusPredicate = NSPredicate(format: "status == %@", "pending")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
        case .completed:
            let statusPredicate = NSPredicate(format: "status == %@", "completed")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
        case .all:
            request.predicate = nil
        }
        
        let sortDescriptor: NSSortDescriptor
        switch sortOption {
        case .priority:
            sortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
        case .dueDate:
            sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        case .title:
            sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        }
        
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try container.viewContext.fetch(request)
            self.tasks = result
        } catch let error {
            print("Error fetching tasks... \(error)")
        }
    }
    
    func addTask(title: String, desc: String, priority: String, dueDate: Date) {
        let newTaskEntity = TaskEntity(context: container.viewContext)
        newTaskEntity.id = UUID()
        newTaskEntity.title = title
        newTaskEntity.descrip = desc
        newTaskEntity.dueDate = dueDate
        newTaskEntity.status = "pending"
        

        let priorityInt: Int
        switch priority {
        case "high":
            priorityInt = 1
        case "medium":
            priorityInt = 2
        case "low":
            priorityInt = 3
        default:
            priorityInt = 0
        }
        
        newTaskEntity.priority = Int16(priorityInt)
        
        self.tasks.append(newTaskEntity)
        saveTaskAndGetTasks()
    }
    
    func saveTaskAndGetTasks() {
        do {
            try container.viewContext.save()
            getTasks()
            self.completionPercentage = getCompletionPercentage()
        } catch let error {
            print("Error saving... \(error)")
        }
    }
    
    func updateTask(taskEntity: TaskEntity){
        saveTaskAndGetTasks()
    }
    
    func deleteTask(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = tasks[index]
        self.container.viewContext.delete(entity)
        self.saveTaskAndGetTasks()
    }
    
    func deleteTask(taskEntity: TaskEntity) {
        container.viewContext.delete(taskEntity)
        saveTaskAndGetTasks()
    }
    
    func getCompletionPercentage() -> Double {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        
        do {
            let allTasks = try container.viewContext.fetch(request)
            let completedTasks = allTasks.filter { $0.status == "completed" }.count
            let percentage = allTasks.isEmpty ? 0.0 : (Double(completedTasks) / Double(allTasks.count)) * 100
            return percentage
        } catch let error {
            print("Error fetching all tasks: \(error)")
            return 0.0
        }
    }
}
