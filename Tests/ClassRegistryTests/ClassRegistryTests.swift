import XCTest
@testable import ClassRegistry

protocol Pet {}

struct Dog: Pet {}

struct Owner {
  let pet: Pet
  init(pet: Pet) {
    self.pet = pet
  }
}

final class ClassRegistryTests: XCTestCase {
  
  func testBasicInitialization() {
    let classRegistry = ClassRegistry()
    classRegistry.register(Dog.self, instance: Dog())
    XCTAssertNotNil(classRegistry.resolve(Dog.self))
  }
  
  func testCallbackInitialization() {
    let classRegistry = ClassRegistry()
    classRegistry.register(Dog.self) {
      return Dog()
    }
    XCTAssertNotNil(classRegistry.resolve(Dog.self))
  }
  
  func testCallbackWithRegister() {
    let classRegistry = ClassRegistry()
    classRegistry.register(Pet.self, instance: Dog())
    classRegistry.register(Owner.self) { classRegistry in
      return Owner(pet: classRegistry.resolve(Pet.self)!)
    }
    XCTAssertNotNil(classRegistry.resolve(Owner.self)?.pet)
  }
}
