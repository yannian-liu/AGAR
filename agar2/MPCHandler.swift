//
//  MPCHandler.swift
//  agar2
//
//  Created by zheng on 12/10/2015.
//  Copyright © 2015 zheng. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SpriteKit

class MPCHandler: NSObject,MCSessionDelegate {
    var peerID : MCPeerID!
    var session : MCSession!
    var browser : MCBrowserViewController!
    var advertiser : MCAdvertiserAssistant? = nil
 
    
    func setupPeerWithDisplayName  (_ displayName : String)
    {
        peerID = MCPeerID(displayName: displayName)
        
    }
    
    func setSession()
    {
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    func setBrowser()
    {
        browser = MCBrowserViewController(serviceType: "my-game", session: session)

        

       
        
    }
    func advertiseSelf(_ advertise : Bool)
    {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser?.start()
        }
        else
        {
            advertiser?.stop()
            advertiser = nil
        }
        
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID" : peerID , "state" : state.rawValue ] as [String : Any]
        DispatchQueue.main.async(execute: {() -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        })
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo = ["data" : data,"peerID" : peerID] as [String : Any]
        DispatchQueue.main.async(execute: {() -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "MPC_DidReceiveDataNotification"), object: nil, userInfo: userInfo)
        })
        
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
}
