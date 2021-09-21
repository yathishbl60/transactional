import ArgumentParser
import Foundation
import TransactionKit

//PRAGMA MARK:- Global state
private var transaction = TransactionBuilder().build()
private var shouldExit = false

//PRAGMA MARK:- Start command line
Main.run()

struct Main {

    static func run() {
        print("Enter commands:")
        print(">", terminator: " ")

        while !shouldExit, let input = readLine() {
            do {
                var cmd = try Command.parseAsRoot(input.components(separatedBy: .whitespaces))
                try cmd.run()
            } catch {
                print("USAGE: \(Command.helpMessage())")
            }
            print(">", terminator: " ")
        }
    }

}

//PRAGMA MARK:- Parent command
struct Command: ParsableCommand {

    static let configuration = CommandConfiguration(
        subcommands: [Set.self, Get.self, Delete.self, Count.self, Begin.self, Commit.self, Rollback.self, Exit.self]
    )

}

//PRAGMA MARK:- SET command
extension Command {

    struct Set: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "SET",
            abstract: "SET <key> <value> => store the value for key"
        )

        @Argument
        var key: String

        @Argument
        var value: String

        func run() throws {
            transaction.set(key: key, value: value)
        }
    }
}

//PRAGMA MARK:- GET command
extension Command {

    struct Get: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "GET",
            abstract: "GET <key> => return the current value for key"
        )

        @Argument
        var key: String

        func run() throws {
            print("\(transaction.get(key: key) ?? "key not set")")
        }
    }
}

//PRAGMA MARK:- DELETE command
extension Command {

    struct Delete: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "DELETE",
            abstract: "DELETE <key> => remove the entry for key"
        )

        @Argument
        var key: String

        func run() throws {
            transaction.delete(key: key)
            print("Success")
        }
    }
}

//PRAGMA MARK:- COUNT command
extension Command {

    struct Count: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "COUNT",
            abstract: "COUNT <value> => return the number of keys that have the given value"
        )

        @Argument
        var value: String

        func run() throws {
            let count = transaction.count(value: value)
            print("\(count)")
        }
    }
}

//PRAGMA MARK:- BEGIN command
extension Command {

    struct Begin: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "BEGIN",
            abstract: "start a new transaction"
        )

        func run() throws {
            transaction.begin()
        }
    }
}

//PRAGMA MARK:- COMMIT command
extension Command {

    struct Commit: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "COMMIT",
            abstract: "complete the current transaction"
        )


        func run() throws {
            let result = transaction.commit()
            print(result ? "SUCCESS" : "no transaction")
        }
    }
}

//PRAGMA MARK:- ROLLBACK command
extension Command {

    struct Rollback: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "ROLLBACK",
            abstract: "revert to state prior to BEGIN call"
        )

        func run() throws {
            let result = transaction.rollback()
            print(result ? "SUCCESS" : "no transaction")
        }
    }
}

//PRAGMA MARK:- EXIT command
extension Command {

    struct Exit: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "EXIT",
            abstract: "Exit session"
        )

        func run() throws {
            shouldExit = true
        }
    }
}
