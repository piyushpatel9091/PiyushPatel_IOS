//
//  Constants.swift
//  SwiftTutorialWithXIB
//
//  Created by Pritesh Pethani on 24/06/16.
//  Copyright © 2016 Pritesh Pethani. All rights reserved.
//

import Foundation


let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let USERDEFAULT = UserDefaults.standard



let dataManager = DataManager.sharedManager() as! DataManager



enum UIUserInterfaceIdiom : Int
{
    case unspecified
    case phone
    case pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64) && os(iOS)
            isSim = true
        #endif
        return isSim
    }()
}


func showAlert(_ messageT:String,title:String){
        let alert:UIAlertView = UIAlertView(title: messageT, message: title, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "CANCEL")
        alert.show()
    
//    let alert = UIAlertController(title: messageT, message: title, preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//    // show the alert
//    presentViewController(alert, animated: true, completion: nil)
    
 
    }

func showAlertForVarification(_ messageT:String,title:String,alertTag:Int){
    let alert:UIAlertView = UIAlertView(title: messageT, message: title, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "CANCEL")
    alert.show()
    alert.cancelButtonIndex = -1
    alert.tag = alertTag
    
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func getStringData(currentFormat:String,strDate:String,newFormat:String) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = currentFormat
    let oldDate = dateFormater.date(from: strDate)
    dateFormater.dateFormat  = newFormat
    let newFormattedDate =  dateFormater.string(from: oldDate!)
    return newFormattedDate
}

func getStringDateFromDate(dateFormat:String,enterDate:Date) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = dateFormat
    let strDate = dateFormater.string(from: enterDate)
    return strDate
}

func convertDateToDeviceTimeZone(myDateString:String,Strformat:String,returnFormat:String) -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = Strformat
    
    //Create the date assuming the given string is in GMT
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    
    let date = dateFormater.date(from: myDateString)
    
    dateFormater.dateFormat = returnFormat
    //Create a date string in the local timezone
    dateFormater.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())
    let localDateString = dateFormater.string(from: date!)
    
    return localDateString
}



func lableTwoDiffrentColor(strVal:String,fontSize:CGFloat,color:UIColor,location:Int,range:Int) -> NSMutableAttributedString {
    var myMutableString = NSMutableAttributedString()
    myMutableString = NSMutableAttributedString(string: strVal, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)])
    myMutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:location,length:range))
    return myMutableString
}

func pb_takeSnapshot(snapShotView:UIView) -> UIImage{
    let rect = snapShotView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    snapShotView.layer.render(in: context)
    let capturedScreen:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsGetCurrentContext()
    return capturedScreen;
}



let PAGINATION_LIMITE = 10

let Language_Type = "1"
let MILE = "10000"


let Appname = "Doc99"
let FailureAlert = "Oops! Something went wrong. Please try again."

let CheckConnection = "Check Connection"
let InternetError = "Internet is not available."

let ExpireTokenMessage = "Your token is expired please login Again!"




let MainURL = "http://demo.magespider.com/doc99/api/"

//http://demo.magespider.com/doc99/api/upload/
let ImageGetURL = "http://demo.magespider.com/doc99/upload/image/"



let imageFileUploadUrl = "http://demo.magespider.com/doc99/upload/upload1.php"



let loginURL = "Registration/CheckLogin"
let logoutURL = "Registration/Logout"
let registrationURL = "Registration/UserRegistration"
let forgetPasswordURL = "Registration/ForgotPassword"

let verifyCodeURL = "Registration/CheckVerificationCode"

let verifyUserURL = "Registration/VerifyUser"

let getFavouriteStoreURL = "General/FvrtStoreList"
let getFavouriteDoctorURL = "General/FvrtDoctorList"

let newPasswordURL = "Registration/UpdatePassword"

let resendCodeURL = "Registration/ResendUserVerificationCode"

let getArticalListURL = "General/ArticleList"

let getBookmarkArticalListURL = "General/FvrtArticleList"

let addArticalBookMarkURL = "General/AddFrvtArticle"
let removeArticalBookMarkURL = "General/RemoveFvrtArticle"

let getArticalCategoryURL = "General/ArticleCategory"


let getDrugListURL = "General/DrugList"

let getDrugCategoryURL = "General/DrugCategory"

let getDrugDiseaseURL = "General/DrugDisease"

let getDoctorListURL = "General/DoctorListForMap"
let getStoreListURL = "General/MedicalListForMap"

let addFavouriteStoreURL = "General/AddFrvtStore"
let removeFavouriteStoreURL = "General/RemoveFvrtStore"

let addFavouriteDoctorURL = "General/AddFrvtDoctor"
let removeFavouriteDoctorURL = "General/RemoveFvrtDoctor"

let drugDetailURL = "General/SingleDrug"
let articleDetailURL = "General/SingleArticle"

let addPatientInfoURL = "General/AddPatient"
let getPatientInfoURL = "General/MyPatientList"
let editPatientInfoURL = "General/EditPatientDetail"
let removePatientInfoURL = "General/RemovePatient"

let contactDoctorURL = "General/Contactdoctor"
let addEprescriptionOrderURL = "General/AddEprescriptionOrder"

let cmsWebPageCallURL = "Registration/Cmspage"


let unReadCountNotificationURL = "Feed/CountUnreadActivity"
let getNotificationURL = "Feed/GetActivity"
let clearAllNotificationURL = "Feed/ClearActivity"
let readNotificationURL = "Feed/ReadActivity"
let unReadNotificationURL = "Feed/UnreadActivity"

let dosesDataURL = "General/DoseForm"
let healthConcernURL = "General/HealthConcern"

let healthCalculateURL = "General/HealthCalculatorData"
let healthReportURL = "General/MyHealthReports"

let saveWeightData = "General/SaveWeightProgData"
let editWeightDataURL = "General/EditWeightProgData"

let resetPasswordURL = "Registration/ChangePassword"

let getUserProfileURL = "Registration/UserDetail"
let editUserProfileURL = "Registration/EditUserDetail"

let getSingleWeightDataURL = "General/SingleWeightProg"
let myWeightProgramDataURL = "General/MyWeightProg"

let searchFoodURL = "General/SearchFood"

let myWeightProgramReportURL = "General/MyWeightProgramReports"

let saveFoodItemURL = "General/SaveFoodItemData"

let singleDayProgramURL = "General/SingleDayProgram"

let joinMemberURL = "Registration/EditUserDetail"


let getCurrentOrderURL = "General/MyCurrentEprescriptionOrder"
let getPreviousOrderURL = "General/MyPastEprescriptionOrder"
let getOrderHistoryDetailURL = "General/AddEprescriptionOrder"



let loginURLTag = 1001
let logoutURLTag = 1002
let registrationURLTag = 1003
let forgetPasswordURLTag = 1004
let verifyCodeURLTag = 1005
let verifyUserURLTag = 1006
let getFavouriteStoreURLTag = 1007
let getFavouriteDoctorURLTag = 1008
let newPasswordURLTag = 1009
let resendCodeURLTag = 1010
let getArticalListURLTag = 1011
let getBookmarkArticalListURLTag = 1012
let addArticalBookMarkURLTag = 1013
let removeArticalBookMarkURLTag = 1014
let getArticalCategoryURLTag = 1015
let getDrugListURLTag = 1016

let getDrugCategoryURLTag = 1017
let getDrugDiseaseURLTag = 1018

let getDoctorListURLTag = 1019
let getStoreListURLTag = 1020

let addFavouriteStoreURLTag = 1021
let removeFavouriteStoreURLTag = 1022

let addFavouriteDoctorURLTag = 1023
let removeFavouriteDoctorURLTag = 1024
let drugDetailURLTag = 1025
let articleDetailURLTag = 1026

let addPatientInfoURLTag = 1027
let getPatientInfoURLTag = 1028
let editPatientInfoURLTag = 1029
let removePatientInfoURLTag = 1030
let contactDoctorURLTag = 1031
let addEprescriptionOrderURLTag = 1032
let cmsWebPageCallURLTag = 1033

let unReadCountNotificationURLTag = 1034
let getNotificationURLTag = 1035
let clearAllNotificationURLTag = 1036
let readNotificationURLTag = 1037

let unReadNotificationURLTag = 1038

let dosesDataURLTag = 1039
let healthConcernURLTag = 1040
let healthCalculateURLTag = 1041
let healthReportURLTag = 1042

let saveWeightDataURLTag = 1043

let editWeightDataURLTag = 1044
let resetPasswordURLTag = 1045

let getUserProfileURLTag = 1046
let editUserProfileURLTag = 1047
let getSingleWeightDataURLTag = 1048
let myWeightProgramDataURLTag = 1049
let searchFoodURLTag = 1050
let myWeightProgramReportURLTag = 1051
let saveFoodItemURLTag = 1052

let singleDayProgramURLTag = 1053
let joinMemberURLTag = 1054

let getCurrentOrderURLTag = 1055
let getPreviousOrderURLTag = 1056
let getOrderHistoryDetailURLTag = 1057

