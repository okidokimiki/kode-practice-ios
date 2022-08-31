import Foundation

struct UsersService {
    
    let dataTask = BaseNetworkTask<EmptyModel, UserModel>(
        method: .get,
        path: "kode-education/trainee-test/25143926/users"
    )
    
    func loadUsers(_ onResponseWasReceived: @escaping (_ result: Result<UserModel, Error>) -> Void) {
        dataTask.performRequest(onResponseWasReceived)
    }
}
