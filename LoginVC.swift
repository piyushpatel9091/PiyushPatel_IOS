//
//  LoginVC.swift
//  Doc99
//
//  Created by Pritesh Pethani on 30/03/17.
//  Copyright © 2017 Pritesh Pethani. All rights reserved.
//

import UIKit
import SVProgressHUD
import Crashlytics


class LoginVC: UIViewController,SyncManagerDelegate {
    // FIXME: - VARIABLE
    
    @IBOutlet var txtEmailID:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var scrMain:UIScrollView!
    
    @IBOutlet var lblEmailID:UILabel!
    @IBOutlet var lblPassword:UILabel!
    @IBOutlet var btnForgotPassword:UIButton!
    @IBOutlet var btnNewUser:UIButton!
    @IBOutlet var btnSignup:UIButton!
    @IBOutlet var btnSignupFacebook:UIButton!
    @IBOutlet var lblSignIn:UILabel!
    
    
    var isFromTab:String?
    
    var byPassScreenName:String?

    var articalID:String!

    var articalWelcomeHealthConcernData = NSArray()

    var fbSubmitedData = NSDictionary()
    
    // FIXME: - VIEW CONTROLLER METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generalViewControllerSetting()
     //   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
      //  NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        APPDELEGATE.sideMenuController?.removeGesture()
        APPDELEGATE.myTabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TODO: - OTHER METHODS
    func generalViewControllerSetting(){
        
        if let healthData = USERDEFAULT.value(forKey: "userHealthCategoryData") as? NSArray{
            articalWelcomeHealthConcernData = healthData.mutableCopy() as! NSArray
            print("USERDEFAULT HEALTH CONCERN DATA : ",articalWelcomeHealthConcernData)
        }

        
        
        self.addTapGestureInOurView()
        self.setLocalizationText()
    }
    func addTapGestureInOurView(){
        let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTap(_:)))
        tapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @IBAction func backgroundTap(_ sender:UITapGestureRecognizer){
        let point:CGPoint = sender.location(in: sender.view)
        let viewTouched = view.hitTest(point, with: nil)
        
        if viewTouched!.isKind(of: UIButton.self){
            
        }
        else{
            self.view.endEditing(true)
            scrMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }
    }
    
    func setLocalizationText(){
        
        lblEmailID.text = NSLocalizedString("emailid", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "")
        lblPassword.text = NSLocalizedString("password", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "")
        btnForgotPassword.setTitle(NSLocalizedString("forgotpassword", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), for: .normal)
        btnNewUser.setTitle(NSLocalizedString("newuser", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), for: .normal)
        btnSignup.setTitle(NSLocalizedString("signup", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), for: .normal)
        btnSignupFacebook.setTitle(NSLocalizedString("signinwithfacebook", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), for: .normal)
        lblSignIn.text = NSLocalizedString("signin", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "")
        
    }
    
    
    // TODO: - DELEGATE METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage=textField.tag+1;
        let nextResponder=textField.superview?.superview?.viewWithTag(nextTage) as UIResponder!
        if (nextResponder != nil){
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            scrMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            
        }
        return false
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var YOffset:Int = 0
        
        if (textField.tag==4) {
            YOffset=10
        }
        else if (textField.tag==5){
            YOffset=12
        }
        
        if (DeviceType.IS_IPHONE_4_OR_LESS) {
            
            if (textField.tag==4) {
                YOffset=15
            }
            else if (textField.tag==5){
                YOffset=22
                
            }
        }
        scrMain.setContentOffset(CGPoint(x: 0, y: CGFloat(textField.tag * YOffset)), animated: true)
        return true
        
    }

    // TODO: - ACTION METHODS
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrMain.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrMain.contentInset = contentInset
        
        //        scrMain.contentOffset = CGPoint(x: scrMain.frame.origin.x, y: CGFloat(contentInset))
    }
    
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = .zero
        scrMain.contentInset = contentInset
    }
    
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
//            Crashlytics.sharedInstance().crash()

        self.view.endEditing(true)
        scrMain.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        
        if txtEmailID.text == ""{
            showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title:NSLocalizedString("Please enter emailId", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "") )
        }
        else if isValidEmail(testStr: txtEmailID.text!) == false{
            showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title:NSLocalizedString("Please enter emailId in valid format", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "") )
        }
        else if txtPassword.text == ""{
            showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title:NSLocalizedString("Please enter password", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "") )
        }
        else{
            if Reachability.isConnectedToNetwork() == true {
                SVProgressHUD.show(withStatus: "Loading..")
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForLogin), userInfo: nil, repeats: false)
            } else {
                showAlert(NSLocalizedString(CheckConnection, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(InternetError, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
            }
        }
    }
    
    @IBAction func btnFacebookLoginClicked(_ sender:UIButton){
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //fbLoginManager.loginBehavior = FBSDKLoginBehavior.Browser
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: APPDELEGATE.navigationC) { (result, error) in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.fetchUserInfo()
                    //fbLoginManager.logOut()
                }
            }
            
        }
        
        
    }
    
    func fetchUserInfo(){
        if((FBSDKAccessToken.current()) != nil){
            
            print("Token is available : \(FBSDKAccessToken.current().tokenString)")
            
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, link, first_name, last_name, picture.type(large), email, birthday,location ,friends ,hometown , friendlists"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    print("Facebook Login Detail :",result  as! NSDictionary)
                    
                    let email = (result as! NSDictionary).value(forKey: "email") as! String
                    let id = (result as! NSDictionary).value(forKey: "id") as! String
                    let name = (result as! NSDictionary).value(forKey: "name") as! String
                    let firstname =  (result as! NSDictionary).value(forKey: "first_name") as! String
                    let lastname =  (result as! NSDictionary).value(forKey: "last_name") as! String
                    
                    
                    if Reachability.isConnectedToNetwork() == true {
                        SVProgressHUD.show(withStatus: "Loading..")
                        self.postDataOnWebserviceForFacebookLogin(emailID: email, fullname: name, authenticationID: id, authenticationProvider: "facebook")
                        //                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForFacebookLogin(emailID:fullname:authenticationID:authenticationProvider:)), userInfo: nil, repeats: false)
                    } else {
                        showAlert(NSLocalizedString(CheckConnection, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(InternetError, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
                    }
                    
                }
            })
        }
    }
    
    
    
    @IBAction func btnRegisterClicked(_ sender:UIButton){
        let registrationVC = RegisterVC(nibName: "RegisterVC", bundle: nil)
        registrationVC.isFromHealthCategory = false
        self.navigationController?.pushViewController(registrationVC, animated: true)
        
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender:UIButton){
        let forgotPasswordVC = ForgetPasswordVC(nibName: "ForgetPasswordVC", bundle: nil)
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // TODO: - POST DATA METHODS
    func postDataOnWebserviceForLogin(){
        let completeURL = NSString(format:"%@%@", MainURL,loginURL) as String
        
        let params:NSDictionary = [
            "email" : txtEmailID.text!,
            "password" : txtPassword.text!,
            "device_token":"56f1s",
            "device_type":"1",
            "lang_type":Language_Type
        ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("Login API Parameter :",finalParams)
        print("Login API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: loginURLTag)
    }
    
    func postDataOnWebserviceForFacebookLogin(emailID:String,fullname:String,authenticationID:String,authenticationProvider:String){
        let completeURL = NSString(format:"%@%@", MainURL,registrationURL) as String
        
//        "phone":"+917698889091",
//        "ccode":"+91",
        
        let params:NSDictionary = [
            "device_token":"56f1s",
            "device_type":"1",
            "lang_type":Language_Type,
            "auth_id":authenticationID,
            "auth_provider":authenticationProvider,
            "fullname":fullname,
            "email":emailID
        ]
        
        fbSubmitedData = params.mutableCopy() as! NSDictionary
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("Facebook Login API Parameter :",finalParams)
        print("Facebook Login API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: registrationURLTag)
        
    }
    
    
    func postDataOnWebserviceForAddToBookMark(){
        let completeURL = NSString(format:"%@%@", MainURL,addArticalBookMarkURL) as String
        
        let params:NSDictionary = [
            "user_id" : USERDEFAULT.value(forKey: "userID") as! String,
            "token": USERDEFAULT.value(forKey: "token") as! String,
            "lang_type":Language_Type,
            "article_id":articalID
        ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("AddToBookMark API Parameter :",finalParams)
        print("AddToBookMark API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: addArticalBookMarkURLTag)
    }
    
    func postDataOnWebserviceForUpdateProfile(){
        let completeURL = NSString(format:"%@%@", MainURL,editUserProfileURL) as String
        
        let params:NSDictionary = [
            "user_id" : USERDEFAULT.value(forKey: "userID") as! String,
            "token": USERDEFAULT.value(forKey: "token") as! String,
            "lang_type":Language_Type,
            "health_concern":articalWelcomeHealthConcernData,
            ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("UpdateProfile API Parameter :",finalParams)
        print("UpdateProfile API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: editUserProfileURLTag)
    }
    
    
    
    func syncSuccess(_ responseObject: Any!, withTag tag: Int) {
        switch tag {
        case loginURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("Login Response  : \(resultDict)")
            
            if resultDict.value(forKey: "status") as! String == "1"{
                
//                if (resultDict.value(forKey: "data") as AnyObject).value(forKey: "is_member") as! String == "0"{
//                    let dataDictionary = resultDict.value(forKey: "data") as! NSDictionary
//
//                    USERDEFAULT.setValue(dataDictionary.value(forKey: "user_id") as! String, forKey: "userID")
//                    USERDEFAULT.synchronize()
//                    
//                    USERDEFAULT.setValue(dataDictionary.value(forKey: "token") as! String, forKey: "token")
//                    USERDEFAULT.synchronize()
//                    
//                    USERDEFAULT.setValue(dataDictionary.value(forKey: "email") as! String, forKey: "emailID")
//                    USERDEFAULT.synchronize()
//                    
//                    USERDEFAULT.setValue(dataDictionary.value(forKey: "fullname") as! String, forKey: "fullName")
//                    USERDEFAULT.synchronize()
//
//                    USERDEFAULT.setValue(dataDictionary.value(forKey: "is_member") as! String, forKey: "isMember")
//                    USERDEFAULT.synchronize()
//
//                    
//                    let joinMemberVC = JoinMemberVC(nibName: "JoinMemberVC", bundle: nil)
//                    joinMemberVC.isFromOther = false
//                    self.navigationController?.pushViewController(joinMemberVC, animated: true)
//                }
//                else{
                    let dataDictionary = resultDict.value(forKey: "data") as! NSDictionary
                    
                    USERDEFAULT.setValue(dataDictionary.value(forKey: "user_id") as! String, forKey: "userID")
                    USERDEFAULT.synchronize()
                    
                    USERDEFAULT.setValue(dataDictionary.value(forKey: "token") as! String, forKey: "token")
                    USERDEFAULT.synchronize()
                    
                    USERDEFAULT.setValue(dataDictionary.value(forKey: "email") as! String, forKey: "emailID")
                    USERDEFAULT.synchronize()
                    
                    USERDEFAULT.setValue(dataDictionary.value(forKey: "fullname") as! String, forKey: "fullName")
                    USERDEFAULT.synchronize()
                    
                    USERDEFAULT.setValue(dataDictionary.value(forKey: "is_member") as! String, forKey: "isMember")
                    USERDEFAULT.synchronize()

                if articalWelcomeHealthConcernData.count > 0{
                    if Reachability.isConnectedToNetwork() == true {
                        SVProgressHUD.show(withStatus: "Loading..")
                        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.postDataOnWebserviceForUpdateProfile), userInfo: nil, repeats: false)
                    } else {
                        showAlert(NSLocalizedString(CheckConnection, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(InternetError, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
                    }
                }
                
                    
                    if let offlineBookMarkData = USERDEFAULT.value(forKey: "offlineBookMarkArticalData") as? NSArray{
                        print("Offline Bookmark Data : ",offlineBookMarkData)
                        print("Offline Bookmark Data Count: ",offlineBookMarkData.count)
                        
                        if offlineBookMarkData.count > 0{
                            for i in 0...offlineBookMarkData.count - 1 {
                                if let ifFav = (offlineBookMarkData[i] as AnyObject).value(forKey: "is_favourite") as? String{
                                    let fav = "\(ifFav)"
                                    if fav == "1"{
                                        articalID = (offlineBookMarkData[i] as AnyObject).value(forKey: "article_id") as! String
                                        if Reachability.isConnectedToNetwork() == true {
                                            self.performSelector(inBackground: #selector(self.postDataOnWebserviceForAddToBookMark), with: nil)
                                        }else{
                                            showAlert(NSLocalizedString(CheckConnection, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(InternetError, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    if byPassScreenName == "welcomeScreen"{
                        let joinMemberVC = JoinMemberVC(nibName: "JoinMemberVC", bundle: nil)
                        joinMemberVC.isFromOther = false
                        self.navigationController?.pushViewController(joinMemberVC, animated: true)
                    }
                    else if byPassScreenName == "healthCategoryScreen"
                    {
                        let  homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                        homeVC.selectedIndexOfMyTabbarController = 0
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    else{
                        
                        if isFromTab=="0"{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 0
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        else if isFromTab=="1"{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 1
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        else if isFromTab=="2"{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 2
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        else if isFromTab=="3"{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 3
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        else if isFromTab=="4"{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 4
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        else{
                            let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                            homeVC.selectedIndexOfMyTabbarController = 0
                            self.navigationController?.pushViewController(homeVC, animated: true)
                        }
                        
                        
                    }
               // }
                
            }
            else if resultDict.value(forKey: "status") as! String == "0"{
                showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: resultDict.value(forKey: "message") as! String)
            }
            else if resultDict.value(forKey: "status") as! String == "3"{
                
                let dataDictionary = resultDict.value(forKey: "data") as! NSDictionary
                
                showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: resultDict.value(forKey: "message") as! String)
                let varificationVC = VerificationVC(nibName: "VerificationVC", bundle: nil)
//                varificationVC.emailID = txtEmailID.text!
                varificationVC.emailID = dataDictionary.value(forKey: "phone") as! String
                varificationVC.ccCode = dataDictionary.value(forKey: "ccode") as! String
                
                varificationVC.isFrom = "Login"
                varificationVC.byPassScreenName = "healthCategoryScreen"
                self.navigationController?.pushViewController(varificationVC, animated: true)
            }
            
            
            SVProgressHUD.dismiss()
            break
            
        case registrationURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("Facebook Login Response  : \(resultDict)")
            
            if resultDict.value(forKey: "status") as! String == "1"{
                
                let dataDictionary = resultDict.value(forKey: "data") as! NSDictionary
                
                USERDEFAULT.setValue(dataDictionary.value(forKey: "user_id") as! String, forKey: "userID")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.setValue(dataDictionary.value(forKey: "token") as! String, forKey: "token")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.setValue(dataDictionary.value(forKey: "email") as! String, forKey: "emailID")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.setValue(dataDictionary.value(forKey: "fullname") as! String, forKey: "fullName")
                USERDEFAULT.synchronize()
                
                let homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                homeVC.selectedIndexOfMyTabbarController = 0
                self.navigationController?.pushViewController(homeVC, animated: true)
                
            }
            else if resultDict.value(forKey: "status") as! String == "0"{
                showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: resultDict.value(forKey: "message") as! String)
            }
            else if resultDict.value(forKey: "status") as! String == "3"{
                
                let dataDictionary = resultDict.value(forKey: "data") as! NSDictionary
                
                //showAlert(Appname, title: resultDict.value(forKey: "message") as! String)
                let varificationVC = VerificationVC(nibName: "VerificationVC", bundle: nil)
                //                varificationVC.emailID = txtEmailid.text!
                varificationVC.emailID = dataDictionary.value(forKey: "phone") as! String
                varificationVC.ccCode = dataDictionary.value(forKey: "ccode") as! String
                
                varificationVC.isFrom = "FBLogin"
                varificationVC.byPassScreenName = "healthCategoryScreen"
                
                self.navigationController?.pushViewController(varificationVC, animated: true)
            }
            else if resultDict.value(forKey: "status") as! String == "4"{
                let fbMobileVC = FBMobileVC(nibName: "FBMobileVC", bundle: nil)
                fbMobileVC.fbRegisterData = fbSubmitedData
                self.navigationController?.pushViewController(fbMobileVC, animated: true)
            }

            
            
            
            SVProgressHUD.dismiss()
            break
            
        case addArticalBookMarkURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("Add Bookmark Response  : \(resultDict)")
            if resultDict.value(forKey: "status") as! String == "1"{
                
            }
            break
            
        case editUserProfileURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("UpdateProfile Response  : \(resultDict)")
            
            if resultDict.value(forKey: "status") as! String == "1"{
                if let fullname = (resultDict.value(forKey: "data") as! NSDictionary).value(forKey: "fullname") as? String{
                    let name = "\(fullname)"
                    USERDEFAULT.set(name, forKey: "fullName")
                    USERDEFAULT.synchronize()
                    let notificationName = Notification.Name("updateProfileDataNotification")
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                }
                let notificationName = Notification.Name("updateHealthConcernDataNotification")
                NotificationCenter.default.post(name: notificationName, object: nil)

                
            }
            else if resultDict.value(forKey: "status") as! String == "0"{
                showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: resultDict.value(forKey: "message") as! String)
            }
            else if resultDict.value(forKey: "status") as! String == "3"{
            }
            
            //SVProgressHUD.dismiss()
            break

            
            
        default:
            break
            
        }
        
    }
    func syncFailure(_ error: Error!, withTag tag: Int) {
        switch tag {
        case loginURLTag:
            SVProgressHUD.dismiss()
            break
            
        case addArticalBookMarkURLTag:
            break

        case editUserProfileURLTag:
           // SVProgressHUD.dismiss()
            break
   
        default:
            break
            
        }
        print("syncFailure Error : ",error.localizedDescription)
        showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(FailureAlert, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
    }
    
    
}
