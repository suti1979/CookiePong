import SwiftUI

struct ContentView: View {
    @StateObject private var gameLogic = GameLogic()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg2").resizable().opacity(0.22)
                
                Text("Hit: \(gameLogic.hitCount)")
                    .position(x:40, y:80).bold()
                Text("Lost: \(gameLogic.lostCount)")
                    .position(x: UIScreen.main.bounds.width - 42, y:80).bold()
                
                Capsule()
                    .fill(LinearGradient(
                        gradient: .init(colors: [.gray, .black]),
                        startPoint: .init(x: 0.5, y: 0.42),
                        endPoint: .init(x: 0.5, y: 1)
                    ))
                    .frame(width: gameLogic.racketWidth, height: gameLogic.racketHeight)
                    .position(gameLogic.racketPosition)
                    .shadow(radius: 10)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let racketX = max(min(gesture.location.x, geometry.size.width - gameLogic.racketWidth / 2), gameLogic.racketWidth / 2)
                                gameLogic.racketPosition = CGPoint(x: racketX, y: gameLogic.racketPosition.y)
                            }
                    )
                
                Text("🍪")
                    .font(.system(size: 36))
                    .frame(width: gameLogic.cookieRadius * 2, height: gameLogic.cookieRadius * 2)
                    .position(gameLogic.cookiePosition)
                    .shadow(radius: 1)
                    .onAppear {
                        gameLogic.startAnimatingBall()
                        gameLogic.foodPosition = gameLogic.randomFruitPosition()
                        gameLogic.currentFood = gameLogic.randomFruit()
                    }
                
                Text(gameLogic.currentFood)
                    .font(.system(size: gameLogic.foodSize))
                    .position(gameLogic.foodPosition)
                    .shadow(radius: 10)
                
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $gameLogic.isGamePaused) {
                Alert(
                    title: Text("Don't Panic!"),
                    message: Text("Press cookie to continue..."),
                    dismissButton: .default(Text("🍪")) {
                        gameLogic.startAnimatingBall()
                    }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
