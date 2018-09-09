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
    func receivedCardStack(data: [Any])
    func startedSession()
    func endedSession(data: [Any])
    func statsReceived(data: [Any])
}

public class Socket {
    
    private let manager = SocketManager(socketURL: URL(string: "https://rekoo.herokuapp.com/")!, config: [.log(true), .compress])
    private let client: SocketIOClient
    public var delegate: SocketDelegate?
    
    public init() {
       self.client = manager.defaultSocket
    }
    
    public func connect() {
        print("connecting...")
        
        client.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.requestCards()
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
    
    public func requestCards() {
        client.emit("login", ["user" : "poppro"])
    }
    
    public func addEventHandler() {
        client.on("new_card") {[weak self] data, ack in
            print(data)
            self?.delegate?.receivedNewCard(data: data)
            return
        }
        
        client.on("card stack") {[weak self] data, ack in
            print("Got cards!!!!!")
            print(data)
            self?.delegate?.receivedCardStack(data: data)
            return
        }
        
        client.on("start_session") {[weak self] data, ack in
            print("HELLLLOOOOO")
            self?.delegate?.startedSession()
            return
        }
        
        client.on("stats") {[weak self] data, ack in
            self?.delegate?.endedSession(data: data)
            return
        }
        
        client.on("display_stats") {[weak self] data, ack in
            self?.delegate?.statsReceived(data: data)
            return
        }
    }
    
    public func startSession() {
        client.emit("start_session", ["":""])
    }
    
    public func endSession() {
        client.emit("end_session", ["":""])
    }
    
    public func sendUpdate(sender: CardsView) {
        client.emit("push card", ["card" : sender.id, "user" : "poppro"])
    }
    
    public func sendImpression(type: CardType, impression: Int) {
        client.emit("register_impression", ["type" : type.abbreviation, "impressed" : impression])
    }
    
    public func sendStats() {
        client.emit("send_stats", ["":""])
    }
    
    public func receivedUpdate() {
        
    }
    
}

