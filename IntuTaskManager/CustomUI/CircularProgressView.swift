import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color("darkCyan"),
                    lineWidth: 30
                )
                .shadow(color: .black, radius: 1, x: 5, y: 5)
            
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            Text("\(Int(progress))% \ncompleted")
                .multilineTextAlignment(.center)
                .bold()
                .shadow(color: .black, radius: 5, x: 5, y: 5)
        }
    }
}
