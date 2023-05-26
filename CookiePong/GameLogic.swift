//
//
//import Foundation
//
//func startAnimatingBall(
//    screenWidth: CGFloat, screenHeight: CGFloat,
//    racketPosition: inout CGPoint,
//                        ballPosition: inout CGPoint,
//                        ballVelocity: inout CGVector,
//                        isGamePaused: inout Bool,
//                        currentFruit: inout String,
//                        fruitPosition: inout CGPoint,
//                        deathCount: inout Int,
//                        hitCount: inout Int,
//                        ballRadius: inout CGFloat,
//                        racketWidth : inout CGFloat,
//                        racketHeight: inout CGFloat
//    
//) {
//    // Reset ball position and velocity
//    ballPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
//    ballVelocity = CGVector(dx: 3.0, dy: -3.0)
//
//    var timer: Timer?
//    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
//        if isGamePaused {
//            timer?.invalidate()
//            timer = nil
//            return
//        }
//
//        ballPosition.x += ballVelocity.dx
//        ballPosition.y += ballVelocity.dy
//
//        // Check ball collision with walls
//        if ballPosition.x <= ballRadius || ballPosition.x >= screenWidth - ballRadius {
//            ballVelocity.dx *= -1
//        }
//        if ballPosition.y <= ballRadius {
//            ballVelocity.dy *= -1
//        }
//
//        // Check ball collision with the racket
//        if ballPosition.y + ballRadius >= racketPosition.y - racketHeight / 2 && ballPosition.y - ballRadius <= racketPosition.y + racketHeight / 2 && ballPosition.x >= racketPosition.x - racketWidth / 2 && ballPosition.x <= racketPosition.x + racketWidth / 2 {
//            ballVelocity.dy *= -1
//        }
//
//        // Check if ball goes below the screen
//        if ballPosition.y > screenHeight {
//            isGamePaused = true
//            deathCount += 1
//        }
//
//        if fruitHit(ballPosition: ballPosition, fruitPosition: fruitPosition) {
//            hitCount += 1
//            fruitPosition = randomFruitPosition()
//            currentFruit = randomFruit()
//        }
//
//    }
//    timer?.fire()
//}
//
////private func fruitHit(ballPosition: CGPoint, fruitPosition: CGPoint) -> Bool {
////    let distance = sqrt(pow(ballPosition.x - fruitPosition.x, 2) + pow(ballPosition.y - fruitPosition.y, 2))
////    return distance <= ballRadius
////}
////
////private func randomFruit() -> String {
////    return fruits.randomElement() ?? ""
////}
////
////private func randomFruitPosition() -> CGPoint {
////    let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
////    let y = CGFloat.random(in: 0...UIScreen.main.bounds.height / 2)
////    return CGPoint(x: x, y: y)
////}
