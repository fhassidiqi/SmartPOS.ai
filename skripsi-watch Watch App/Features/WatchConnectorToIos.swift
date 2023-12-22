import Foundation
import WatchConnectivity

class WatchConnectorToIos: NSObject, WCSessionDelegate {
    
    var session: WCSession
    var viewModel: WatchViewModel
    
    init(session: WCSession = .default, viewModel: WatchViewModel) {
        // Check if Watch Connectivity is supported on this device
        guard WCSession.isSupported() else {
            fatalError("Watch Connectivity is not supported on this device.")
        }
        
        self.session = session
        self.viewModel = viewModel
        super.init()
        
        self.session.delegate = self
        self.session.activate()
        
        self.viewModel = viewModel
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation state on Watch: \(activationState.rawValue)")

        if activationState == .activated {
            print("WCSession activated on Watch.")
        } else {
            print("WCSession activation failed on Watch: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        // Handle receiving application context
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let income = message["todayIncome"] as? String {
            print("Income received from iOS: \(income)")
            viewModel.todayIncome = income
        }
    }
}
