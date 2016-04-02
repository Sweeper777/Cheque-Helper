import UIKit
import GoogleMobileAds

class ViewController: UIViewController{
    @IBOutlet var tfAmount: UITextField!
    @IBOutlet var languageChoice: UISegmentedControl!
    @IBOutlet var result: UITextView!
    @IBOutlet var btnConvert: UIButton!
    @IBOutlet var adBanner: GADBannerView!
    
    override func viewDidLoad() {
        result.font = UIFont (name: "Kailasa", size: CGFloat.init(integerLiteral: 36))
        adBanner.rootViewController = self
        adBanner.adUnitID = "ca-app-pub-top secret"
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.loadRequest(GADRequest())
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
            btnConvert.titleLabel?.text = "Convert!"
            title = "Cheque Helper"
        } else {
            displayChineseResult()
            tfAmount.placeholder = "輸入幣值"
            btnConvert.titleLabel?.text = "轉換！"
            title = "支票小幫手"
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

