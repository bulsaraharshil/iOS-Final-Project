import UIKit
import FirebaseAuth
import FirebaseAnalytics

class LoginViewController: UIViewController {
    
    private var welcomeSegue = "goToWelcome"

    @IBOutlet weak var errorMsg2: UILabel!
    @IBOutlet weak var errorMsg1: UILabel!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pswdInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.isEnabled = false
        errorMsg1.isHidden = true
        errorMsg2.isHidden = true
    }


    @IBAction func emailChanged(_ sender: UITextField) {
        if(sender.text == ""){
            errorMsg1.isHidden = false
            errorMsg1.text = "Please enter a email"
        } else {
            errorMsg1.isHidden = true
        }
        
        if((emailInputField.text != "") && (pswdInputField.text != "")){
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }
    }
    @IBAction func pswdChanged(_ sender: UITextField) {
        if(sender.text == ""){
        errorMsg2.isHidden = false
        errorMsg2.text = "Please enter password"
        } else {
            errorMsg2.isHidden = true
        }
        if((emailInputField.text != "") && (pswdInputField.text != "")){
            loginBtn.isEnabled = true
        } else {
            loginBtn.isEnabled = false
        }
    }
    @IBAction func onButtonPressed(_ sender: UIButton) {
        Analytics.logEvent("login_button_presses", parameters: nil)
        Auth.auth().signIn(withEmail: emailInputField.text ?? "", password: pswdInputField.text ?? ""){[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            if error != nil {
                strongSelf.showFailedAuthenticateAlert()
                Analytics.logEvent("login_error", parameters: ["error_code": error!._code])
                return
            }
                                Analytics.logEvent(AnalyticsEventLogin, parameters: [
                                    "login_provider": authResult?.additionalUserInfo?.providerID ?? ""
                                ])
            strongSelf.navigateToWelcomeScreen()
        }
    }
    
    private func navigateToWelcomeScreen() {
        performSegue(withIdentifier: welcomeSegue, sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == welcomeSegue {
            if let userIDValidation = Auth.auth().currentUser?.uid {
                let destination = segue.destination as! WelcomeViewController
     
            }
        }
    }
        
    private func showFailedAuthenticateAlert(){
            let alert = UIAlertController(title: "Authentication", message: "Authenticate Again", preferredStyle: .alert)
            let done = UIAlertAction(title: "Ok", style: .default) { _ in
                print("Ok!!!")
            }
            alert.addAction(done)
            self.show(alert, sender: nil)
    }
}
