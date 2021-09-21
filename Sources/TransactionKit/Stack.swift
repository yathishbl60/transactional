//
//  Stack.swift
//  ArgumentParser
//
//  Created by Yathi on 22/9/21.
//

struct Stack<Element> {

    private var elements: [Element] = []

    mutating func push(element: Element) {
        elements.append(element)
    }

    @discardableResult mutating func pop() -> Element? {
        elements.popLast()
    }

    func peek() -> Element? {
        elements.last
    }

    var isEmpty: Bool {
        elements.isEmpty
    }

}
