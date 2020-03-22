//
//  CalculatorModel.swift
//  Calculator
//
//  Created by 汤小军 on 2020/3/22.
//  Copyright © 2020 汤小军. All rights reserved.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
//    let objectWillChange = PassthroughSubject<Void, Never>()
   @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    func apply(_ item: CalculatorButtonItem) {
        print("点击事件")
        brain = brain.apply(item: item)
        history.append(item)
        
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    var historyDetail: String {
        history.map({$0.description}).joined()
    }
    var temporaryKept: [CalculatorButtonItem] = []
    var totalCount: Int {
        history.count + temporaryKept.count
    }
    
    var slidingIndex: Float = 0 {
        didSet {
            //维护history和 temporaryKept
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    func keepHistory(upTo index: Int) {
         precondition(index <= totalCount, "Out of Index.")
        let total = history + temporaryKept
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        brain = history.reduce(CalculatorBrain.left("0"), { (result, item)  in
            result.apply(item: item)
        })
    }
}
