//
//  BoxObservable.swift
//  TheNameGame
//
//  Created by Iyin Raphael on 3/17/21.
//

import Foundation

final class BoxObservable<T> {
    
    // MARK: - Property
    typealias Listner = (T) -> Void
    var listner: Listner?
    
    var value: T {
        didSet {
            listner?(value)
        }
    }

    init(value: T) {
        self.value = value
    }
    
    // MARK: - Method
    func bind(listner: Listner?) {
        self.listner = listner
        listner?(value)
    }
}
