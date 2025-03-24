import SwiftUI

struct TaskDetailsView: View {
    let task:TaskEntity
    @State  var title: String
    @State  var description: String
    @State  var taskPriority: String
    let initialTaskStatus: String
    @State  var taskStatus: String
    @State  var selectedDueDate: Date
    @EnvironmentObject var coreDataVm: CoreDataViewModel
    @Environment(\.dismiss) var dismiss
    @State var isUserOkToDelete: Bool = false
    @State var showAlert: Bool = false
    
    
    init(task: TaskEntity) {
        self.task = task
        
        _title = State(initialValue: task.title ?? "")
        _description = State(initialValue: task.descrip ?? "")
        switch  task.priority {
        case 1:
            _taskPriority = State(initialValue: "high")
        case 2:
            _taskPriority = State(initialValue: "medium")
        case 3:
            _taskPriority = State(initialValue: "low")
        default:
            _taskPriority = State(initialValue: "")
        }
        initialTaskStatus = (task.status ?? "pending")
        _taskStatus = State(initialValue: task.status ?? "pending")
        _selectedDueDate = State(initialValue: task.dueDate ?? Date())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading) {
                Text("You are only allowed to update current status here..")
                Section(header: Text("Task Title")) {
                    Text(title)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                Section(header: Text("Task Description")) {
                    Text(description)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                Section(header: Text("Task Priority")) {
                    Text(taskPriority)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                
                Section(header: Text("Task Status")) {
                    Text(taskStatus)
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                
                Section(header: Text("Task Due Date")) {
                    Text(selectedDueDate.formatted(date: .complete, time: .omitted))
                        .frame(maxWidth: .infinity,alignment:.leading)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                
                Section(header: Text("Current Status")) {
                    Picker("Status", selection: $taskStatus) {
                        Text("Pending").tag("pending")
                        Text("Completed").tag("completed")
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(Color("celadonGreen"))
                    .cornerRadius(10)
                    
                }
            }
            .navigationTitle("Task Details")
            .toolbarBackground(Color("darkCyan"), for: .navigationBar)
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
            .navigationBarItems(trailing: Button( taskStatusChanged ? "Update status" : "Delete task", action: {
                if taskStatusChanged {
                    task.status = self.taskStatus
                    coreDataVm.updateTask(taskEntity: task)
                    dismiss()
                }else{
                    if isUserOkToDelete == false {
                        showAlert.toggle()
                    }
                }
            }))
            .padding()
            .alert("Are you sure to delete?", isPresented: $showAlert) {
                Button("Yes", role: .destructive) {
                    coreDataVm.deleteTask(taskEntity: task)
                    dismiss()
                }
                Button("No", role: .cancel) {
                    isUserOkToDelete = false
                }
            }
        }
        .toolbarBackground(Color("darkCyan"), for: .navigationBar)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        .background(Color("darkCyan"))
    }
    
    var taskStatusChanged: Bool {
        return initialTaskStatus != taskStatus //not equal means user changed from pending to complete or complete to pending
    }
}

