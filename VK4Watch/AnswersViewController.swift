//
//  AnswersViewController.swift
//  VK4Watch
//
//  Created by Максим on 29.08.2021.
//

import UIKit
import WatchConnectivity
class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var EditButtonOutlet: UIBarButtonItem!
    var answersList = ["Привет!", "Как дела?", "Скоро буду.", "ОК","Конечно!","Без проблем!","Спасибо!","Поговорим позже?","Сейчас говорить не могу...","На совещании. Можно я перезвоню позже?","До скорого!","Да","Да, пожалуйста!","Ура!","Отлично!","Нет","Прости, нет.","Нет, спасибо!","Нет!",]
    var tableData = [""]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tableData[indexPath.row]
        if indexPath.row == tableData.count - 1 && !self.TableView.isEditing{
            cell.textLabel?.textColor = .systemBlue
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.TableView.deselectRow(at: indexPath, animated: true)
        if !self.TableView.isEditing && indexPath.row == tableData.count - 1{
            let alertController = UIAlertController(title: "Новый быстрый ответ", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Далее", style: .default, handler: { alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                self.answersList.append(textField.text!)
                self.tableData = self.answersList
                self.tableData.append("Добавить ответ...")
                self.TableView.reloadData()
                UserDefaults.standard.set(self.answersList, forKey: "answersList")
            }))
            alertController.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "Быстрый ответ"
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let el = answersList[sourceIndexPath.row]
        answersList.remove(at: sourceIndexPath.row)
        answersList.insert(el, at: destinationIndexPath.row)
        tableData = answersList
        UserDefaults.standard.set(answersList, forKey: "answersList")
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        TableView.setEditing(editing, animated: animated)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath)
        answersList.remove(at: indexPath.row)
        tableData = answersList
        TableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
           
       if self.TableView.isEditing {
           return UITableViewCell.EditingStyle.delete
       }else{
           return UITableViewCell.EditingStyle.none
       }
    }
    @IBAction func EditButton(_ sender: UIBarButtonItem) {
        if self.TableView.isEditing {
            self.TableView.setEditing(false, animated: true)
            EditButtonOutlet.title = "Править"
            tableData = answersList
            tableData.append("Добавить ответ...")
            self.TableView.insertRows(at: [IndexPath(row: self.TableView.numberOfRows(inSection: 0), section: 0)], with: .automatic)
            UserDefaults.standard.set(answersList, forKey: "answersList")
            if UserDefaults.standard.string(forKey: "token") == nil{
                printError()
            }else{
                if WCSession.isSupported() {
                    do {
                        print(NSDate.init())
                        try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "answersList": UserDefaults.standard.object(forKey: "answersList")!, "token": UserDefaults.standard.string(forKey: "token")!])
                    } catch {
                        DispatchQueue.main.async {
                            self.printError()
                        }
                    }
                }else{
                    printError()
                }
            }
        }else{
            self.TableView.setEditing(true, animated: true)
            EditButtonOutlet.title = "Готово"
            tableData = answersList
            TableView.deleteRows(at: [IndexPath(row: self.TableView.numberOfRows(inSection: 0) - 1, section: 0)], with: .automatic)
        }
    }
    @IBOutlet weak var TableView: UITableView!
    func printError(){
        let alert = UIAlertController(title: "Ошибка обновления данных", message: "Не удалось отправить список ответов на Ваши часы. Проверьте, установлено ли приложение на часах и выключен ли на них авиарежим", preferredStyle: .alert)
        let action = UIAlertAction(title: "Продолжить", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        if UserDefaults.standard.object(forKey: "answersList") != nil{
            answersList = UserDefaults.standard.object(forKey: "answersList")! as! [String]
        }
        tableData = answersList
        tableData.append("Добавить ответ...")
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(answersList, forKey: "answersList")
        if WCSession.isSupported() {
            do {
                print(NSDate.init())
                try WCSession.default.updateApplicationContext(["a" : NSDate.init(), "answersList": UserDefaults.standard.object(forKey: "answersList")!, "token": UserDefaults.standard.string(forKey: "token") ?? ""])
            } catch {}
        }
    }
    
    
}
