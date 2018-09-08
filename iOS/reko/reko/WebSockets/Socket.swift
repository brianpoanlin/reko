//
//  SocketSession.swift
//  reko
//
//  Created by Brian Lin on 9/8/18.
//  Copyright © 2018 Brian Lin. All rights reserved.
//

import SocketIO
import SwiftyJSON

public protocol SocketDelegate {
    func receivedNewCard(data: [Any])
}

public class Socket {
    
    private let manager = SocketManager(socketURL: URL(string: "http://10.251.75.169:2000")!, config: [.log(true), .compress])
    private let client: SocketIOClient
    public var delegate: SocketDelegate?
    
    public init() {
       self.client = manager.defaultSocket
    }
    
    public func connect() {
        print("connecting...")
        
        client.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
//        client.on("update") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//
//            self.client.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                self.client.emit("update", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
//        }
        
        client.connect()
        addEventHandler()
    }
    
    public func addEventHandler() {
        client.on("new_card") {[weak self] data, ack in
            print(data)
            self?.startSession()
            self?.delegate?.receivedNewCard(data: data)
            return
        }
    }
    
    public func startSession() {
        print("\n\n\n\n Session started!!!! \n\n\n")
    }
    
    public func sendUpdate() {
//        let data: JSON
        client.emit("push card", ["card" : 0, "user" : "poppro"])
    }
    
    public func receivedUpdate() {
        
    }
    
}

