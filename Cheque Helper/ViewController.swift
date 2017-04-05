import UIKit
import GoogleMobileAds
import DoneToolbarSwift
import EZSwiftExtensions
import SCLAlertView

class ViewController: UIViewController, GADInterstitialDelegate {
    @IBOutlet var tfAmount: UITextField!
    @IBOutlet var languageChoice: UISegmentedControl!
    @IBOutlet var result: UITextView!
    var showRateMsgAlreadyCalled = false
    var interstitialAd: GADInterstitial!
    
    var englishFont: UIFont!
    
    override func viewDidLoad() {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
        
        englishFont = result.font
        
        let toolbar = ToolbarWithDone(viewsWithToolbar: [tfAmount])
        toolbar.barTintColor = UIColor(hexString: "5abb5a")
        toolbar.tintColor = UIColor.white
        
        tfAmount.inputAccessoryView = toolbar
        
        tfAmount.becomeFirstResponder()
    }
    
    func showRateMsg() {
//        let alert = UIAlertController(title: NSLocalizedString("Enjoying Cheque Helper?", comment: ""), message: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Rate!", comment: ""), style: .default) { _ in
//            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!)
//            })
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Send Feedback", comment: ""), style: .default) { _ in
//            UIApplication.shared.openURL(URL(string: "mailto:sumulang@gmail.com?subject=Cheque Helper Feedback".addingPercentEscapes(using: String.Encoding.utf8)!)!)
//            })
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe Later", comment: ""), style: .default, handler: nil))
//        self.present(alert, animated: true, completion: { [weak self] in self?.showRateMsgAlreadyCalled = false })
        
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton(NSLocalizedString("Rate!", comment: "")) {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!)
        }
        alert.addButton(NSLocalizedString("Send Feedback", comment: "")) {
            UIApplication.shared.openURL(URL(string: "mailto:sumulang@gmail.com?subject=Cheque Helper Feedback".addingPercentEscapes(using: String.Encoding.utf8)!)!)
        }
        alert.addButton(NSLocalizedString("Maybe Later", comment: ""), action: {})
        _ = alert.showCustom(NSLocalizedString("Enjoying Cheque Helper?", comment: ""), subTitle: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), color: UIColor(hexString: "5abb5a")!, icon: UIImage())
        self.showRateMsgAlreadyCalled = false
    }

    @IBAction func textChanged(_ sender: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let amount = Int(tfAmount.text?.replacingOccurrences(of: formatter.groupingSeparator, with: "") ?? "a") {
            if let formatted = formatter.string(from: NSNumber(value: amount)) {
                tfAmount.text = formatted
            }
        }
        
        if languageChoice.selectedSegmentIndex == 0 {
            displayEnglishResult()
        } else {
            displayChineseResult()
        }
        
        if arc4random_uniform(100) < 3 {
            if !showRateMsgAlreadyCalled {
                perform(#selector(showRateMsg), with: self, afterDelay: Double(arc4random_uniform(10)))
                showRateMsgAlreadyCalled = true
            }
        } else if arc4random_uniform(100) < 6 {
            if interstitialAd.isReady {
                interstitialAd.present(fromRootViewController: self)
            }
        }
    }
    
    @IBAction func changedLanguage(_ sender: UISegmentedControl) {
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
//            title = "支票小幫手"
            result.font = UIFont(name: "Helvetica", size: 25)
        }
        view.endEditing(true)
    }
    
    @IBAction func swipedDown(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    fileprivate func displayEnglishResult () {
        let converter = EnglishChequeConverter()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let x = formatter.number(from: tfAmount.text!) {
            result.text = converter.convertNumberString(x.description)
        } else {
            result.text = converter.convertNumberString("")
        }
    }
    
    fileprivate func displayChineseResult () {
        let converter = ChineseChequeConverter()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let x = formatter.number(from: tfAmount.text!) {
            result.text = converter.convertNumberString(x.description)
        } else {
            result.text = converter.convertNumberString("")
        }
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
    }
    
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        interstitialAd = GADInterstitial(adUnitID: interstitialAdID)
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
        interstitialAd.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
    }
}

