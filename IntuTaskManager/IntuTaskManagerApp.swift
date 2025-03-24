import SwiftUI

@main
struct IntuTaskManagerApp: App {
    @AppStorage("accentColor") private var accentColorString: String = "black"
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskHomeView()
            }
            .accentColor(colorFromString(accentColorString))
        }
    }
    
    private func colorFromString(_ colorString: String) -> Color {
           switch colorString {
           case "red":
               return .red
           case "blue":
               return .blue
           case "green":
               return .green
           case "black":
               return .black
           default:
               return .primary
           }
       }
}
