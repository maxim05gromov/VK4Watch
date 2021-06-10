//
//  NewsObjectInterfaceController.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 07.06.2021.
//

import WatchKit
import Foundation


class NewsObjectInterfaceController: WKInterfaceController {
    @IBOutlet weak var icon: WKInterfaceImage!
    @IBOutlet weak var name: WKInterfaceLabel!
    @IBOutlet weak var time: WKInterfaceLabel!
    @IBOutlet weak var body: WKInterfaceLabel!
    @IBOutlet weak var photo: WKInterfaceImage!
    @IBOutlet weak var loading: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let data = context as! ContextNews
        body.setText(data.news.response.items[data.row].text)
        if data.news.response.items[data.row].source_id! < 0{
        for name1 in 0...data.news.response.groups.count - 1{
            if data.news.response.items[data.row].source_id! * -1 == data.news.response.groups[name1].id{
                name.setText(data.news.response.groups[name1].name)
                URLSession.shared.dataTask(with: URL(string: data.news.response.groups[name1].photo_50)!) { data1, response1, error1 in
                    var image1 = UIImage(data: data1!)
                    image1 = imageWithRoundedCornerSize(cornerRadius: 17.5, usingImage: image1!)
                    self.icon.setImage(image1)
                }.resume()
                break
            }
          }
        }else{
            for name1 in 0...data.news.response.profiles.count - 1{
                if data.news.response.items[data.row].source_id! == data.news.response.profiles[name1].id{
                    name.setText(data.news.response.profiles[name1].first_name! + " " + data.news.response.profiles[name1].last_name!)
                    URLSession.shared.dataTask(with: URL(string: data.news.response.profiles[name1].photo_50!)!) { data1, response1, error1 in
                        var image1 = UIImage(data: data1!)
                        image1 = imageWithRoundedCornerSize(cornerRadius: 17.5, usingImage: image1!)
                        self.icon.setImage(image1)
                    }.resume()
                    break
                }
            }
        }
        let secondsAgo = (Int(NSDate().timeIntervalSince1970) - data.news.response.items[data.row].date!)
        if secondsAgo < 60{
            time.setText("\(Int(secondsAgo)) секунд назад")
        }else if secondsAgo >= 60 && secondsAgo < 3600{
            time.setText("\(Int(secondsAgo / 60)) минут назад")
        }else if secondsAgo >= 3600 && secondsAgo < 7200{
            time.setText("час назад")
        }else if secondsAgo >= 7200 && secondsAgo < 18000{
            time.setText("\(Int(secondsAgo / 3600)) часа назад")
        }else if secondsAgo >= 18000 && secondsAgo < 86400{
            time.setText("\(Int(secondsAgo / 3600)) часов назад")
        }else{
            time.setText("День назад")
        }
        loading.setHidden(true)
        if data.news.response.items[data.row].attachments?.count ?? 0 > 0{
            for photo1 in 0...data.news.response.items[data.row].attachments!.count - 1{
                if data.news.response.items[data.row].attachments![photo1].type == "photo"{
                    loading.setHidden(false)
                }
            }
            for photo1 in 0...data.news.response.items[data.row].attachments!.count - 1{
                if data.news.response.items[data.row].attachments![photo1].type == "photo"{
                    URLSession.shared.dataTask(with: URL(string: (data.news.response.items[data.row].attachments![photo1].photo?.sizes![3].url)!)!, completionHandler: { data, response, error in
                        if error != nil {
                            self.loading.setText("При загрузке изображения произошла ошибка")
                            print("Error: \(error!)")
                            self.photo.setHidden(true)
                            self.loading.setHidden(false)
                        } else {
                        self.photo.setImage(UIImage(data: data!))
                            self.loading.setHidden(true)
                        }
                    }).resume()
                    break
                }
            }
        }else{
            photo.setHidden(true)
            loading.setHidden(true)
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

}
