//
//  WatchConnector.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 26/12/23.
//

import Foundation
import WatchConnectivity
import Combine

class WatchSessionDelegate: NSObject, WCSessionDelegate {
    
    private var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Activation failed with error: \(error.localizedDescription)")
            return
        }
        self.session = session
    }
    
#if os(iOS)
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            
            if let incomeData = applicationContext["todayIncome"] as? Data {
                let decoder = JSONDecoder()
                if let todayIncome = try? decoder.decode([Int].self, from: incomeData) {
                    self.dataSubject.send(todayIncome)
                } else {
                    print("some sort of communication error :(")
                }
            } else {
                print("some sort of communication error :(")
            }
        }
    }
    
    let dataSubject: CurrentValueSubject<[Int], Never>
    
    init(_ dataSubject: CurrentValueSubject<[Int], Never>) {
        self.dataSubject = dataSubject
        super.init()
    }
    
    func sendTodayIncome(_ income: [Int]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(income) {
            session?.sendMessage(["todayIncome": encoded], replyHandler: nil) { error in
                print("Error sending income: \(error.localizedDescription)")
            }
        }
    }
    
#else
    var dataSubject = PassthroughSubject<[Int], Never>()
    
    init(_ dataSubject: PassthroughSubject<[Int], Never>) {
        self.dataSubject = dataSubject
        super.init()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let incomeData = message["todayIncome"] as? Data {
                let decoder = JSONDecoder()
                if let todayIncome = try? decoder.decode([Int].self, from: incomeData) {
                    self.dataSubject.send(todayIncome)
                } else {
                    print("some sort of communication error :(")
                }
            } else {
                print("some sort of communication error :(")
            }
        }
    }
#endif
}

#if os(iOS)
class CommunicationManager: ObservableObject {
    var session: WCSession?
    let delegate: WatchSessionDelegate?
    let dataSubject = CurrentValueSubject<[Int], Never>([])
    
    @Published private(set) var initializedSuccessfully: Bool = false
    
    init(session: WCSession = .default) {
        if WCSession.isSupported() {
            let delegate = WatchSessionDelegate(dataSubject)
            self.session = session
            self.delegate = delegate
            
            session.delegate = delegate
            session.activate()
            self.initializedSuccessfully = true
        } else {
            self.session = nil
            self.delegate = nil
            self.initializedSuccessfully = false
        }
        
    }
    
    public func sendTodayIncome(_ income: [Int]) {
        self.delegate?.sendTodayIncome(income)
    }
}
#else
class CommunicationManager: ObservableObject {
    var session: WCSession?
    let delegate: WatchSessionDelegate?
    let dataSubject = PassthroughSubject<[Int], Never>()
    @Published private(set) var initializedSuccessfully: Bool = false
    
    init(session: WCSession = .default) {
        if WCSession.isSupported() {
            let delegate = WatchSessionDelegate(dataSubject)
            self.session = session
            self.delegate = delegate
            
            session.delegate = delegate
            session.activate()
            self.initializedSuccessfully = true
            
        } else {
            self.session = nil
            self.delegate = nil
            self.initializedSuccessfully = false
        }
    }
}
#endif
