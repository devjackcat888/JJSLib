//
//  ObservableFilterNil.swift
//  SharkAnimation
//
//  Created by SharkAnimation on 2022/12/23.
//

import Foundation
import RxSwift

public extension ObservableType {
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */

    func filterNil<T>() -> Observable<T> where Element == T? {
        return compactMap { $0 }
    }
}

