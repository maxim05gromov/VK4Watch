//
//  ChatInterfaceController.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 14.06.2021.
//

import WatchKit
import Foundation


class ChatInterfaceController: WKInterfaceController {
    @IBOutlet weak var Table: WKInterfaceTable!
    var UID: Int = 0
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        UID = context as! Int
        Table.setNumberOfRows(2, withRowType: "ChatCell")
        Table.scrollToRow(at: 1)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func NewMessage() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji) { (text) in
            if let text = text{
                let url = "https://api.vk.com/method/messages.send?&random_id=0&peer_ids=\(self.UID)&message=\(text[0])&access_token=\(UserDefaults.standard.string(forKey: "Token") ?? "")&v=5.131".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                URLSession.shared.dataTask(with: URL(string: url!)!) { (data, response, error) in
                    if let error = error{
                        print("Error: \(error)")
                    }
                    if let data = data{
                        print("Data: \(data)")
                    }
                }.resume()
            }
        }
    }
}
