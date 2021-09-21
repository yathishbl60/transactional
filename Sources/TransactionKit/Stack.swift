//
//  Stack.swift
//  ArgumentParser
//
//  Created by Yathi on 22/9/21.
//

public struct Stack<Element> {

    public init() { }

    private var elements: [Element] = []

    public mutating func push(element: Element) {
        elements.append(element)
    }

    @discardableResult public mutating func pop() -> Element? {
        elements.popLast()
    }

    public func peek() -> Element? {
        elements.last
    }

    public var isEmpty: Bool {
        elements.isEmpty
    }

}
