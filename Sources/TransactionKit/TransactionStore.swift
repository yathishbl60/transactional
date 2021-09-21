//
//  TransactionStore.swift
//  ArgumentParser
//
//  Created by Yathi on 22/9/21.
//

public typealias TransactionStore = TransactionStoreReadable & TransactionStoreWritable

public typealias Key = String
public typealias Value = String

public protocol TransactionStoreReadable {
    var all: [Key: Value] { get }
    var count: Int { get }

    func get(key: Key) -> Value?
    func count(value: Value) -> Int
}

public protocol TransactionStoreWritable {
    mutating func add(key: Key, value: Value)
    mutating func remove(key: Key)
}

struct TransactionLocalStore: TransactionStore {
    private var store: [Key: Value] = [:]

    var all: [Key : Value] {
        store
    }

    var count: Int {
        store.count
    }

    func get(key: Key) -> Value? {
        store[key]
    }

    func count(value: Value) -> Int {
        store.filter { $0.value == value }.count
    }

    mutating func add(key: Key, value: Value) {
        store[key] = value
    }

    mutating func remove(key: Key) {
        store[key] = nil
    }

}

public struct TransactionStoreBuilder {

    public init() {

    }

    public func build() -> TransactionStore {
        TransactionLocalStore()
    }
}
