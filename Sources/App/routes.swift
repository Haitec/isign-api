import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    struct Status: Content {
        let id: Int
        let isOk: Bool
    }
    
    struct StatusRequest: Content {
        let id: Int
        let isOk: Bool
    }
    
    var isOk = true
    
    router.get("status", Int.parameter) { req -> Status in
        let id = try req.parameters.next(Int.self)
        return Status(id: id, isOk: isOk)
    }
    
    router.post("status") { req -> Future<HTTPStatus> in
        return try req.content.decode(StatusRequest.self).map(to: HTTPStatus.self) { statusRequest in
            print(statusRequest.id)
            print(statusRequest.isOk)
            isOk = statusRequest.isOk
            return .ok
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
