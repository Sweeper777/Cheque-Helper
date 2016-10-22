import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var amountLbl: WKInterfaceLabel!
    @IBOutlet var convertedLbl: WKInterfaceLabel!
    
    var amountText: String = ""

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override init() {
        super.init()
        amountLbl.setText("")
        convertedLbl.setText(NSLocalizedString("Please enter a valid amount", comment: ""))
    }
    
    @IBAction func pressed1() {
        amountLbl.setText(amountText + "1")
        amountText += "1"
    }
    
    @IBAction func pressed2() {
        amountLbl.setText(amountText + "2")
        amountText += "2"
    }
    
    @IBAction func pressed3() {
        amountLbl.setText(amountText + "3")
        amountText += "3"
    }
    
    @IBAction func pressed4() {
        amountLbl.setText(amountText + "4")
        amountText += "4"
    }
    
    @IBAction func pressed5() {
        amountLbl.setText(amountText + "5")
        amountText += "5"
    }
    
    @IBAction func pressed6() {
        amountLbl.setText(amountText + "6")
        amountText += "6"
    }
    
    @IBAction func pressed7() {
        amountLbl.setText(amountText + "7")
        amountText += "7"
    }
    
    @IBAction func pressed8() {
        amountLbl.setText(amountText + "8")
        amountText += "8"
    }
    
    @IBAction func pressed9() {
        amountLbl.setText(amountText + "9")
        amountText += "9"
    }
    
    @IBAction func pressedDot() {
        amountLbl.setText(amountText + ".")
        amountText += "."
    }
    
    @IBAction func pressed0() {
        amountLbl.setText(amountText + "0")
        amountText += "0"
    }
    
    @IBAction func pressedC() {
        amountLbl.setText("")
        amountText = ""
    }
}
