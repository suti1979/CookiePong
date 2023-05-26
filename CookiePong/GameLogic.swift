import Foundation
import UIKit

class GameLogic: ObservableObject {
    @Published var racketPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
    @Published var cookiePosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    @Published var cookieVelocity = CGVector(dx: 3.0, dy: -3.0)
    @Published var isGamePaused = false
    @Published var currentFood = ""
    @Published var foodPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    @Published var lostCount = 0
    @Published var hitCount = -1
    
    let racketWidth: CGFloat = 100
    let racketHeight: CGFloat = 20
    let cookieRadius: CGFloat = 18
    let foodSize: CGFloat = 50
    
    private let food: [String] = ["🍔","🍕","🍗","🥩","🌮","🌭"]
    
    private var timer: Timer?
    
    func startAnimatingBall() {
        self.cookiePosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        self.cookieVelocity = CGVector(dx: 3.0, dy: -3.0)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isGamePaused {
                self.timer?.invalidate()
                self.timer = nil
                return
            }
            
            self.cookiePosition.x += self.cookieVelocity.dx
            self.cookiePosition.y += self.cookieVelocity.dy
            
            // Check cookie collision with walls
            if self.cookiePosition.x <= self.cookieRadius || self.cookiePosition.x >= UIScreen.main.bounds.width - self.cookieRadius {
                self.cookieVelocity.dx *= -1
            }
            if self.cookiePosition.y <= self.cookieRadius {
                self.cookieVelocity.dy *= -1
            }
            
            // Check cookie collision with the racket
            if self.cookiePosition.y + self.cookieRadius >= self.racketPosition.y - self.racketHeight / 2 && self.cookiePosition.y - self.cookieRadius <= self.racketPosition.y + self.racketHeight / 2 && self.cookiePosition.x >= self.racketPosition.x - self.racketWidth / 2 && self.cookiePosition.x <= self.racketPosition.x + self.racketWidth / 2 {
                self.cookieVelocity.dy *= -1
            }
            
            // Check if cookie goes below the screen
            if self.cookiePosition.y > UIScreen.main.bounds.height {
                self.isGamePaused = true
                self.lostCount += 1
            }
            
            if self.foodHit(cookiePosition: self.cookiePosition, fruitPosition: self.foodPosition) {
                self.hitCount += 1
                self.foodPosition = self.randomFruitPosition()
                self.currentFood = self.randomFruit()
            }
        }
        
        timer?.fire()
    }
    
    private func foodHit(cookiePosition: CGPoint, fruitPosition: CGPoint) -> Bool {
        let distance = sqrt(pow(cookiePosition.x - fruitPosition.x, 2) + pow(cookiePosition.y - fruitPosition.y, 2))
        return distance <= cookieRadius * 2
    }
    
    func randomFruit() -> String {
        return food.randomElement() ?? ""
    }
    
    func randomFruitPosition() -> CGPoint {
        let x = CGFloat.random(in: foodSize...UIScreen.main.bounds.width - foodSize)
        let y = CGFloat.random(in: foodSize * 2...UIScreen.main.bounds.height / 2)
        return CGPoint(x: x, y: y)
    }
}
