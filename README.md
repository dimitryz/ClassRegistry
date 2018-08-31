# Swift Class Registry

This package is a very simple way of registering classes for later use anywhere in the application.

A common use for this could be a logger or an error handler. Instead of calling an error handler directly, the user may use the class registry to call an error handler indirectly. This would avoids any tight coupling between the code and the error handler.

Example:

In the example below, the `performMethod()` has a strong reference to the Logger

```swift
class Logger() {
  func log(_ message: String) { }
}

func performMethod() {
  guard let instanceVariable = instanceVariable else {
    Logger.log("Missing variable")
    return
  }
  // performs the rest of the call
}
```

A better solution may have the `performMethod()` use the class registry.

```swift
protocol Logger() {
  func log(_ message: String)
}

class ConsoleLogger: Logger {
  func log(_ message: String) { }
}

ClassRegistry.register(Logger.self, instance: ConsoleLogger())

func performMethod() {
  guard let instanceVariable = instanceVariable else {
    ClassRegistry.resolve(Logger.self)?.log("Missing variable")
    return
  }
  // performs the rest of the call
}
```

What this lengthier solution does above the previous version is it decouples the `ConsoleLogger` from the `performMethod()` function. The user can now replace the console logger with a web logger and all references to `ClassRegistry.resolve(Logger.self)` will automatically use the web logger instead.
