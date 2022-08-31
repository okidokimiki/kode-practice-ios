import UIKit

extension UIImageView {
    
    func loadImage(from url: URL) {
        image = R.Images.stopper
        
        ImageLoader().loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async { self?.image = image }
            case .failure(_):
                self?.image = R.Images.stopper
            }
        }
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            image = R.Images.stopper
            return
        }
        
        loadImage(from: url)
    }
}
