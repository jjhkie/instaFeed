

import SnapKit
import UIKit

class FeedViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        
        return tableView
    }()
    
    private lazy var imagePickerViewController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true // 사진 선택 후 편집 기능 추가
        imagePickerController.delegate = self
        
        return imagePickerController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
    }
}

extension FeedViewController: UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell
        cell?.selectionStyle = .none
        cell?.setup()
        
        return cell ?? UITableViewCell()
    }
}

extension FeedViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //사진을 클릭 후 편집화면에서 choose를 눌렀을 때 실행되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectImage = editedImage
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectImage = originImage
        }
        
        print(selectImage)
        picker.dismiss(animated: true){
            let uploadViewController = UploadViewController()
            let navigationController = UINavigationController(rootViewController: uploadViewController)
            
            navigationController.modalPresentationStyle = .fullScreen
            
            self.present(navigationController, animated: true)
        }
    }
}

private extension FeedViewController{
    func setupNavigationBar(){
        navigationItem.title = "Instagram"
        
        let uploaButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(didTapUploadButton))
        navigationItem.rightBarButtonItem = uploaButton
    }
    
    @objc func didTapUploadButton(){
        present(imagePickerViewController, animated: true)
    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
