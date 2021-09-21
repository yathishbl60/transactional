//
//  Transaction.swift
//  ArgumentParser
//
//  Created by Yathi on 22/9/21.
//

public protocol TransactionEvents {
    var store: TransactionStoreReadable { get }

    func set(key: Key, value: Value)
    func get(key: Key) -> Value?
    func delete(key: Key)
    func count(value: Value) -> Int
    func begin()
    func commit() -> Bool
    func rollback() -> Bool
}

public struct TransactionBuilder {

    public init() {

    }

    public func build() -> TransactionEvents {
        Transaction(storeBuilder: TransactionStoreBuilder())
    }

}


final class Transaction: TransactionEvents {

    private let storeBuilder: TransactionStoreBuilder
    private var internalStore: TransactionStore
    private var transactions = Stack<Transaction>()

    init(storeBuilder: TransactionStoreBuilder) {
        self.storeBuilder = storeBuilder
        self.internalStore = storeBuilder.build()
    }

    var store: TransactionStoreReadable {
        internalStore
    }

    func set(key: Key, value: Value) {
        if let childTransaction = transactions.peek() {
            childTransaction.set(key: key, value: value)
        } else {
            internalStore.add(key: key, value: value)
        }
    }

    func get(key: Key) -> Value? {
        transactions.peek()?.store.get(key: key) ?? internalStore.get(key: key)
    }

    func delete(key: Key) {
        internalStore.remove(key: key)
    }

    func count(value: Value) -> Int {
        store.count(value: value)
    }

    func begin() {
        let transaction = Transaction(storeBuilder: storeBuilder)
        transactions.push(element: transaction)
    }

    func commit() -> Bool {
        guard let latestTransaction = transactions.pop() else { return false }
        latestTransaction.store.all.forEach { (key, value) in
            internalStore.add(key: key, value: value)
        }
        return true
    }

    func rollback() -> Bool {
        transactions.pop() != nil
    }


}
