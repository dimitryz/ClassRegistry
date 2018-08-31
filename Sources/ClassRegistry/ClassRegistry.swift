import Foundation

/// A registry holds either a class or a generator of a class.
public class ClassRegistry {
  
  public init() {
    registers = [:]
  }
  
  public func register<T>(_ type: T.Type, instance: T) {
    set(register: .instance(instance), forType: type)
  }
  
  public func register<T>(_ type: T.Type, callback: @escaping () -> T) {
    register(type) { _ in return callback() }
  }
  
  public func register<T>(_ type: T.Type, callback: @escaping (ClassRegistry) -> T) {
    set(register: .callback(callback), forType: type)
  }
  
  public func resolve<T>(_ type: T.Type) -> T? {
    guard let register = registers[keyFor(type)] else {
      return nil
    }
    
    switch register {
    case .instance(let instance):
      return instance as? T
    case .callback(let callback):
      return callback(self) as? T
    }
  }
  
  // MARK: Private
  
  private let lock = DispatchSemaphore(value: 1)
  private var registers: [Int: ClassRegister]
  
  private func keyFor<T>(_ type: T.Type) -> Int {
    return ObjectIdentifier(type).hashValue
  }
  
  private func set<T>(register: ClassRegister, forType type: T.Type) {
    lock.wait()
    defer { lock.signal() }
    registers[keyFor(type)] = register
  }
}

private enum ClassRegister {
  case instance(Any)
  case callback((ClassRegistry) -> Any)
}
