import SwiftUI

struct TaskHomeView: View {
    @StateObject var coreDataVm: CoreDataViewModel = CoreDataViewModel()
    @State var showSettingsSheet: Bool = false
    private let meediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack(alignment:.leading){
            List {
                VStack{
                    GeometryReader { geometry in
                        CircularProgressView(progress: coreDataVm.completionPercentage)
                            .frame(width: min(geometry.size.width, 200), height: min(geometry.size.height, 200))
                            .padding()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                }
                .frame(height: UIScreen.main.bounds.height/3)
                .frame(maxWidth: .infinity)
                .background(Color("celadonGreen"))
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
                .listRowBackground(Color("darkCyan"))
                .listRowInsets(EdgeInsets())
                .padding()
                
                // Filter and Sort Sections
                VStack(alignment:.leading){
                    Section(header: Text("Filter Tasks")) {
                        Picker("Filter by", selection: $coreDataVm.filterOption) {
                            ForEach(CoreDataViewModel.FilterOption.allCases, id: \.self) { option in
                                Text(option.rawValue.capitalized).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                        .onChange(of: coreDataVm.filterOption) { _ in
                            coreDataVm.getTasks()
                        }
                    }
                    
                    Section(header: Text("Sort Tasks")) {
                        Picker("Sort by", selection: $coreDataVm.sortOption) {
                            ForEach(CoreDataViewModel.SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue.capitalized).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .background(Color("celadonGreen"))
                        .cornerRadius(10)
                        .onChange(of: coreDataVm.sortOption) { _ in
                            coreDataVm.getTasks()
                        }
                    }
                }
                .listRowBackground(Color("darkCyan"))
                
                // Task List
                ForEach(coreDataVm.tasks) { task in
                    NavigationLink {
                        TaskDetailsView(task: task)
                            .environmentObject(coreDataVm)
                    } label: {
                        HStack{
                            if task.status == "completed"{
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.black)
                                    .overlay {
                                        Image(systemName: "checkmark.circle.fill")
                                            .resizable()
                                            .frame(width: 23, height: 23)
                                        .foregroundStyle(task.priority == 1 ? .red : task.priority == 2 ? .yellow : .green)
                                    }
                                
                                Text(task.title ?? "Unknown")
                                    .strikethrough()
                            }else{
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.black)
                                    .overlay {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 23, height: 23)
                                            .foregroundStyle(task.priority == 1 ? .red : task.priority == 2 ? .yellow : .green)
                                    }
                                Text(task.title ?? "Unknown")
                            }
                            Spacer()
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color("celadonGreen"))
                        .cornerRadius(30)
                        .shadow(color: .black, radius: 1, x: 5, y: 5)
                        .listRowBackground(Color("darkCyan"))
                        .padding(.vertical,8)
                    }
                    .padding(.leading)
                    .listRowInsets(EdgeInsets())
                    .background(Color("darkCyan"))
                }
                .onMove(perform: { indexSet, destination in
                    coreDataVm.tasks.move(fromOffsets: indexSet, toOffset: destination)
                    meediumFeedback.impactOccurred()
                })
                .onDelete { indexSet in
                    coreDataVm.deleteTask(indexSet: indexSet)
                    heavyFeedback.impactOccurred()
                }
                .background(Color("darkCyan"))
            }
            .listStyle(.plain)
            .toolbarBackground(Color("darkCyan"), for: .navigationBar)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .leading)
        .background(Color("darkCyan"))
        .navigationTitle("Intu Task View")
        .navigationBarItems(
            leading:
                VStack{
                    Image(systemName: "gearshape.fill")
                }
                .frame(width: 40, height: 40)
                .background(Color("celadonGreen"))
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
                .onTapGesture(perform: {
                    showSettingsSheet = true
                })
            
            ,
            trailing: NavigationLink(destination: {
                TaskCreationView()
                    .environmentObject(coreDataVm)
            }, label: {
                VStack{
                    Image(systemName: "plus")
                }
                .frame(width: 40, height: 40)
                .background(Color("celadonGreen"))
                .foregroundStyle(.black)
                .cornerRadius(10)
                .shadow(color: .black, radius: 1, x: 5, y: 5)
            }))
        .sheet(isPresented: $showSettingsSheet) {
            SettingsView()
                .presentationDetents([.height(150)])
        }
    }
}

struct SettingsView: View {
    @AppStorage("accentColor") private var accentColorString: String = "black"
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Select Accent Color")
                .font(.headline)
                .padding()
            
            Picker("Accent Color", selection: $accentColorString) {
                Text("Red").tag("red")
                Text("Blue").tag("blue")
                Text("Green").tag("green")
                Text("Black").tag("black")
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
        }
        .padding()
        .background(Color("celadonGreen"))
        
    }
}
