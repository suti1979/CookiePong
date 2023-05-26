import SwiftUI

struct ContentView: View {
    @State private var racketPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
    @State private var ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @State private var ballVelocity = CGVector(dx: 3.0, dy: -3.0)
    @State private var isGamePaused = false
    @State private var currentFruit = "🍏"
    @State private var fruitPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    @State private var deathCount = 0
    @State private var hitCount = -1
    
    private let racketWidth: CGFloat = 100
    private let racketHeight: CGFloat = 20
    private let ballRadius: CGFloat = 18
    
    private let fruits: [String] = ["🍔","🍕","🍗","🥩","🌮","🍟"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.green
                
                Text("Hit: \(hitCount)").position(x:40, y:40).bold()
                Text("Lost: \(deathCount)").position(x: UIScreen.main.bounds.width - 42, y:40).bold()
                
                Capsule()
                    .fill(LinearGradient(
                        gradient: .init(colors: [.brown, .black]),
                        startPoint: .init(x: 0.5, y: 0.5),
                        endPoint: .init(x: 0.5, y: 1)
                    ))
                
                    .frame(width: racketWidth, height: racketHeight)
                    .position(racketPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let racketX = max(min(gesture.location.x, geometry.size.width - racketWidth / 2), racketWidth / 2)
                                racketPosition = CGPoint(x: racketX, y: racketPosition.y)
                            }
                    )
                
                Text("🍪")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .frame(width: ballRadius * 2, height: ballRadius * 2)
                    .position(ballPosition)
                    .onAppear {
                        startAnimatingBall()
                        fruitPosition = randomFruitPosition()
                        currentFruit = randomFruit()
                    }
                
                
                Text(currentFruit)
                    .font(.system(size: 50))
                    .position(fruitPosition)
                
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $isGamePaused) {
                Alert(
                    title: Text("Don't Panic!"),
                    message: Text("Press cookie continue"),
                    dismissButton: .default(Text("🍪")) {
                        startAnimatingBall()
                    }
                )
            }
        }
    }
    
    private func startAnimatingBall() {
        // Reset ball position and velocity
        ballPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        ballVelocity = CGVector(dx: 3.0, dy: -3.0)
        
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if isGamePaused {
                timer?.invalidate()
                timer = nil
                return
            }
            
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
                deathCount += 1
            }
            
            if fruitHit(ballPosition: ballPosition, fruitPosition: fruitPosition) {
                hitCount += 1
                fruitPosition = randomFruitPosition()
                currentFruit = randomFruit()
            }
            
        }
        timer?.fire()
    }
    
    private func fruitHit(ballPosition: CGPoint, fruitPosition: CGPoint) -> Bool {
        let distance = sqrt(pow(ballPosition.x - fruitPosition.x, 2) + pow(ballPosition.y - fruitPosition.y, 2))
        return distance <= ballRadius * 2
    }
    
    private func randomFruit() -> String {
        return fruits.randomElement() ?? ""
    }
    
    private func randomFruitPosition() -> CGPoint {
        let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        let y = CGFloat.random(in: 0...UIScreen.main.bounds.height / 2)
        return CGPoint(x: x, y: y)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
