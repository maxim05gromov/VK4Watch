//
//  ViewController.swift
//  VK4Watch
//
//  Created by Максим on 04.06.2021.
//

import UIKit
import WatchConnectivity
import SwiftyVK
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                return 80
            }else{
                return 45
            }
        }else{
            return 45
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                cell?.textLabel?.text = "Max"
            }else{
                cell?.textLabel?.text = "Войти"
            }
        }else if indexPath.section == 1{
            cell?.textLabel?.text = ""
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if VK.sessions.default.accessToken != nil{
                logout()
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

    }
    
    
    func login(){
        VK.sessions.default.logIn(
            onSuccess: { info in
            print("SwiftyVK: success authorize with", info)
            if UserDefaults.standard.string(forKey: "token") != nil{
                if WCSession.isSupported() {
                    do {
                        print(NSDate.init())
                        try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "token": UserDefaults.standard.string(forKey: "token")!])
                    } catch {
                        print("error")
                    }
                }
            }
            DispatchQueue.main.async {
                self.Table.reloadData()
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
            print(NSDate.init())
            try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "token": ""])
        } catch {
            print("error")
        }
        Table.reloadData()
    }
}

