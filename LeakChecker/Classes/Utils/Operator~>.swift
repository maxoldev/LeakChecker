//
//  Assets.swift
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

infix operator ~>
@discardableResult public func ~> <U> (value: U, closure: ((inout U) -> Void)) -> U {
    var returnValue = value
    closure(&returnValue)
    return returnValue
}

infix operator ~>?
@discardableResult public func ~>? <U> (value: U?, closure: ((inout U) -> Void)) -> U? {
    guard var returnValue = value else { return value }
    closure(&returnValue)
    return returnValue
}
