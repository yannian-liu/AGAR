//
//  GameStartScene.swift
//  agar2
//
//  Created by zheng on 6/10/2015.
//  Copyright © 2015 zheng. All rights reserved.
//

import SpriteKit
import Darwin
import MultipeerConnectivity
var appDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate

protocol GameStartSceneDelegate
{
    func PassDataBeteenScenes (_ nickname : String,gametype : String)
    func PassDataBeteenUsers (_ player :Player)

    
}
class GameStartScene: SKScene,UITextFieldDelegate,MCBrowserViewControllerDelegate{
     var thisDelegate : GameStartSceneDelegate?
    var nickNameTextField = UITextField()
    var browser : MCBrowserViewController!
    var player = Player()

    
    func browserViewControllerDidFinish(_ browserViewController:MCBrowserViewController) {
        
        appDelegate.mpchandler.browser.dismiss(animated: true, completion: nil)

        sendUserData()

        let GameSceneView = GameScene( fileNamed: "GameScene" )
        let transitionAction = SKAction.run()
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(GameSceneView!, transition: reveal)
        }
        GameSceneView!.PassDataBeteenScenes("no name",gametype:"multiplayer")
        self.run(transitionAction)
        nickNameTextField.removeFromSuperview()

    }
    
    func browserViewControllerWasCancelled(_ browserViewController:MCBrowserViewController) {
        appDelegate.mpchandler.browser.dismiss(animated: true, completion: nil)
        
    }
    func peerChangedStateWithNotification(_ notification:Notification)
    {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        if state != MCSessionState.connecting.rawValue
        {
                    }
        
    }
    func handleReceivedDataWithNotification (_ notification:Notification)
    {
        print("in handleReceivedDataWithNotification")
        do{
            let userInfo = notification.userInfo! as Dictionary
            let receiveData : Data = userInfo["data"] as! Data
            
            let messasge = try JSONSerialization.jsonObject(with: receiveData, options: JSONSerialization.ReadingOptions.allowFragments)
            

        }
            
            
        catch{}
        
        let GameSceneView = multiplayerGameScene( fileNamed: "multiplayerGameScene" )
        print(1)
        let transitionAction = SKAction.run()
            {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(GameSceneView!, transition: reveal)
        }
        print(2)
        GameSceneView!.PassDataBeteenUsers(player)
        self.run(transitionAction)
        nickNameTextField.removeFromSuperview()

    }
    override func didMove(to view: SKView)
    {
        
        appDelegate.mpchandler.setupPeerWithDisplayName(UIDevice.current.name)
        appDelegate.mpchandler.setSession()
        appDelegate.mpchandler.advertiseSelf(true)
        NotificationCenter.default.addObserver(self, selector: #selector(GameStartScene.peerChangedStateWithNotification(_:)), name: NSNotification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameStartScene.handleReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil)
        
        

             let background = SKSpriteNode(imageNamed: "startpage")
            self.anchorPoint  = background.anchorPoint
            background.position = self.position
        nickNameTextField = UITextField.init(frame: CGRect(x: 180, y: 50, width: 250, height: 20))
        nickNameTextField.backgroundColor = UIColor.clear
//        nickNameTextField.center = self.view!.center;
        nickNameTextField.borderStyle =  UITextBorderStyle.line
        nickNameTextField.placeholder = "Enter your nickname: "
        nickNameTextField.delegate = self
        //define singel play label and multiplay
        
       let siglePlayLabel  = childNode(withName: "singlePlayModeLabel")  as!SKLabelNode
    let multiPlayLabel  = childNode(withName: "MultiplayModeLabel") as! SKLabelNode
        
        siglePlayLabel.position = CGPoint(x: background.position.x-150, y: background.position.y-100)
        
        siglePlayLabel.fontName =  "Arial"
        siglePlayLabel.zPosition = 0.5
        multiPlayLabel.position = CGPoint(x: background.position.x+150, y: background.position.y-100)
        multiPlayLabel.zPosition = 0.5
//        siglePlayLabel.text = "Single Mode"
//        multiPlayLabel.text = "Multiplayer Mode"
//        
//        background.addChild(siglePlayLabel)
//        background.addChild(multiPlayLabel)
        addChild( background)
        self.view?.addSubview(nickNameTextField)

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches
        {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            if let nodeName = node.name {
                
                switch nodeName {
                
                    case "singlePlayModeLabel":
                        let GameSceneView = GameScene( fileNamed: "GameScene" )
                        let transitionAction = SKAction.run()
                            {
                                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                                self.view?.presentScene(GameSceneView!, transition: reveal)
                        }
                        GameSceneView!.PassDataBeteenScenes("no name",gametype:"singleplayer")
                        
                        self.run(transitionAction)
                        nickNameTextField.removeFromSuperview()

                        //实现页面跳转 跟从textfield 跳转相同
                    case "MultiplayModeLabel":
                        connectWithPlayer()
                    //实现连接服务器 发请求 接受 blahblah
                    default :
                    print("you should do sth else")
                
                }
            
            }

        }
    }
    
    func sendUserData(_ thisplayer:Player)
        
    {
        player = thisplayer
        let messageDict = ["a":1,"b":2]
        
        do {
            let messageData =  try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            try
                appDelegate.mpchandler.session.send(messageData, toPeers: appDelegate.mpchandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            
        }
        catch
        {
            
        }

        
    }
    func sendUserData()
        
    {
        print("in sendUserData")
        let messageDict = ["a":1,"b":2]
        
        do {
            let messageData =  try JSONSerialization.data(withJSONObject: messageDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            try
                appDelegate.mpchandler.session.send(messageData, toPeers: appDelegate.mpchandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            
        }
        catch
        {
            
        }
        
    }

    func connectWithPlayer() {

        //        Multiplaybtn.removeFromSuperview()

        if appDelegate.mpchandler.session != nil
        {
            
            appDelegate.mpchandler.setBrowser()
            appDelegate.mpchandler.browser.delegate = self
            var currentViewController:UIViewController=(UIApplication.shared.keyWindow?.rootViewController)!
            
            
            currentViewController.present(appDelegate.mpchandler.browser, animated: true, completion:{} )
               

            
    }
    }

    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {

        let GameSceneView = GameScene( fileNamed: "GameScene" )
        if textField == nickNameTextField
        {

            
            let transitionAction = SKAction.run()
                {
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    self.view?.presentScene(GameSceneView!, transition: reveal)
            }
            GameSceneView!.PassDataBeteenScenes(nickNameTextField.text!,gametype:"singlePlayer")

            run(transitionAction)
            nickNameTextField.removeFromSuperview()
        }
        return true
    }
    
    
}
