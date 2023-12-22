//
//  WatchHomeViewModel.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import Foundation
import WatchConnectivity

class WatchViewModel: NSObject, ObservableObject {
    @Published var todayIncome: String = "Loading..."

    func activateWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func sendRequestToPhone() {
        if WCSession.default.isReachable {
            let message = ["request": "getTodayIncome"]

            WCSession.default.sendMessage(message, replyHandler: { response in
                if let todayIncome = response["todayIncome"] as? String {
                    DispatchQueue.main.async {
                        self.todayIncome = todayIncome
                    }
                }
            }, errorHandler: { error in
                print("Error sending message to iPhone: \(error.localizedDescription)")
            })
        } else {
            print("WatchConnectivity session is not reachable")
        }
    }
}

extension WatchViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("Watch session activated")
            sendRequestToPhone()
        } else {
            print("Watch session not activated")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            print("WatchConnectivity session is now reachable")
            sendRequestToPhone()
        } else {
            print("WatchConnectivity session is not reachable")
        }
    }
}
