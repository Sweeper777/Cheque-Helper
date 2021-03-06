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
        amountLbl.setText(" ")
        convertedLbl.setText(NSLocalizedString("Please enter a valid amount", comment: ""))
    }
    
    @IBAction func pressed1() {
        changeAmountText { $0 + "1" }
    }
    
    @IBAction func pressed2() {
        changeAmountText { $0 + "2" }
    }
    
    @IBAction func pressed3() {
        changeAmountText { $0 + "3" }
    }
    
    @IBAction func pressed4() {
        changeAmountText { $0 + "4" }
    }
    
    @IBAction func pressed5() {
        changeAmountText { $0 + "5" }
    }
    
    @IBAction func pressed6() {
        changeAmountText { $0 + "6" }
    }
    
    @IBAction func pressed7() {
        changeAmountText { $0 + "7" }
    }
    
    @IBAction func pressed8() {
        changeAmountText { $0 + "8" }
    }
    
    @IBAction func pressed9() {
        changeAmountText { $0 + "9" }
    }
    
    @IBAction func pressedDot() {
        changeAmountText { $0 + "." }
    }
    
    @IBAction func pressed0() {
        changeAmountText { $0 + "0" }
    }
    
    @IBAction func pressedC() {
        changeAmountText { _ in return "" }
    }
    
    func changeAmountText(_ closure: (String) -> String) {
        amountLbl.setText(closure(amountText))
        amountText = closure(amountText)
        if Double(amountText) != nil {
            let englishConverter = EnglishChequeConverter()
            let chineseChequeConverter = ChineseChequeConverter()
            convertedLbl.setText("\(englishConverter.convertNumberString(amountText))\n\n\(chineseChequeConverter.convertNumberString(amountText))")
        } else {
            convertedLbl.setText(NSLocalizedString("Please enter a valid amount", comment: ""))
        }
    }
}
