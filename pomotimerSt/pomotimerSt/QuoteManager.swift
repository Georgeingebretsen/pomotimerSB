//
//  QuoteManager.swift
//  pomotimerSt
//
//  Created by George Ingebretsen on 4/19/21.
//

import Foundation

class QuoteManager{
    var amountQuotes = 0
    var quoteDictionary = Dictionary<Int, String>()
    
    func makeNewQuote(newQuote: String){
        amountQuotes += 1
        quoteDictionary[amountQuotes] = newQuote
    }
    
    func removeQuote(cellIdentifier: Int){
        //change all of the other cells orderNum tag to represent their new position
        for (cellNum, _) in quoteDictionary {
            if(cellNum > cellIdentifier){
                quoteDictionary[cellNum] = nil
            }
        }
        //remove the cell from the dictionary
        quoteDictionary[cellIdentifier] = nil
    }
    
    func getRandomQuote() -> String{
        let number = Int.random(in: 1...amountQuotes)
        return quoteDictionary[number]!
    }
    
    // Recommended pattern for creating a singleton
    // https://developer.apple.com/documentation/swift/cocoa_design_patterns/managing_a_shared_resource_using_a_singleton
    static let sharedInstance = QuoteManager()
}
