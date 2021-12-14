//
//  TokenManager.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire
/// - This class is responsible to fetch the token from server and store it in the shared preferences. And finally informs the Otp manager class.
class TokenManager: OnNetworkResponseCallBack, TokenManagerCallBack{
    
    func onSDKInitialized(responseCode: OTPCodes, message: String) {
        
    }
    
    func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    
    var ontokenManagerCallBack: TokenManagerCallBack!
    
    
    init(){
        
    }
    
    //MARK: Variables
    
    var isnetworkConnected: Bool{
        get{
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    //MARK: Functions
    
    func initToken(apiKey: String, completion: @escaping(_ code: OTPCodes,_ message: String, _ success: Bool) -> ()){
        var manager = SharedPreferenceManager.getPreferenceInstance()
        var item = HTTPRequestItem(httpRequestUrl: Constants().API_REQUEST_NEW_ACCESS_TOKEN_GRANT)
        let Headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization" : apiKey,
        ]
        let params: [String: Any] = [
            "grant_type" : "client_credentials", //Appstatemanager.shared.CurrentPreferences.GRANT_TYPE,
            "scope" : Appstatemanager.shared.CurrentPreferences.SCOPE
        ]
        
        item.httpRequestType = "POST"
        item.params = params
        item.headerParams = Headers
        let NM = NetworkUtils()
        NM.executeNetworkRequest(params: item, completion: {
            response in
            if(response.responseCode == 200){
                self.onNetworkSuccess(response: response, completion: {
                    (code, message, success) in
                    completion(code, message, success)
                })
            }
            else{
                self.onNetworkError(response: response, completion: {
                    (code, message, success) in
                    completion(code, message, success)
                })
            }
        })
    }
    
    //-------------------------------------------
    
    func onNetworkResponse(response: HttpResponseItem,completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool)->()){
        
    }
    
    func onNetworkSuccess(response: HttpResponseItem,completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool)->()){
        var data = response.response
        if(data == nil){
            /// Just because API key is valid, Saving it in Keychain and will be used from keychain when token gets expired
            
            ///-------------------------
            return// EMPTY DATA ERROR THROW !
        }
        if(((response.response?["access_token"] as? String)?.isEmpty) == nil){
            completion(OTPCodes.SDK_NOT_INITIALIZED, "SDK Initialization failed", false)
        }
        
        
        // Saving Token and expiry time in Secure Storage
        AuthUtils().save0AuthToken(response: (response.response?[Appstatemanager.shared.CurrentPreferences.ACCESS_TOKEN] ?? "") as! String, expiresIn: (response.response?[Appstatemanager.shared.CurrentPreferences.EXPIRES_IN] ?? -1) as! Int)
        
        // Saving Token Scope in local Storage
        UserDefaults().saveString(Appstatemanager.shared.CurrentPreferences.SCOPE, value: response.response?[Appstatemanager.shared.CurrentPreferences.SCOPE] as! String)
        
        completion(OTPCodes.SDK_INITIALIZED, "SDK Initialized", true)
        
    }
    
    func onNetworkError(response: HttpResponseItem,completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool)->()){
        if(response.responseCode == 100){
            completion(OTPCodes.NETWORK_ERROR, "Network Reachability Error", false)
            return
        }
        else if(response.responseCode == 401){
            completion(OTPCodes.INVALID_SDK_API_KEY, "Invalid API Key", false)
            return
        }
        else if(response.responseCode == 403){
            completion(OTPCodes.NETWORK_ERROR, "Request Forbidden", false)
            return
        }
        else if(response.responseCode == 400){
            completion(OTPCodes.SDK_NOT_INITIALIZED, "Parameters Error", false)
            return
        }
        else if(response.responseCode > 100 && response.responseCode < 200){
            completion(OTPCodes.NETWORK_ERROR, "Request Timed out", false)
            return
        }
        else {
            completion(OTPCodes.NETWORK_ERROR, "Request Failed", false)
            return
        }
    }
    
    func onNetworkCanceled(response: HttpResponseItem,completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool)->()) {
        completion(OTPCodes.NETWORK_ERROR, "Request Failed", false)
    }
    
    //--------------------------------------------
    
    
}
