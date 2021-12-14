//
//  HTTPResponse.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
class HttpResponseItem{
    //MARK: Variables
    var response: [String: Any]? = nil
    var responseCode: Int = 0
    var httpRequestUrl: String? = nil
    var otpLevel = ""
    var httpRequestMethod = "POST"
    var defaultresponse = String()
    //MARK: Functions
}
