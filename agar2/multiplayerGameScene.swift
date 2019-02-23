//
//  GameScene.swift
//  agar2
//
//  Created by zheng on 5/10/2015.
//  Copyright (c) 2015 zheng. All rights reserved.
//

import SpriteKit
import Darwin



class multiplayerGameScene: SKScene ,SKPhysicsContactDelegate, GameStartSceneDelegate {
    var otherplayer = otherPlayer()
    var player = Player()
    var food = SKSpriteNode.init()
    var otherplayercamera = SKCameraNode()
    var otherplayerisMoving = false
   
    
    func PassDataBeteenScenes(_ nickname: String,gametype:String){
        
       
    }
    func PassDataBeteenUsers (_ thisplayer :Player)
    {
        player = thisplayer
    }
    
    
    
    // - - - - - - - - - - - - - - - - - - - - - - - - didMoveToView - - - - - - - - - - - - - - - - - - - - - - - - //
    
    override func didMove(to view: SKView) {
       
        
        if let someCamera:SKCameraNode = self.childNode(withName: "theCamera2") as? SKCameraNode {
            otherplayercamera = someCamera
            self.camera = someCamera
            otherplayercamera.xScale = 0.8
            otherplayercamera.yScale = 0.8
        }
       let playdesk  = SKSpriteNode(imageNamed: "playdesk")
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
        self.physicsBody?.friction = 0
        // setup Game boarder
        let borderbody  = SKPhysicsBody(edgeLoopFrom:playdesk.frame)
        
        borderbody.categoryBitMask = SceneBorder
        borderbody.collisionBitMask = SceneBorder
        borderbody.contactTestBitMask = SceneBorder
        borderbody.restitution = 0.2
        self.physicsBody = borderbody


        // - - - - - - - - - - - - - - - - - - - - - - - - playdesk - - - - - - - - - - - - - - - - - - - - - - - - //
        
        playdesk.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playdesk.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        playdesk.physicsBody?.friction = 0
        
        
        self.addChild(playdesk)
        self.addChild(player)
        self.addChild(otherplayer)
        print(otherplayer)
        
        var ramdomnumberX = 0
        var ramdomnumberY = 0
        let BoundX = UInt32(playdesk.size.height)
        let BoundX_half = UInt32(playdesk.size.height/2)
        let BoundY = UInt32(playdesk.size.width)
        let BoundY_half = UInt32(playdesk.size.width/2)
        for _ in 0...AmountofFoodieStatic{
            
            ramdomnumberX = Int(arc4random_uniform(BoundX))-Int(BoundX_half)
            ramdomnumberY = Int(arc4random_uniform(BoundY))-Int(BoundY_half)
            
            let pickFoodColor = Int(arc4random_uniform(4))
            switch pickFoodColor
            {
            case 0 :
                food = SKSpriteNode(imageNamed: "food1.png")
            case 1 :
                food = SKSpriteNode(imageNamed: "foodBlue.png")
            case 2 :
                food = SKSpriteNode(imageNamed: "foodOrange.png")
            case 3 :
                food = SKSpriteNode(imageNamed: "foodPurple.png")
            default :
                food = SKSpriteNode(imageNamed: "foodRed.png")
                
            }
            
            food.color = UIColor.red
            food.position = CGPoint(x: CGFloat(ramdomnumberX), y: CGFloat(ramdomnumberY))
            food.physicsBody?.friction = 0
            food.physicsBody?.restitution = 1
            food.physicsBody?.mass = 0
            food.zPosition = 0.5
            food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
            food.physicsBody?.categoryBitMask = FoodCategory
            food.physicsBody?.collisionBitMask = PlayerCategory|AIPlayerCategory
            food.physicsBody?.contactTestBitMask = PlayerCategory|AIPlayerCategory
            playdesk.addChild(food)
        }
        
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
         for touch in touches {
        let touchLocation = touch.location(in: self)
        let touchnode = atPoint(touchLocation)
            //resize the otherplayersize
            otherplayer.physicsBody = SKPhysicsBody(circleOfRadius: otherplayer.size.height/2)
            otherplayer.physicsBody?.categoryBitMask = PlayerCategory
            otherplayer.physicsBody!.collisionBitMask = PlayerCategory|FoodCategory|SceneBorder|AIPlayerCategory
            otherplayer.physicsBody!.contactTestBitMask = PlayerCategory|FoodCategory|SpikeCategory|SceneBorder|AIPlayerCategory
            
            if touchnode.name == "otherplayer" && otherplayerisMoving == false
            {   print(11)
                otherplayer.physicsBody?.pinned = false
            }
                
            else if touchnode.name != "otherplayer"
            {
                otherplayer.physicsBody?.pinned = false
                otherplayerisMoving = true
                
            }
            
            otherplayer.move(touchLocation)
        
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {

        let moveCamera = SKAction.move(to: otherplayer.position, duration:0)
        otherplayercamera.run(moveCamera)
        
        print("camera name ", camera?.name)
        print ("otherplayer position ", otherplayer.position)
    
    }
}
