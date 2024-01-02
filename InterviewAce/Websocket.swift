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
        let userId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
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
                DispatchQueue.main.async {
                    switch message {
                    case .string(let text):
                        self.messages.append(text)
                        print(text)
                    case .data(_):
                        // Handle binary data
                        break
                    @unknown default:
                        break
                    }
                }
            }
            self.receiveMessage() // Continue listening for messages
        }
    }    
}
