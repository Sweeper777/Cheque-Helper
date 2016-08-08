import UIKit
import GoogleMobileAds
import DoneToolbarSwift
import EZSwiftExtensions

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
        
        let toolbar = ToolbarWithDone(viewsWithToolbar: [tfAmount])
        toolbar.barTintColor = UIColor(hexString: "5abb5a")
        toolbar.tintColor = UIColor.whiteColor()
        
        tfAmount.inputAccessoryView = toolbar
    }
    
    func showRateMsg() {
        let alert = UIAlertController(title: NSLocalizedString("Enjoying Cheque Helper?", comment: ""), message: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate!", comment: ""), style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Send Feedback", comment: ""), style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: "mailto:sumulang@gmail.com?subject=Cheque Helper Feedback".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
            })
        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe Later", comment: ""), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func textChanged(sender: UITextField) {
        if languageChoice.selectedSegmentIndex == 0 {
            displayEnglishResult()
        } else {
            displayChineseResult()
        }
        
        if arc4random_uniform(100) < 3 {
            performSelector(#selector(showRateMsg), withObject: self, afterDelay: Double(arc4random_uniform(10)))
        }
    }
    
    @IBAction func changedLanguage(sender: UISegmentedControl) {
        if languageChoice.selectedSegmentIndex == 0 {
            displayEnglishResult()
//            tfAmount.placeholder = "Enter Amount"
//            btnConvert.setTitle("Convert!", forState: .Normal)
//            btnConvert.setTitle("Convert!", forState: .Highlighted)
//            btnConvert.setTitle("Convert!", forState: .Selected)
//            title = "Cheque Helper"
            result.font = englishFont
        } else {
            displayChineseResult()
//            tfAmount.placeholder = "輸入幣值"
//            btnConvert.setTitle(" 轉換！", forState: .Normal)
//            btnConvert.setTitle(" 轉換！", forState: .Highlighted)
//            btnConvert.setTitle(" 轉換！", forState: .Selected)
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

