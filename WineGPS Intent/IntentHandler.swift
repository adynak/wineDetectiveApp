//
//  IntentHandler.swift
//  WineGPS Intent
//
//  Created by adynak on 9/24/20.
//  Copyright © 2020 Al Dynak. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: SelectVarietalIntentHandling {
    func provideVarietalOptionsCollection(
        for intent: SelectVarietalIntent,
        with completion: @escaping (INObjectCollection<WineGPSINO>?, Error?) -> Void) {
            var varietalItems = [WineGPSINO]()
            VarietalProvider.all().forEach { varietalDetails in
                let varietalIntentObject =
                    WineGPSINO(identifier: varietalDetails.id, display: varietalDetails.name)
                varietalItems.append(varietalIntentObject)
            }
        completion(INObjectCollection(items: varietalItems), nil)
    }
}
