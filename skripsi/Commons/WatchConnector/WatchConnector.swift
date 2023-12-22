//
//  WatchConnector.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 22/12/23.
//

import Foundation
import WatchConnectivity

class WatchConnector: NSObject {
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func sendTodayIncome(income: String) {
        // Check if the session is activated
        guard session.activationState == .activated else {
            print("Session not activated")
            return
        }
        
        print("Activation state before sending income: \(session.activationState.rawValue)")
        print("Income: \(income)")
        
        guard session.isReachable else {
            print("Watch is not reachable")
            return
        }
        
        let contextData = ["todayIncome": income]

        session.sendMessage(contextData, replyHandler: { response in
            print("Application context data sent to watch")
        }, errorHandler: { error in
            print("Error sending application context data to watch: \(error.localizedDescription)")
        })
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachability changed. Is reachable: \(session.isReachable)")
    }
}

extension WatchConnector: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation state after completion: \(activationState.rawValue)")
        if let error = error {
            print("Activation error: \(error.localizedDescription)")
        } else {
            print("The session has completed activation.")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become inactive.")
        // Reactivate the session
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Reactivate the session
        session.activate()
    }
    
    func session(_ session: WCSession, didBecomeReachable reachable: Bool) {
        if reachable {
            sessionReachabilityDidChange(session)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // Handle received message if needed
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let income = applicationContext["todayIncome"] as? String {
            print("Received today's income: \(income)")
            // Handle the received income data as needed
        } else {
            print("Received nil or unexpected application context data.")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        // Handle received user info if needed
    }
}
