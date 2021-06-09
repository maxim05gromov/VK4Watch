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
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        TableView.setNumberOfRows(1, withRowType: "MsgCell")
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
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "Message", context: nil)
    }
}
