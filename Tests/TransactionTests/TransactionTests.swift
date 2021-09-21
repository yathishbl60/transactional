import XCTest
import class Foundation.Bundle
@testable import TransactionKit

final class TransactionTests: XCTestCase {

    private var transaction: Transaction!

    override func setUp() {
        super.setUp()
        transaction = Transaction(storeBuilder: TransactionStoreBuilder())
    }

    override func tearDown() {
        transaction = nil
        super.tearDown()
    }

    /*
     > SET foo 123
     > GET foo
     123
     */
    func testGetandSet() {
        transaction.set(key: "foo", value: "123")
        XCTAssertEqual(transaction.get(key: "foo"), "123")
    }

    /*
     > SET foo 123
     > DELETE foo
     > GET foo
     key not set
     */
    func testDelete() {
        transaction.set(key: "foo", value: "123")
        transaction.delete(key: "foo")
        XCTAssertNil(transaction.get(key: "foo"))
    }

    /*
     > SET foo 123
     > SET bar 456
     > SET baz 123
     > COUNT 123
     2
     > COUNT 456
     1
     */
    func testNumberOfOccuranceOfValue() {
        transaction.set(key: "foo", value: "123")
        transaction.set(key: "bar", value: "456")
        transaction.set(key: "baz", value: "123")

        XCTAssertEqual(transaction.count(value: "123"), 2)
        XCTAssertEqual(transaction.count(value: "456"), 1)
    }

    /*
     > BEGIN
     > SET foo 456
     > COMMIT
     > ROLLBACK
     no transaction
     > GET foo
     456
     */
    func testCommit() {
        transaction.begin()
        transaction.set(key: "foo", value: "456")
        XCTAssertTrue(transaction.commit())
        XCTAssertFalse(transaction.rollback())
        XCTAssertEqual(transaction.get(key: "foo"), "456")
    }

    /*
     > SET foo 123
     > SET bar abc
     > BEGIN
     > SET foo 456
     > GET foo
     456
     > SET bar def
     > GET bar
     def
     > ROLLBACK
     > GET foo
     123
     > GET bar
     abc
     > COMMIT
     no transaction
     */
    func testRollbackTransaction() {
        transaction.set(key: "foo", value: "123")
        transaction.set(key: "bar", value: "abc")
        transaction.begin()
        transaction.set(key: "foo", value: "456")
        XCTAssertEqual(transaction.get(key: "foo"), "456")
        transaction.set(key: "bar", value: "def")
        XCTAssertEqual(transaction.get(key: "bar"), "def")
        XCTAssertTrue(transaction.rollback())
        XCTAssertEqual(transaction.get(key: "foo"), "123")
        XCTAssertEqual(transaction.get(key: "bar"), "abc")
        XCTAssertFalse(transaction.commit())
    }

    /*
     > SET foo 123
     > BEGIN
     > SET foo 456
     > BEGIN
     > SET foo 789
     > GET foo
     789
     > ROLLBACK
     > GET foo
     456
     > ROLLBACK
     > GET foo
     123
     */
    func testNestedTransactions() {
        transaction.set(key: "foo", value: "123")
        transaction.begin()
        transaction.set(key: "foo", value: "456")
        transaction.begin()
        transaction.set(key: "foo", value: "789")
        XCTAssertEqual(transaction.get(key: "foo"), "789")
        XCTAssertTrue(transaction.rollback())
        XCTAssertEqual(transaction.get(key: "foo"), "456")
        XCTAssertTrue(transaction.rollback())
        XCTAssertEqual(transaction.get(key: "foo"), "123")

    }

}
