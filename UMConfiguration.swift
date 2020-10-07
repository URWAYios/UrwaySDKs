//
//  UMConfiguration.swift
//  Pods-UrwayDemoApp
//
//  Created by aravind-zt336 on 01/06/20.
//

import Foundation
public class UWConfiguration: NSObject {
    var password:String
    var merchantKey: String
    var terminalID: String
    
    @discardableResult public init(password:String , merchantKey: String , terminalID: String) {
        self.password = password
        self.merchantKey = merchantKey
        self.terminalID = terminalID
        
        Common.Globle.terminalId = self.terminalID
        Common.Globle.password = self.password
        Common.Globle.merchantKey = self.merchantKey
    }
}
