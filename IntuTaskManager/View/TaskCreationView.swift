import SwiftUI

struct TaskCreationView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var taskPriority: String = "low"
    @State private var selectedDueDate = Date()
    @EnvironmentObject var coreDataVm: CoreDataViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading, spacing: 20){
            
                Section(header: Text("Task Title")) {
                    TextField("Enter Task Title", text: $title)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
            
                Section(header: Text("Task Description")) {
                    TextField("Enter Task Description", text: $description)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                }
                Section(header: Text("Task Priority")) {
                    Picker("Priority", selection: $taskPriority) {
                        Text("Low").tag("low")
                        Text("Medium").tag("medium")
                        Text("High").tag("high")
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .background(Color("celadonGreen"))
                    .cornerRadius(10)
                    
                }
                
                Section(header: Text("Task Due Date")) {
                    DatePicker("Select Due Date", selection: $selectedDueDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                        .accentColor(.black)
                }
            }
            .navigationTitle("Create Task")
            .navigationBarItems(trailing: Button("Save", action: {
                if title.isEmpty || description.isEmpty {
                    showAlert = true
                } else {
                    coreDataVm.addTask(title: title,
                                       desc: description,
                                       priority: taskPriority,
                                       dueDate: selectedDueDate)
                    dismiss()
                }
            }))
            .padding()
        }
        .toolbarBackground(Color("darkCyan"), for: .navigationBar)
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        .background(Color("darkCyan"))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Missing Information"),
                  message: Text("Both title and description are required."),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    TaskCreationView()
}
