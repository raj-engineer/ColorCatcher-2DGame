//
//  GameScene.swift
//  ColorCatcher
//
//  Created by Rajesh Rajesh on 21/04/23.
//

import Foundation
import SpriteKit
import SwiftUI

final class GameScene: SKScene, ObservableObject{
    // MARK: - Properties
    private let colorPalette = [UIColor.customGreen, UIColor.customRed, UIColor.customBlue, UIColor.customYellow]
    private let box = SKSpriteNode(imageNamed: "box")
    private let screenWidth  = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private var circle: SKShapeNode?
    private var rotationCount = 0
    private var randomNumber = 0
    
    @AppStorage("highScore") var highScore = 0
    @Published var currentScore = 0
    @Published var isEnabled = false
    
    // MARK: - methods
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        initialsetup()
        addBox()
        addCircle()
        physicsWorld.contactDelegate = self
    }
    
    func initialsetup() {
        backgroundColor = SKColor.white
        scene?.size =  CGSize(width: screenWidth, height: screenHeight)
        scene?.scaleMode = .fill
        scene?.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rotate90Degree()
    }
    
    private func rotate90Degree() {
        let rotateAction = SKAction.rotate(byAngle: .pi/2, duration: 0.1)
        rotationCount = rotationCount+1
        if rotationCount == 4 {
            rotationCount = 0
        }
        
        // Run the action on the sprite.
        box.run(rotateAction)
    }
    
    private func moveCircle() {
        let movePlayerAction = SKAction.moveTo(y: 10, duration: 3)
        circle?.run(movePlayerAction)
    }
    
    private func addCircle(){
        randomNumber =  Int.random(in: 0 ... 3)
        circle = SKShapeNode(circleOfRadius: 20) // Size of Circle
        circle?.position = CGPointMake(frame.midX, frame.maxY)  //Middle of Screen
        circle?.fillColor = colorPalette[randomNumber]
        
        circle?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        circle?.physicsBody?.affectedByGravity = false
        circle?.physicsBody?.restitution = 0
        circle?.physicsBody?.categoryBitMask = 1
        circle?.physicsBody?.contactTestBitMask = 2
        circle?.physicsBody?.collisionBitMask = 2
        circle?.physicsBody?.isDynamic = true
        if let _circle = circle {
            self.addChild(_circle)
            moveCircle()
        }
    }
    
    private func addBox() {
        box.position = CGPoint(x: frame.midX, y: frame.midY/2)
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.affectedByGravity = false
        box.physicsBody?.restitution = 0
        box.physicsBody?.categoryBitMask = 2
        box.physicsBody?.contactTestBitMask = 1
        box.physicsBody?.collisionBitMask = 1
        box.physicsBody?.isDynamic = false
        addChild(box)
    }
    
    private func match() {
        if randomNumber == rotationCount {
            currentScore =  currentScore+1
            if currentScore > highScore {
                highScore = highScore+1
            }
        }else {
            isEnabled = true
        }
    }
    
    func showAlert()->Alert {
        if let _circle = circle {
            _circle.removeFromParent()
        }
        return  Alert(title: Text(Alerts.title),
                      message: Text(Alerts.message),
                      dismissButton: Alert.Button.default(
                        Text(Alerts.dismiss), action: {
                            // dismiss
                            self.retry()
                        }
                      )
        )
    }
    
    private func retry() {
        self.isEnabled = false
        self.addCircle()
        self.currentScore = 0
    }
}

// MARK: - SKPhysicsContactDelegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        match()
        if let _circle = circle {
            _circle.removeFromParent()
        }
        
        addCircle()
    }
}
