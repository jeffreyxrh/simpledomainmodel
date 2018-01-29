//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    switch currency {
    case "USD":
        switch to {
        case "GBP":
            return Money(amount: amount / 2, currency: to)
        case "EUR":
            return Money(amount: amount * 3 / 2, currency: to)
        case "CAN":
            return Money(amount: amount * 5 / 4, currency: to)
        default:
            print("Unable to convert to \(to)")
        }
    case "GBP":
        return Money(amount: amount * 2, currency: to)
    case "EUR":
        return Money(amount: amount * 2 / 3, currency: to)
    case "CAN":
        return Money(amount: amount * 4 / 5, currency: to)
    default:
        print("Unable to convert to \(to)")
    }
    return self
  }
  
  public func add(_ to: Money) -> Money {
    let resultCurrency = to.currency
    var current = self
    if currency != resultCurrency {
        current = self.convert(resultCurrency)
    }
    return Money(amount: current.amount + to.amount, currency: resultCurrency)
  }
  public func subtract(_ from: Money) -> Money {
    let resultCurrency = from.currency
    var current = self
    if currency != resultCurrency {
        current = self.convert(resultCurrency)
    }
    return Money(amount: current.amount - from.amount, currency: resultCurrency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let income):
        return Int(income * Double(hours))
    case .Salary(let income):
        return income
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let income):
        type = JobType.Hourly(income + amt)
    case .Salary(let income):
        type = JobType.Salary(Int(Double(income) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if age >= 21 {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if age >= 21 {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1._spouse = spouse2
    spouse2._spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for person in members {
        if person._job != nil {
            income += person._job!.calculateIncome(2000)
        }
    }
    return income
  }
}
