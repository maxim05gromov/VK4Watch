//
//  MsgInterfaceController.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 04.06.2021.
//

import WatchKit
import Foundation


class MsgInterfaceController: WKInterfaceController {

    @IBOutlet weak var TableView: WKInterfaceTable!
    var loadedData = messages.init(response: nil)
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if UserDefaults.standard.string(forKey: "Token") != nil {
            if UserDefaults.standard.string(forKey: "Token") != "" {
                let url = URL(string: "https://api.vk.com/method/messages.getConversations?&count=100&access_token=" + UserDefaults.standard.string(forKey: "Token")! + "&v=5.131")!
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data{
                    do{
                        let msgList = try JSONDecoder().decode(messages.self, from: data)
                        self.loadedData = msgList
                        self.TableView.setNumberOfRows((msgList.response?.items!.count)!, withRowType: "MsgCell")
                        for item in 0...(msgList.response?.items!.count)! - 1 {
                            let controller = self.TableView.rowController(at: item) as! MessagesRow
                            controller.Text.setText(msgList.response?.items![item].last_message?.text!)
                            
                            let uid = msgList.response?.items?[item].conversation?.peer?.id!
                            if uid! > 0{//&fields=photo_200&access_token=\(UserDefaults.standard.string(forKey: "token") ?? "")&v=5.131"
                                URLSession.shared.dataTask(with: URL(string: "https://api.vk.com/method/users.get?&user_ids=\(uid!)&fields=photo_50&access_token=\(UserDefaults.standard.string(forKey: "Token") ?? "")&v=5.131")!) { data, response, error in
                                    if let data = data {
                                    do{
                                        let user = try JSONDecoder().decode(UserInfo.self, from: data)
                                        controller.Name.setText("\(user.response[0].first_name!) \(user.response[0].last_name!)")
                                        URLSession.shared.dataTask(with: URL(string: user.response[0].photo_50!)!) { data1, response1, error1 in
                                            if let data1 = data1 {
                                                var image = UIImage(data: data1)
                                                image = imageWithRoundedCornerSize(cornerRadius: image!.size.width / 2, usingImage: image!)
                                                controller.Icon.setImage(image)
                                            }
                                        }.resume()
                                        
                                    }catch let error{
                                        print(error)
                                    }
                                    }
                            }.resume()
                            }
                        }
                        
                    }catch let error{
                        print("Error: \(error)")
                    }
                    }
                }.resume()
                
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print(loadedData)
        print(loadedData.response?.items?[rowIndex].conversation?.peer?.id)
        presentController(withName: "Message", context: loadedData.response?.items?[rowIndex].conversation?.peer?.id)
    }
}
