//
//  UMConfigurator.swift
//  Pods-UrwayDemoApp
//
//  Created by aravind-zt336 on 01/06/20.
//

import Foundation
public class UMConfiguration{
    var terminalID: String
    var password: String
    var merchantKey: String
    
    @discardableResult public init(terminalID: String , password: String , merchantKey: String , url: String) {
        self.terminalID = terminalID
        self.password = password
        self.merchantKey = merchantKey
        
        Common.Globle.terminalId = self.terminalID
        Common.Globle.merchantKey = self.merchantKey
        Common.Globle.password = self.password
        Common.Globle.url = url
    }
}
