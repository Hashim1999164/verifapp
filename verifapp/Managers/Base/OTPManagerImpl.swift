//
//  OTPManagerImpl.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import UIKit
import Alamofire
class OtpManagerImpl: OtpManagerCallback, TokenManagerCallBack {
    
    //MARK: Variables
    //private var context: Context? = nil
    private var isApiKeyValid: Bool{
        get{
        return UserDefaults().getBool("isApiKeyValid")
        }
        set{
            
        }
    }
    
    private var appHashCode = ""
    private var identifier = "dc348MeRc"
    private var operatorCode = ""
    
    var callback: OtpListener? = nil
    private var isSdkInitialized: Bool{
        get{
        return UserDefaults().getBool("isSdkInitialized")
        }
        set{
            
        }
    }
    private var failedOtpInfo: [String: Any]? = nil
    private var currentOtpLevel : BaseOtpImpl? = BaseOtpImpl()
    private var builder: OtpFactory? = OtpFactory()
    
    init(){
        currentOtpLevel?.otpManagerCallback = self
        
    }
    
    //MARK: PROTOCOLS
    func getUUid() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    func getAppHashCode() -> String {
        return ""
    }
    
    func onTimeout(otpLevel: String) {
        saveLastFailedOtpDetails(errCode: "408", errMsg: "Request time out", otpLevel: otpLevel)
    }
    
    func onSuccess(success: Bool) {
        onPhoneVerified(isVerified: success)
    }
    
    func getLastFailedUseCaseObject() -> [String : Any] {
        var obj = failedOtpInfo ?? [String: Any]()
        failedOtpInfo?.removeAll()
        return obj
    }
    
    func onNotify(responseCode: OTPCodes?, message: String?) {
        onNotifyUser(Code: responseCode! , message: message ?? "")
    }
    
    func onFailed(otpLevel: String, responseCode: String?, message: String?) {
        saveLastFailedOtpDetails(errCode: responseCode?.description, errMsg: message, otpLevel: otpLevel)
    }
    
    func onSDKInitialized(responseCode: OTPCodes, message: String) {
        isSdkInitialized = true
        isApiKeyValid = true
        onNotifyUser(Code: OTPCodes.SDK_INITIALIZED, message: message)
    }
    
    func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK: Functions
    func onRequestPermissionsResult(
        requestCode: Int,
        permissions: [String],
        grantResults: [Int]
    ) {
    }
    /**
     *This method is is called to initialize the sdk which first checks the internet connectivity
     * by [Utils.isNetworkConnected] method. If internet is not available, initialization process stops.
     * If device is connected to internet, then api key validity is checked using [NetworkUtils.checkTokenValidity] method.
     * Api key is a base64 encoded string key which is used to execute further verification
     * processes.(Usually provided by SDK Provider)
     * @param apiKey
     * @param context
     * @param callback
     */
    func initialize(apiKey: String, callback: OtpListener, completion: @escaping(_ message: String, _ success: Bool,_ errorCode: OTPCodes) -> ()) {
        let ud = UserDefaults()
        isApiKeyValid = ud.getBool("isApiKeyValid")
        isSdkInitialized = ud.getBool("isSdkInitialized")
        if(!isNetworkConnected())
        {
            completion("No Internet Connectivity", false, OTPCodes.NO_INTERNET)
            self.isSdkInitialized = false
            self.isApiKeyValid = false
            return
        }
        if(AuthUtils().validateToken()){
            completion("SDK Already Intialized", true, OTPCodes.SDK_INITIALIZED)
            self.isSdkInitialized = true
            self.isApiKeyValid = true
            return
        }
        else{
            self.isSdkInitialized = false
            self.isApiKeyValid = false
            UserDefaults().saveBool("isSdkInitialized", value: false)
            UserDefaults().saveBool("isApiKeyValid", value: false)
            
        }
        print("Checking Token Validity")
        if(isSdkInitialized ?? false){
            if(AuthUtils().validateToken()){
                self.isApiKeyValid = true
            }
            else{
                completion("Please use Valid API Key", false, OTPCodes.INVALID_SDK_API_KEY)
                self.isSdkInitialized = false
                self.isApiKeyValid = false
                return
            }
        }
        let tokenManager = TokenManager()
        tokenManager.initToken(apiKey: apiKey, completion: {
            (code, message , success) in
            if(success){
                self.isSdkInitialized = true
                self.isApiKeyValid = true
                var ud = UserDefaults()
                ud.set(apiKey, forKey: Appstatemanager.shared.CurrentPreferences.API_KEY)
                ud.saveBool("isSdkInitialized", value: true)
                ud.saveBool("isApiKeyValid", value: true)
                completion(message, success, OTPCodes.SDK_INITIALIZED) // Means Success!
            }
            else{
                self.isSdkInitialized = false
                self.isApiKeyValid = false
                completion(message, success, OTPCodes.SDK_NOT_INITIALIZED)
            }
        })
    }
    /**
     * Saves error info about the last failed usecase.
     * @param errCode: Error code from failed api's response
     * @param errMsg: Error message from failed api's response.
     * @param otpLevel: Name of Otp level that failed.
     */
    func saveLastFailedOtpDetails(
        errCode: String?,
        errMsg: String?,
        otpLevel: String
    ) {
        failedOtpInfo = [String: Any]()
        if(!(errCode?.isEmpty ?? false) && !(errMsg?.isEmpty ?? false)){
                failedOtpInfo = [
                    "otp_level" : currentOtpLevel!.getOtpName(),
                    "time_stamp" : Date(),
                    "err_code" : errCode,
                    "err_msg" : errMsg
                ]
        }
    }
    /**
     * Checks if the SDK is initialized & the validity(format) of the provided phone number, if the phone number is not valid then it notifies
     * the user and stops the verification process. whereas if the provided phone number is valid then it
     * initiates the verification process
     *
     * @param phoneNumber: Number provided by the user.
     */
    func verifyPhoneNumber(phoneNumber: String, completion: @escaping(_ code: OTPCodes, _ message: String, _ timeout: Int64,_ success: Bool)->()) {
        var ud = UserDefaults()
        isApiKeyValid = ud.getBool("isApiKeyValid")
        isSdkInitialized = ud.getBool("isSdkInitialized")
        if(!isNetworkConnected())
        {
            completion(OTPCodes.NO_INTERNET, "No Internet Connectivity",-1, false)
            return
        }
        if(!(isApiKeyValid ?? false) || !(isSdkInitialized ?? false)){
            completion(OTPCodes.SDK_NOT_INITIALIZED, "Please Initialize SDK Before using it", -1, false)
            return
        }
        if(!AuthUtils().validateToken()){
            //Need to Request new token, currently returning error
            let tokenManager = TokenManager()
            tokenManager.initToken(apiKey: UserDefaults().getString(Appstatemanager.shared.CurrentPreferences.API_KEY), completion: {
                (code, message, success) in
                if(success){
                    self.isSdkInitialized = true
                    self.isApiKeyValid = true
                    if(!self.validatePhoneNumber(phoneNumber: phoneNumber)){
                        completion(OTPCodes.INVALID_PHONE_NUMBER, "Invalid Phone Number", -1, false)
                        return
                    }
                    var scope = SharedPreferenceManager.getPreferenceInstance().read(valueKey: Appstatemanager.shared.CurrentPreferences.SCOPE) ?? ""
                    if(scope.contains("app-permission")){
                        self.buildOtp(completion: {
                            (code, message, timeout, success) in
                            completion(code, message, timeout, success)
                        })
                    }
                    else{
                        self.buildOtp(completion: {
                            (code, message, timeout, success) in
                            completion(code, message, timeout, success)
                        })
                    }
                    return
                }
                else{
                    self.isSdkInitialized = false
                    self.isApiKeyValid = false
                    completion(OTPCodes.SDK_NOT_INITIALIZED, "SDK Initialization Failed/Expired", -1, false)
                    return
                }
            })
            
        }
        if(!validatePhoneNumber(phoneNumber: phoneNumber)){
            completion(OTPCodes.INVALID_PHONE_NUMBER, "Invalid Phone Number", -1, false)
            return
        }
        
        UserDefaults().saveString(Appstatemanager.shared.CurrentPreferences.PHONE_NUMBER, value: phoneNumber)
        var scope = SharedPreferenceManager.getPreferenceInstance().read(valueKey: Appstatemanager.shared.CurrentPreferences.SCOPE) ?? ""
        if(scope.contains("app-permission")){
            buildOtp(completion: {
                (code, message, timeout, success) in
                completion(code, message, timeout, success)
            })
        }
        else{
            buildOtp(completion: {
                (code, message, timeout, success) in
                completion(code, message, timeout, success)
            })
        }
    }
    /**
     * Verifies that the number entered by user is valid.
     * @param phoneNumber: Number entered by user
     */
    private func validatePhoneNumber(phoneNumber: String) -> Bool{
        return Utils().isNumberValidated(phoneNumber: phoneNumber)
    }
    /**
     * Fetches the Otp list from the configurations and passes to the otpfactory to return a suitable
     * Otplevel instance and start verification process.
     */
    private func buildOtp(completion: @escaping(_ code: OTPCodes, _ message: String, _ timeout: Int64,_ success: Bool) -> ()) {
        var savedScope = ""
        var scope = SharedPreferenceManager.getPreferenceInstance().read(valueKey: Appstatemanager.shared.CurrentPreferences.SCOPE) ?? ""
        var nextOTP = OtpConfiguration().getNextOtp(current: currentOtpLevel?.getOtpName(), scope: Appstatemanager.shared.CurrentPreferences.SCOPE)
        currentOtpLevel?.dispose()
        if(nextOTP != ""){
            currentOtpLevel = builder?.build(type: nextOTP ?? "", callback: self, uuid: getUUid(), appHashCode: "")
            currentOtpLevel?.proceed(completion: {
                (code, message, timeout, success) in
                completion(code, message, timeout, success)
            })

        }
        else{
            completion(OTPCodes.NUMBER_NOT_VERIFIED, "Number Not Verified", -1, false)
        }
    }
    /**
     * Handles the manual verification in case of Whatsapp message.
     * @param code: 6 Digit Verification code received from Api.
     * @param Level: Current OTP level
     */
    func ManualOtpVerify(code: String, Level: String, completion: @escaping(_ code: OTPCodes, _ message: String, _ success: Bool) -> ()) {
        var UtilsInstance = Utils()
        if(false/*UtilsInstance.isOtpValidated(code: code) != nil*/){
            completion(OTPCodes.INVALID_OTP, "OTP Empty", false)
            return
        }
        var otp = code.uppercased()
        var code = SharedPreferenceManager.getPreferenceInstance().read(valueKey: Appstatemanager.shared.CurrentPreferences.SECRET_CODE) ?? ""
        var params = getDefaultOtpResponseParams(status: true, code: otp, level: Level)
        params["cellno"] = UtilsInstance.getPhoneNumber()
        params["dialing_code"] = UtilsInstance.getDialingCode(phoneNumber: UtilsInstance.getPhoneNumber())
        
        currentOtpLevel?.onVerifyOtp(code: code, params: params, completion: {
            (code, message, success) in
            completion(code,message,success)
        })
    }
    private func getDefaultOtpResponseParams(
        status: Bool,
        code: String,
        level: String
    ) -> [String: Any]{
        var params: [String: Any] = [
            "uuid" : getUUid(),
            "code" : code,
            "verified" : status,
            "otp_level" : level,
            "org_id" : "mm"
        ]
        return params
    }
    
    /**
     * If the phone number is verified, this method Notifies the app activity to perform required changes on UI etc.
     * @param isVerified: True if the phone number is verified, false else wise.
     */
    private func onPhoneVerified(isVerified: Bool = true) {
        var manager = SharedPreferenceManager.getPreferenceInstance()
        var code = manager.read(valueKey: Appstatemanager.shared.CurrentPreferences.SECRET_CODE) ?? ""
        callback?.PhoneNumberVerified(method: code, isVerified: isVerified)
    }
    
    /**
     * Notifies User about the current message generated by the sdk.
     * @param errorCode
     * @param message
     */
    private func onNotifyUser(Code: OTPCodes, message: String) {
        callback?.onNotifyUser(code: Code, message: message, timeOut: currentOtpLevel?.getTimeout() ?? -1)
    }
    
    /**
     *Cancels currently running verification process by disposing off current otp level.
     */
    func cancelOtp() {
        OtpTimeoutThreadImpl().haltProcess()
        currentOtpLevel?.dispose()
        currentOtpLevel = nil
    }
    
    /**
     * Releases all the resources and callbacks acquired by respective Otp level
     */
    func dispose() {
        
    }
    
    static func getInstance() -> OtpManagerImpl {
        return OtpManagerImpl()
    }
    
    private func showCallDialog(otpManager: OtpManagerImpl) {
        //TODO: Create a dialog wrapper and call it in this function
        /// Wont work on it!
    }
    
}
