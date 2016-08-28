//
//  Beeper.swift
//  TestingDemo
//
//  Created by Kassem Wridan on 28/08/2016.
//  Copyright © 2016 matrixprojects.net. All rights reserved.
//

import Foundation

typealias BeepHandler = () -> Void

/// A basic beeper to trigger events ("beeps") between targets
protocol Beeper {
    
    /// Trigger a beep for the specified identifier
    func beep(identifier: String)
    
    /// Registers a beep handler for a specific identifier.
    /// Upon receiving a "beep" with the matching identifier
    /// the handler is performed
    func registerBeepHandler(identifier: String, handler: BeepHandler)
    
    /// Unregister a beep handler for a specific identifier.
    /// Further "beeps" for this identifier will not
    /// cause the previously registered handler to be called
    func unregisterBeepHandler(identifier: String)
}

// MARK: -

/// A Darwin Notification Center based Beeper implementation
class DarwinNotificationCenterBeeper: Beeper {
    
    let darwinNotificationCenter: CFNotificationCenter
    let prefix: String
    var handlers = [String: BeepHandler]()
    init(prefix: String = "net.mxpr.utils.beeper.") {
        darwinNotificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        self.prefix = prefix
    }
    
    deinit {
        let mySelf = unsafeAddressOf(self)
        CFNotificationCenterRemoveObserver(darwinNotificationCenter,
                                           mySelf,
                                           nil,
                                           nil)
    }
    
    /// wrap identifier with a prefix to ensure no clashes with 
    /// any other applications that may be using this API
    func notificationName(identifier: String) -> String {
        return "\(prefix)\(identifier)"
    }
    
    func identifierFromName(name: String) -> String {
        if let idx = name.rangeOfString(prefix)?.endIndex {
            return name.substringFromIndex(idx)
        }
        return name
    }
    
    var unsafeSelf: UnsafePointer<Void> {
        return unsafeAddressOf(self)
    }
    
    func handleNotification(name: String) {
        let identifier = identifierFromName(name)
        if let handler = handlers[identifier] {
            handler()
        }
    }
    
    // MARK: - Beeper
    func beep(identifier: String) {
        let name = notificationName(identifier)
        CFNotificationCenterPostNotification(darwinNotificationCenter,
                                             name,
                                             nil,
                                             nil,
                                             true)
    }
    
    func registerBeepHandler(identifier: String, handler: BeepHandler) {
        handlers[identifier] = handler
        let name = notificationName(identifier)
        CFNotificationCenterAddObserver(darwinNotificationCenter,
                                        unsafeSelf,
                                        { (_, observer, name, _, _) in
                                            let myself = Unmanaged<DarwinNotificationCenterBeeper>.fromOpaque(COpaquePointer(observer)).takeUnretainedValue()
                                            myself.handleNotification(name as String)
            },
                                        name,
                                        nil,
                                        .DeliverImmediately)
    }
    
    func unregisterBeepHandler(identifier: String) {
        handlers[identifier] = nil
        CFNotificationCenterRemoveObserver(darwinNotificationCenter,
                                           unsafeSelf,
                                           notificationName(identifier),
                                           nil)
    }
}
