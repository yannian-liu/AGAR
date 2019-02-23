//
//  player.swift
//  agar_class
//
//  Created by yannian liu on 15/10/9.
//  Copyright © 2015年 yannian liu. All rights reserved.
//

import UIKit
import SpriteKit

var other_Global_XDirection : CGFloat = 0.0
var other_Global_YDirection : CGFloat = 0.0
class otherPlayer: SKSpriteNode {
    var playerName = ""
    var score = 0
   
    
    init(picName:String){
        playerName = picName
        var diskcolorList = ["playerBlue","playerRed","playerRed","playerGreen","playerOrange","player"]
        var texture = SKTexture(imageNamed: "China")
        switch picName
        {
        case "CHINA":
            texture = SKTexture(imageNamed: "China")
        case "AUSTRALIA":
            texture = SKTexture(imageNamed: "Australia")
        default :
            texture = SKTexture(imageNamed: diskcolorList[Int(arc4random_uniform(UInt32(diskcolorList.count)))])
            
        }
        
        
        //        let texture = SKTexture(imageNamed: picName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.zPosition = 0.6
        self.size.height = 20
        self.size.width = 20
        self.physicsBody = SKPhysicsBody (circleOfRadius:self.size.width/2)
        
        self.physicsBody?.friction = 0
        
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = PlayerCategory
        self.physicsBody!.collisionBitMask = PlayerCategory|FoodCategory|SceneBorder|AIPlayerCategory
        self.physicsBody!.contactTestBitMask = PlayerCategory|FoodCategory|SpikeCategory|SceneBorder|AIPlayerCategory
        
        self.score = 0
        
    }
    init() {
        let texture = SKTexture(imageNamed: "playerRed")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody (circleOfRadius:self.size.width/2)
        self.size.height = 40
        self.size.width = 40
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.restitution = 0
        self.name = "otherplayer"
        self.physicsBody?.categoryBitMask = PlayerCategory
        self.physicsBody!.collisionBitMask = PlayerCategory|FoodCategory|SceneBorder|AIPlayerCategory
        self.physicsBody!.contactTestBitMask = PlayerCategory|FoodCategory|SpikeCategory|SceneBorder|AIPlayerCategory
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func move (_ touchLocation: CGPoint){
        
        var displacement : CGVector = CGVector(dx: touchLocation.x-self.position.x, dy: touchLocation.y-self.position.y)
        let temp = (touchLocation.x-self.position.x)*(touchLocation.x-self.position.x) + (touchLocation.y-self.position.y)*(touchLocation.y-self.position.y)
        let vectorDistance = sqrt(abs(temp))
        
        displacement.dx =   displacement.dx/vectorDistance
        displacement.dy =    displacement.dy/vectorDistance
        let sizex = CGFloat(20)+self.size.width
        
        let sizey = CGFloat(20)+self.size.height
        
        
        self.physicsBody?.velocity = CGVector(dx: other_Global_XDirection*5000/sizex,dy: other_Global_YDirection*5000 / sizey)
        other_Global_XDirection = displacement.dx
        other_Global_YDirection = displacement.dy
        
        
    }
    
    func die (){
        print("diediedie")
    }
    
    func destroy(){
        
        let destroyNode = SKSpriteNode()
        destroyNode.zPosition = 0.7
        destroyNode.anchorPoint = self.anchorPoint
        destroyNode.size.width  = self.size.width * 2
        destroyNode.size.height = self.size.height * 2
        //        destroyNode.position = self.position
        destroyNode.physicsBody?.pinned = true
        var imagesNames = ["destroy10","destroy20","destroy30","destroy40","destroy50","destroy60","destroy70","destroy80","destroy90","destroy100",]
        var images = [SKTexture]()
        for i in 0..<imagesNames.count{
            images.append(SKTexture(imageNamed: imagesNames[i]))
        }
        var destroyAction: SKAction
        destroyAction = SKAction.animate(with: images, timePerFrame: 0.1)
        
        self.addChild(destroyNode as SKNode)
        
        destroyNode.run(destroyAction)
        
        
        
        
        
        
        
        
        
    }
    
    func kill(){
        
    }
    
    func respawn(){
        
    }
    
    func fireBullet(_ scene: SKScene){
        
    }
}
