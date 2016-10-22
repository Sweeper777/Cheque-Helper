import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override init() {
        super.init()
        table.setNumberOfRows(4, withRowType: "MyRow1")
        let row2 = table.rowController(at: 1) as! NumberPadRowController
        let row3 = table.rowController(at: 2) as! NumberPadRowController
        let row4 = table.rowController(at: 3) as! NumberPadRowController
        row2.btn1.setTitle("4")
        row2.btn2.setTitle("5")
        row2.btn3.setTitle("6")
        row3.btn1.setTitle("7")
        row3.btn2.setTitle("8")
        row3.btn3.setTitle("9")
        row4.btn1.setTitle(".")
        row4.btn2.setTitle("0")
        row4.btn3.setTitle("c")
    }
}
