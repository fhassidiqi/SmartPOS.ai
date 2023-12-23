// WatchConnector.swift
import Foundation
import WatchConnectivity
import Combine

struct SerializedIncome: Codable {
    let income: Int
    let profit: Int
    let omzet: Int
    let date: Date
}

class WatchSessionDelegate: NSObject, WCSessionDelegate {
    
    private var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Activation failed with error: \(error.localizedDescription)")
            return
        }
        self.session = session
        print("Activation state: \(activationState.rawValue)")
    }
    
#if os(iOS)
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func isReachable() {
        if let session = session, session.isReachable {
            print("Reachable")
        } else {
            print("Not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            
            if session.isReachable {
                print("Reachable")
            } else {
                print("Not reachable")
            }
            
            if let incomeData = applicationContext["todayIncome"] as? Data {
                let decoder = JSONDecoder()
                if let todayIncome = try? decoder.decode(String.self, from: incomeData) {
                    // handle today's income
                    print("Today's Income: \(todayIncome)")
                    self.dataSubject.send(todayIncome)
                } else {
                    print("some sort of communication error :(")
                }
            } else {
                print("some sort of communication error :(")
            }
        }
    }
    
    let dataSubject: CurrentValueSubject<String, Never>
    
    init(_ dataSubject: CurrentValueSubject<String, Never>) {
        self.dataSubject = dataSubject
        super.init()
    }
    
    func sendTodayIncome(_ income: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(income) {
            session?.sendMessage(["todayIncome": encoded], replyHandler: nil) { error in
                print("Error sending income: \(error.localizedDescription)")
            }
        }
    }
    
#else
    var dataSubject = PassthroughSubject<String, Never>()
    
    init(_ dataSubject: PassthroughSubject<String, Never>) {
        self.dataSubject = dataSubject
        super.init()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let incomeData = message["todayIncome"] as? Data {
                let decoder = JSONDecoder()
                if let todayIncome = try? decoder.decode(String.self, from: incomeData) {
                    // handle today's income
                    print("Today's Income: \(todayIncome)")
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
    let dataSubject = CurrentValueSubject<String, Never>("")
    
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
    
    public func sendTodayIncome(_ income: String) {
        self.delegate?.sendTodayIncome(income)
    }
}
#else
class CommunicationManager: ObservableObject {
    var session: WCSession?
    let delegate: WatchSessionDelegate?
    let dataSubject = PassthroughSubject<String, Never>()
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
