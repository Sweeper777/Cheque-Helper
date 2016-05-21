import UIKit
import GoogleMobileAds

class ViewController: UIViewController{
    @IBOutlet var tfAmount: UITextField!
    @IBOutlet var languageChoice: UISegmentedControl!
    @IBOutlet var result: UITextView!
    @IBOutlet var btnConvert: UIButton!
    @IBOutlet var adBanner: GADBannerView!
    
    var englishFont: UIFont!
    
    override func viewDidLoad() {
        adBanner.rootViewController = self
        adBanner.adUnitID = adUnitID
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.loadRequest(GADRequest())
        
        englishFont = result.font
    }

    @IBAction func convertClicked(sender: UIButton) {
        if languageChoice.selectedSegmentIndex == 0 {
            displayEnglishResult()
        } else {
            displayChineseResult()
        }
        view.endEditing(true)
    }
    
    @IBAction func changedLanguage(sender: UISegmentedControl) {
        if languageChoice.selectedSegmentIndex == 0 {
            displayEnglishResult()
            tfAmount.placeholder = "Enter Amount"
            btnConvert.setTitle("Convert!", forState: .Normal)
            btnConvert.setTitle("Convert!", forState: .Highlighted)
            btnConvert.setTitle("Convert!", forState: .Selected)
            title = "Cheque Helper"
            result.font = englishFont
        } else {
            displayChineseResult()
            tfAmount.placeholder = "輸入幣值"
            btnConvert.setTitle(" 轉換！", forState: .Normal)
            btnConvert.setTitle(" 轉換！", forState: .Highlighted)
            btnConvert.setTitle(" 轉換！", forState: .Selected)
            title = "支票小幫手"
            result.font = UIFont(name: "Helvetica", size: 25)
        }
        view.endEditing(true)
    }
    
    @IBAction func swipedDown(sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func displayEnglishResult () {
        let converter = EnglishChequeConverter()
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        if let x = formatter.numberFromString(tfAmount.text!) {
            result.text = converter.convertNumberString(x.description)
        } else {
            result.text = converter.convertNumberString("")
        }
    }
    
    private func displayChineseResult () {
        let converter = ChineseChequeConverter()
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        if let x = formatter.numberFromString(tfAmount.text!) {
            result.text = converter.convertNumberString(x.description)
        } else {
            result.text = converter.convertNumberString("")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
}

