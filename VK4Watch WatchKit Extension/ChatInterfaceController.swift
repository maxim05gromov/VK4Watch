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
    var chatHistory = Chat(response: nil)
    @IBOutlet weak var LoadingLabel: WKInterfaceLabel!
    @IBOutlet weak var newMessageButton: WKInterfaceButton!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        UID = context as! Int
    }
    func loadChat(){
        LoadingLabel.setHidden(false)
        newMessageButton.setHidden(true)
        Table.setHidden(true)
        let url = URL(string: "https://api.vk.com/method/messages.getHistory?&count=200&peer_id=\(self.UID)&access_token=\(UserDefaults.standard.string(forKey: "Token") ?? "")&v=5.131")
        URLSession.shared.dataTask(with: URL(string: "https://api.vk.com/method/users.get?&user_ids=\(UID)&fields=photo_50&access_token=\(UserDefaults.standard.string(forKey: "Token") ?? "")&v=5.131")!) { data, response, error in
            if let data = data {
            do{
                let user = try JSONDecoder().decode(UserInfo.self, from: data)
                if user.response[0].first_name!.count > 9{
                    self.setTitle("\(user.response[0].first_name!.prefix(9))...")
                }else{
                self.setTitle(user.response[0].first_name!)
                }
            }catch let error{
                print(error)
            }
            }
        }.resume()
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do{
                    let chatHistory1 = try JSONDecoder().decode(Chat.self, from: data)
                    self.chatHistory = chatHistory1
                    print(chatHistory1.response!.items!.count)
                    self.Table.setNumberOfRows(chatHistory1.response!.items!.count, withRowType: "ChatCell")
                    for item in 0...chatHistory1.response!.items!.count - 1{
                        let controller = self.Table.rowController(at: chatHistory1.response!.items!.count - 1 - item) as! ChatRow
                        if chatHistory1.response?.items![item].text != "" {
                            controller.chatText.setText(chatHistory1.response?.items![item].text!)
                            if chatHistory1.response?.items![item].out == 0{
                                controller.chatGroup.setBackgroundColor(.gray)
                                controller.chatGroup.setWidth(WKInterfaceDevice.current().screenBounds.width / 6 * 5)
                                controller.chatGroup.setHorizontalAlignment(.left)
                            }else{
                                controller.chatGroup.setWidth(WKInterfaceDevice.current().screenBounds.width / 6 * 5)
                                controller.chatGroup.setHorizontalAlignment(.right)
                            }
                        }else{
                            controller.chatText.setHidden(true)
                        }
                    }
                    DispatchQueue.main.async{
                        self.Table.setHidden(false)
                        self.LoadingLabel.setHidden(true)
                        self.newMessageButton.setHidden(false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        self.scroll(to: self.Table, at: .bottom, animated: true)
                        }
                    }

                    

                }catch let error{
                    print(error)
                }
                
            }
        }.resume()
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func didAppear() {
        loadChat()
    }
    @IBAction func NewMessage() {
        presentController(withName: "SendMenu", context: UID)
    }
}
