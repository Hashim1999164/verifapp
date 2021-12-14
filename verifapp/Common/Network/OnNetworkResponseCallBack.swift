//
//  OnNetworkResponseCallBack.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire
import SwiftyJSON

protocol OnNetworkResponseCallBack{
    ///---------------------------
    var isnetworkConnected: Bool { get }
    ///---------------------------
    func onNetworkResponse(response: HttpResponseItem, completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool) ->())
    func onNetworkSuccess(response: HttpResponseItem, completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool) ->())
    func onNetworkError(response: HttpResponseItem, completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool) ->())
    func onNetworkCanceled(response: HttpResponseItem, completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool) ->())
    
}
