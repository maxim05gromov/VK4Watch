//
//  NewsInterfaceController.swift
//  VK4Watch WatchKit Extension
//
//  Created by Максим on 04.06.2021.
//

import WatchKit
import Foundation
func imageWithRoundedCornerSize(cornerRadius:CGFloat, usingImage original: UIImage) -> UIImage {
    let frame = CGRect(x: 0, y: 0, width: original.size.width, height: original.size.height)
        UIGraphicsBeginImageContextWithOptions(original.size, false, 1.0)
        UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).addClip()
    original.draw(in: frame)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }

class NewsInterfaceController: WKInterfaceController{
    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    @IBOutlet weak var TableView: WKInterfaceTable!
    var dataForCell: Data?
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.TableView.setHidden(true)
        loadingLabel.setHidden(false)
        let url = URL(string: "https://api.vk.com/method/newsfeed.get?&count=150&filters=post&access_token=03094c2e50da065bb57625f28938c4c6f80276f89635b882ec2e630578fab58ca861452c5e0fe4b763667&v=5.131")!
        let session = URLSession.shared
        session.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else {return}
                do{
                    let news = try JSONDecoder().decode(News.self, from: data)
                    self.dataForCell = data
                    self.TableView.setNumberOfRows(news.response.items.count, withRowType: "Cell")
                    for item in 0...news.response.items.count - 1{
                        let controller = self.TableView.rowController(at: item) as! TableRowController
                        controller.BodyText.setText(news.response.items[item].text)
                        for name in 0...news.response.groups.count - 1{
                            if news.response.items[item].source_id! * -1 == news.response.groups[name].id{
                                controller.NameText.setText(news.response.groups[name].name)
                                URLSession.shared.dataTask(with: URL(string: news.response.groups[name].photo_50)!) { data1, response1, error1 in
                                    var image = UIImage(data: data1!)
                                    image = imageWithRoundedCornerSize(cornerRadius: 17.5, usingImage: image!)
            
                                    controller.Image.setImage(image)
                                }.resume()
                                break
                            }
                        }
                        let secondsAgo = (Int(NSDate().timeIntervalSince1970) - news.response.items[item].date!)
                        if secondsAgo < 60{
                            controller.TimeAgo.setText("Несколько секунд назад")
                        }else if secondsAgo >= 60 && secondsAgo < 3600{
                            controller.TimeAgo.setText("\(Int(secondsAgo / 60)) минут назад")
                        }else if secondsAgo >= 3600 && secondsAgo < 7200{
                            controller.TimeAgo.setText("Час назад")
                        }else if secondsAgo >= 7200 && secondsAgo < 18000{
                            controller.TimeAgo.setText("\(Int(secondsAgo / 3600)) часа назад")
                        }else if secondsAgo >= 18000 && secondsAgo < 86400{
                            controller.TimeAgo.setText("\(Int(secondsAgo / 3600)) часов назад")
                        }else{
                            controller.TimeAgo.setText("День назад")
                        }
                        controller.AttachedPicture.setHidden(true)
                        if news.response.items[item].attachments?.count ?? 0 > 0{
                            for photo1 in 0...news.response.items[item].attachments!.count - 1{
                                if news.response.items[item].attachments![photo1].type == "photo"{
                                    controller.AttachedPicture.setHidden(false)
                                }
                            }
                        }else{
                            controller.AttachedPicture.setHidden(true)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.TableView.setHidden(false)
                        self.loadingLabel.setHidden(true)
                    }
                    
                }catch let error1{
                    self.loadingLabel.setText("Произошла ошибка, проверьте соединение с интернетом и повторите попытку")
                    print("Error: \(error1)")
                }
        }).resume()
        // Configure interface objects here.
    }
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        do{
        let news = try JSONDecoder().decode(News.self, from: dataForCell!)
            DispatchQueue.main.async{
                let Context = ContextNews(news: news, row: rowIndex)
                self.pushController(withName: "NewsObject", context: Context as ContextNews)
            }
            
        }catch let error{
            self.TableView.setHidden(true)
            loadingLabel.setText("Произошла ошибка, пожалуйста, свяжитесь с нами")
            loadingLabel.setHidden(false)
            print("Error: \(error)")
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
}
