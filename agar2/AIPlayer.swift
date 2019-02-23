//
//  AIPlayer.swift
//  agar2
//
//  Created by yannian liu on 15/10/12.
//  Copyright © 2015年 zheng. All rights reserved.
//

import UIKit
import SpriteKit

class AIPlayer: SKSpriteNode {
//    var AIPlayer = "AIPlayer"
    var score = 0
    
    init(){
        var diskcolorList = ["playerBlue","playerRed","playerRed","playerGreen","playerOrange","player"]

        let texture = SKTexture(imageNamed: diskcolorList[Int(arc4random_uniform(UInt32(diskcolorList.count)))])
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.zPosition = 0.6
      
//        var temp = CGFloat( arc4random_uniform(25))
        //        self.size.height = 20
        //        self.size.width = 20
        self.physicsBody = SKPhysicsBody (circleOfRadius: self.size.height/2)
        
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = -0.008
        self.physicsBody?.restitution = 1
        self.physicsBody?.isDynamic = true
        self.physicsBody?.pinned = false
        self.score = 0
        self.physicsBody?.categoryBitMask = AIPlayerCategory
        self.physicsBody?.collisionBitMask = PlayerCategory|SceneBorder|AIPlayerCategory
        self.physicsBody?.contactTestBitMask = PlayerCategory|SceneBorder

        

        
        
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
}
