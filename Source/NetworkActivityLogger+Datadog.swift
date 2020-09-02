//
//  NetworkActivityLogger+Datadog.swift
//  AlamofireNetworkActivityLogger
//
//  Created by Reva Yoga Pradana on 31/08/20.
//  Copyright © 2020 RKT Studio. All rights reserved.
//

import Foundation
import Datadog

extension NetworkActivityLogger {
    func initializeDatadog(
        _ clientToken: String,
        _ environment: String,
        _ serviceName: String) {
        
        if #available(iOS 11.0, *) {
            Datadog.initialize(
                appContext: .init(),
                configuration: Datadog.Configuration
                    .builderUsing(clientToken: clientToken, environment: environment)
                    .build()
            )
            
            #if DEBUG
            Datadog.verbosityLevel = .debug
            #endif
        }
    }
    
    func sendDatadogLogger(log: String) {
        guard #available(iOS 11.0, *) else { return }
        
        let logger = initializeDatadogLogger()
        logger.info(log, attributes: additionalAttributesForLogger)
    }
}

private extension NetworkActivityLogger {
    func initializeDatadogLogger() -> Logger {
        let logger = Logger.builder
            .sendNetworkInfo(true)
            .set(serviceName: serviceName)
            .set(loggerName: loggerName)
            .build()
        
        for (key, value) in additionalTagForLogger {
            logger.addTag(withKey: key, value: value)
        }
        
        return logger
    }
}
