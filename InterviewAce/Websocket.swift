import SwiftUI

class Websocket: ObservableObject {
    @Published var messages = [String]()
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    init() {
        do {
            try self.connect()
        } catch {
            print("Error: Unable to establish WebSocket connection. Check your internet connection.")
        }
    }
    
    private func connect() throws {
           let userId = UIDevice.current.identifierForVendor!.uuidString
           guard let url = URL(string: "wss://w6w7zfl0r1.execute-api.us-west-2.amazonaws.com/production/?userId=\(userId)") else {
               throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
           }
           
           let request = URLRequest(url: url)
           
           webSocketTask = URLSession.shared.webSocketTask(with: request)
           
           webSocketTask?.resume()
           print("Connected to WebSocket")
           receiveMessage()
       }
    
    private func receiveMessage() {
        webSocketTask?.receive { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.messages.append(text)
                    print(text)
                case .data(let data):
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
