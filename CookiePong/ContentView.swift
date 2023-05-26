import SwiftUI

struct ContentView: View {
    @State private var racketPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
    @State private var ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var ballVelocity = CGVector(dx: 3.0, dy: -3.0)
    @State private var isGamePaused = false
    private let racketWidth: CGFloat = 100
    private let racketHeight: CGFloat = 20
    private let ballRadius: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.green
                
                // Draw the racket
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: racketWidth, height: racketHeight)
                    .position(racketPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let racketX = max(min(gesture.location.x, geometry.size.width - racketWidth / 2), racketWidth / 2)
                                racketPosition = CGPoint(x: racketX, y: racketPosition.y)
                            }
                    )
                
                // Draw the ball
                Circle()
                    .foregroundColor(.white)
                    .frame(width: ballRadius * 2, height: ballRadius * 2)
                    .position(ballPosition)
                    .onAppear {
                        startAnimatingBall()
                    }
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $isGamePaused) {
                Alert(
                    title: Text("Game Over"),
                    message: Text("Tap the screen to continue"),
                    dismissButton: .default(Text("Play")) {
                        startAnimatingBall()
                    }
                )
            }
//            .onTapGesture {
//                if isGamePaused {
//                    startAnimatingBall()
//                }
//            }
        }
    }
    
    private func startAnimatingBall() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            ballPosition.x += ballVelocity.dx
            ballPosition.y += ballVelocity.dy
            
            // Check ball collision with walls
            if ballPosition.x <= ballRadius || ballPosition.x >= UIScreen.main.bounds.width - ballRadius {
                ballVelocity.dx *= -1
            }
            if ballPosition.y <= ballRadius {
                ballVelocity.dy *= -1
            }
            
            // Check ball collision with the racket
            if ballPosition.y + ballRadius >= racketPosition.y - racketHeight / 2 && ballPosition.y - ballRadius <= racketPosition.y + racketHeight / 2 && ballPosition.x >= racketPosition.x - racketWidth / 2 && ballPosition.x <= racketPosition.x + racketWidth / 2 {
                ballVelocity.dy *= -1
            }
            
            // Check if ball goes below the screen
            if ballPosition.y > UIScreen.main.bounds.height {
                isGamePaused = true
                
            }
        }
        timer.fire()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
