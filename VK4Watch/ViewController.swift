//
//  ViewController.swift
//  VK4Watch
//
//  Created by Максим on 04.06.2021.
//

import UIKit
import WatchConnectivity
import SwiftyVK
struct UserInfo: Decodable {
    let response: [Response]
}
struct Response: Decodable {
    let first_name: String
        let id: Int
        let last_name: String
        let can_access_closed: Bool
        let is_closed: Bool
        let photo_200: String
}
func imageWithRoundedCornerSize(cornerRadius:CGFloat, usingImage original: UIImage) -> UIImage {
    let frame = CGRect(x: 0, y: 0, width: original.size.width, height: original.size.height)
    UIGraphicsBeginImageContextWithOptions(original.size, false, 1.0)
    UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).addClip()
    original.draw(in: frame)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage!
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    var user = UserInfo(response: [])
    var imageData = Data()
    var username = ""
    var image1 = UIImage()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if VK.sessions.default.accessToken != nil{
                return 2
            }else{
                return 1
            }
        }else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                if indexPath.row == 0{
                    return 80
                }else{
                    return 45
                }
            }else{
                return 45
            }
        }else{
            return 45
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "cell") as! Cell
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                if indexPath.row == 0{
                    cell.Label.text = "\(username)"
                        cell.cellImage.image = image1
                    cell.cellImage.isHidden = false


                    
                }else{
                    cell.Label.text = "Выйти из аккаунта"
                    cell.cellImage.isHidden = true
                }
            }else{
                cell.Label.text = "Войти"
                cell.cellImage.isHidden = true
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                cell.Label.text = "Списки новостей"
            }else{
            cell.Label.text = ""
            }
            cell.cellImage.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                if indexPath.row == 1{
                logout()
                }
            }else{
                login()
            }
        }
        
        Table.deselectRow(at: indexPath, animated: true)
        Table.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Аккаунт"
        }else if section == 1{
            return "Настройки клиента для часов"
        }else{
            return ""
        }
    }
    @IBOutlet weak var Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Table.delegate = self
        self.Table.dataSource = self
        navigationController?.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = true
        if VK.sessions.default.accessToken != nil{
        username = UserDefaults.standard.string(forKey: "Username") ?? ""
            URLSession.shared.dataTask(with: URL(string: UserDefaults.standard.string(forKey: "imageURL") ?? "https://www.com")!) { [self] data, response, error in
                if let data = data {
                    image1 = UIImage(data: data)!
                    image1 = imageWithRoundedCornerSize(cornerRadius: image1.size.height / 2, usingImage: image1)
                }
                DispatchQueue.main.async {
                    self.Table.reloadData()
                }
            }.resume()
        }
    }
    
    
    func login(){
        VK.sessions.default.logIn(
            onSuccess: { info in
            print("SwiftyVK: success authorize with", info)
            var allIsOk = false
            if UserDefaults.standard.string(forKey: "token") != nil{
                if WCSession.isSupported() {
                    do {
                        print(NSDate.init())
                        try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "token": UserDefaults.standard.string(forKey: "token")!])
                        allIsOk = true
                    } catch {
                        print("Authorized, sending error!")
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Ошибка отправки данных на часы", message: "Не удалось отправить данные о Вашем аккаунте на часы. Проверьте, установлено ли приложение на часах и выключен ли на них авиарежим. Вам будет необходимо войти в аккаунт еще раз", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
            DispatchQueue.main.async {
                if allIsOk{
                URLSession.shared.dataTask(with: URL(string: "https://api.vk.com/method/users.get?&user_ids=310385055&fields=photo_200&access_token=\(UserDefaults.standard.string(forKey: "token") ?? "")&v=5.131")!) { data, response, error in
                    if let data = data {
                        do{
                        let userData = try JSONDecoder().decode(UserInfo.self, from: data)
                            self.user = userData
                            UserDefaults.standard.set("\(self.user.response[0].first_name) \(self.user.response[0].last_name)", forKey: "Username")
                            URLSession.shared.dataTask(with: URL(string: (self.user.response[0].photo_200) )!) { data, response, error in
                                if let data = data{
                                    self.imageData = data
                                    self.image1 = imageWithRoundedCornerSize(cornerRadius: UIImage(data: self.imageData)!.size.height / 2, usingImage: UIImage(data: self.imageData)!)
                                    UserDefaults.standard.set(self.user.response[0].photo_200, forKey: "imageURL")
                                    DispatchQueue.main.async {
                                        self.Table.reloadData()
                                    }
                                }
                                if let error = error{
                                    print("Image error: \(error)")
                                }
                            }.resume()
                        }catch let error{
                            print("Parsing 1 error: \(error)")
                        }
                    }
                    
                }.resume()
                }else{
                    VK.sessions.default.logOut()
                }
            }
        },
            onError: { error in
            print("SwiftyVK: authorize failed with", error)
            DispatchQueue.main.async {
                self.Table.reloadData()
            }
        }
        )
    }
    func logout(){
        VK.sessions.default.logOut()
        do {
            try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "token": ""])
        } catch {
            print("Loged out, sending error")
            let alert = UIAlertController(title: "Ошибка отправки данных на часы", message: "Не удалось удалить данные Вашего аккаунта с часов. Проверьте, установлено ли приложение на часах и выключен ли на них авиарежим. Данные будут удалены автоматически при следующем подключении к часам", preferredStyle: .alert)
            let action = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        Table.reloadData()
    }
}

