//
//  SendInterfaceController.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 06.10.2021.
//

import WatchKit
import Foundation


class SendInterfaceController: WKInterfaceController {
    @IBOutlet weak var messageButton: WKInterfaceButton!
    var UID = 0
    var message = ""
    var answersList = [String]()
    @IBOutlet weak var TableView: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        UID = context as! Int
        answersList = (UserDefaults.standard.object(forKey: "answersList") as! NSArray) as! [String]
        print(answersList)
        TableView.setNumberOfRows(answersList.count, withRowType: "answerRow")
        for Answer in 0...answersList.count - 1{
            let cell = TableView.rowController(at: Answer) as! AnswersRow
            cell.textLabel.setText(answersList[Answer] as! String ?? "")
        }
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
    @IBAction func messageButtonTapped() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .allowEmoji) { (text) in
            if let text = text{
                self.message = text[0] as! String
                self.messageButton.setTitle(self.message)
            }
       }
    }
    @IBAction func SendButtonTapped() {
        let url = "https://api.vk.com/method/messages.send?&random_id=0&peer_ids=\(self.UID)&message=\(message)&access_token=\(UserDefaults.standard.string(forKey: "Token") ?? "")&v=5.131".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        URLSession.shared.dataTask(with: URL(string: url!)!) { (data, response, error) in
            if let error = error{
                print("Error: \(error)")
            }
            if let data = data{
                print("Data: \(data)")
            }
        }.resume()
        self.dismiss()
        
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.message = self.answersList[rowIndex] as! String
        SendButtonTapped()
    }
}
