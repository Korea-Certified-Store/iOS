//
//  NewStoreTextField.swift
//  KCS
//
//  Created by 조성민 on 2/17/24.
//

import RxGesture
import RxSwift

final class NewStoreTextField: UITextField {
    
    private let disposeBag = DisposeBag()
    
    private lazy var clearButtonView: UIView = {
        let imageView = UIImageView()
        imageView.image = .xMarkIcon
        imageView.tintColor = .kcsGray1
        
        imageView.rx.tapGesture(configuration: { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }).when(.ended)
            .bind { [weak self] _ in
                self?.text = ""
            }
            .disposed(by: disposeBag)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.addSubview(imageView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelectedUI() {
        backgroundColor = .newStoreRequestTextFieldEdit
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.uiTextFieldBoldBorder.cgColor
    }
    
    func setWarningUI() {
        backgroundColor = .newStoreRequestTextFieldNormal
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.uiTextFieldWarning.cgColor
    }
    
    func setNormalUI() {
        backgroundColor = .newStoreRequestTextFieldNormal
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.uiTextFieldNormalBorder.cgColor
    }
    
}

private extension NewStoreTextField {
    
    func setup() {
        clearButtonMode = .whileEditing
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        rightViewMode = .whileEditing
        rightView = clearButtonView
        setLayerCorner(cornerRadius: 10)
        setNormalUI()
    }
    
}
