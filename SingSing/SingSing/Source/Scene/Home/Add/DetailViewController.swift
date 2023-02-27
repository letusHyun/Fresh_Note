//
//  DetailViewController.swift
//  SingSing
//
//  Created by SeokHyun on 2023/02/15.
//

import CoreData
import Photos
import UIKit

import SnapKit
// TODO: - DetailViewController로 이름 변경후, cell 클릭 시 update 구현하기
// TODO: - editing으로 들어온 경우, 가져온 foodModel을 이용해 화면에 뿌려주기
// TODO: - editing으로 완료할 경우, 해당 cell의 data change해줘서 화면에 뿌려주기
class DetailViewController: BaseViewController {
  
  // MARK: - Properties
  var detailState: DetailStateType!
  var foodModel: FoodModel?
  var popCompletion: (() -> Void)?
  private let textViewPlaceholder = "메모를 입력하세요."
  
  private lazy var saveButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .systemFont(ofSize: 19, weight: .medium)
    button.titleLabel?.textAlignment = .center
    button.setTitle("완료", for: .normal)
    button.setTitleColor(SSType.lv3.color, for: .highlighted)
    button.setTitleColor(UIColor.systemGray.withAlphaComponent(0.5), for: .normal)
    button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var rightItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(customView: saveButton)
    buttonItem.isEnabled = false
    return buttonItem
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton(
      UIImage(
        systemName: "chevron.backward", weight: .light)?
        .resizeImageTo(size: CGSize(width: 25, height: 25))?
        .withRenderingMode(.alwaysTemplate),
      hexImageColor: SSType.lv2.rawValue
    )
    button.imageView?.contentMode = .left
    button.setTitle("뒤로", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 19, weight: .medium)
    button.setTitleColor(SSType.lv3.color, for: .highlighted)
    button.setTitleColor(SSType.lv2.color, for: .normal)
    button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var leftItem: UIBarButtonItem = {
    let buttonItem = UIBarButtonItem(customView: self.cancelButton)
    return buttonItem
  }()

  private lazy var toolBar: UIToolbar = {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    
    let space = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(toolBarButtonDidTap)
    )
    toolBar.setItems([space, doneButton], animated: true)
    return toolBar
  }()
  
  private let expirationDatePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.setupStyles()
    return dp
  }()
  
  private let consumptionDatePicker: UIDatePicker = {
    let dp = UIDatePicker()
    dp.setupStyles()
    return dp
  }()
  
  private let cameraImage: UIImage = {
    guard let image = UIImage(systemName: "camera")?
      .withTintColor(.systemGray, renderingMode: .alwaysOriginal) else { return UIImage() }
    return image
  }()
  
  private lazy var thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = self.cameraImage
    iv.contentMode = .scaleToFill
    iv.tintColor = SSType.lv2.color
    iv.layer.borderColor = SSType.lv1.color.cgColor
    iv.layer.borderWidth = 2
    iv.layer.cornerRadius = 10
    iv.layer.masksToBounds = true
    
    let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageDidTap))
    iv.isUserInteractionEnabled = true
    iv.addGestureRecognizer(imageGesture)
    
    let config = UIImage.SymbolConfiguration(weight: .light)
    iv.preferredSymbolConfiguration = config
    return iv
  }()

  private lazy var nameTextField: UnderlineTextField = {
    let tf = UnderlineTextField(placeholder: "상품명")
    tf.addTarget(self, action: #selector(textFieldEditing), for: .allEditingEvents)
    return tf
  }()
  
  private lazy var expirationDateTextField: UnderlineTextField = {
    let tf = UnderlineTextField(placeholder: "유통기한")
    tf.addTarget(self, action: #selector(textFieldEditing), for: .allEditingEvents)
    return tf
  }()
  
  private let consumptionDateTextField: UnderlineTextField = {
    let tf = UnderlineTextField(placeholder: "소비기한")
    return tf
  }()
  
  private let categoryTextField: UnderlineTextField = {
    let tf = UnderlineTextField(placeholder: "카테고리")
    return tf
  }()
  
  private lazy var descriptionTextView: UITextView = {
    let tv = UITextView()
    tv.layer.borderWidth = 1
    tv.layer.borderColor = SSType.lv1.color.cgColor
    tv.font = .systemFont(ofSize: 14)
//    tv.text = textViewPlaceholder
//    tv.textColor = SSType.placeholder.color
    tv.backgroundColor = .clear
    tv.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    tv.indicatorStyle = .black
    tv.showsHorizontalScrollIndicator = false
    tv.delegate = self
    return tv
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .clear
    scrollView.indicatorStyle = .black
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var viewTapGesture: UITapGestureRecognizer = {
    let tg = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
    return tg
  }()
  
  // MARK: - LifeCycle
  
  init(detailState: DetailStateType) {
    self.detailState = detailState
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addNotiObserver()
    initialSetting()

  }
  
  private func initialSetting() {
    switch detailState {
    case .addition:
      configureAddition()
    case .editing:
      configureEditing()
    default: break
    }
  }
  
  // MARK: - Setup
  
  override func setupLayouts() {
    self.view.addSubview(self.scrollView)
    self.scrollView.addSubview(self.containerView)
    self.containerView.addSubview(self.thumbnailImageView)
    self.containerView.addSubview(self.nameTextField)
    self.containerView.addSubview(self.expirationDateTextField)
    self.containerView.addSubview(self.consumptionDateTextField)
    self.containerView.addSubview(self.categoryTextField)
    self.containerView.addSubview(self.descriptionTextView)
    self.view.addGestureRecognizer(self.viewTapGesture)
  }
  
  override func setupConstraints() {
    self.scrollView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.containerView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview()
      
      $0.height.equalTo(self.scrollView)
//      $0.height.equalTo(scrollView).priority(.high)
      $0.width.equalTo(self.scrollView)
    }
    
    self.thumbnailImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.containerView).offset(30)
      $0.size.equalTo(100)
    }
    
    self.nameTextField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.top.equalTo(self.thumbnailImageView.snp.bottom).offset(30)
    }
    
    self.expirationDateTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.nameTextField)
//      $0.width.equalTo(100)
      $0.top.equalTo(self.nameTextField.snp.bottom).offset(30)
    }
    
    self.consumptionDateTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.nameTextField)
//      $0.width.equalTo(150)
      $0.top.equalTo(self.expirationDateTextField.snp.bottom).offset(30)
    }
    
    self.categoryTextField.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.nameTextField)
      $0.top.equalTo(self.consumptionDateTextField.snp.bottom).offset(30)
    }
    
    self.descriptionTextView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self.nameTextField)
      $0.top.equalTo(self.categoryTextField.snp.bottom).offset(30)
      $0.height.equalTo(300)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    self.leftItem = UIBarButtonItem(customView: self.cancelButton)
    navigationItem.leftBarButtonItem = self.leftItem
    navigationItem.rightBarButtonItem = self.rightItem
    createDatePicker()
  }
  
  // MARK: - Helpers
  
  private func configureEditing() {
    saveButton.isEnabled = true
    saveButton.setTitleColor(SSType.lv2.color, for: .normal)
    
    self.nameTextField.text = self.foodModel?.name
    self.expirationDateTextField.text = self.foodModel?.expirationDate
    self.consumptionDateTextField.text = self.foodModel?.consumptionDate
    self.categoryTextField.text = self.foodModel?.category
    
    if self.foodModel?.extraDescription == "" {
      self.descriptionTextView.text = self.textViewPlaceholder
      self.descriptionTextView.textColor = .placeholderText
    } else {
      self.descriptionTextView.text = self.foodModel?.extraDescription
      self.descriptionTextView.textColor = .black
    }
    
    let image: UIImage?
    
    if let data = self.foodModel?.thumbnail {
      image = UIImage(data: data)!
    } else {
      image = UIImage(systemName: "fork.knife.circle", weight: .medium)
    }
    self.thumbnailImageView.image = image
  }
  
  private func configureAddition() {
    descriptionTextView.text = textViewPlaceholder
    descriptionTextView.textColor = SSType.placeholder.color
  }
  
  private func addNotiObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  private func createDatePicker() {
    self.expirationDatePicker.preferredDatePickerStyle = .wheels
    self.expirationDatePicker.datePickerMode = .date
    self.expirationDateTextField.inputView = self.expirationDatePicker
    self.expirationDateTextField.inputAccessoryView = self.toolBar
    
    self.consumptionDatePicker.preferredDatePickerStyle = .wheels
    self.consumptionDatePicker.datePickerMode = .date
    self.consumptionDateTextField.inputView = self.consumptionDatePicker
    self.consumptionDateTextField.inputAccessoryView = self.toolBar
  }

  // MARK: - Actions
  
  @objc private func saveButtonDidTap() {
    switch detailState {
    case .editing:
      self.foodModel?.name = self.nameTextField.text!
      self.foodModel?.expirationDate = self.expirationDateTextField.text!
      self.foodModel?.consumptionDate = self.consumptionDateTextField.text
      self.foodModel?.category = self.categoryTextField
        .text! == "" ? "미분류" : categoryTextField.text!
      
      if self.descriptionTextView.text == self.textViewPlaceholder {
        self.foodModel?.extraDescription = ""
      } else {
        self.foodModel?.extraDescription = self.descriptionTextView.text
      }
      
      if thumbnailImageView.image!.isSymbolImage {
        self.foodModel?.thumbnail = nil
      } else {
        let data = thumbnailImageView.image?.jpegData(compressionQuality: 1)
        self.foodModel?.thumbnail = data
      }
      
      if let foodResult = self.foodModel {
        PersistenceManager.shared.editFood(foodModel: foodResult) //CoreData 저장
      }
      
    case .addition:
      self.foodModel = FoodModel(
        uuid: UUID(),
        name: self.nameTextField.text!,
        expirationDate: self.expirationDateTextField.text!,
        consumptionDate: self.consumptionDateTextField.text,
        extraDescription:
          descriptionTextView.text == textViewPlaceholder ? "" : descriptionTextView.text,
        category: categoryTextField.text! == "" ? "미분류" : categoryTextField.text!
      )
      
      if thumbnailImageView.image != cameraImage {
        let data = thumbnailImageView.image?.jpegData(compressionQuality: 1)
        self.foodModel?.thumbnail = data
      } else {
        self.foodModel?.thumbnail = nil
      }
      
      if let foodResult = self.foodModel {
        PersistenceManager.shared.insertFood(foodModel: foodResult) //CoreData 저장
      }
    default: break
    }

    self.popCompletion?()
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func textFieldEditing() {
    if self.nameTextField.text != "",
       self.expirationDateTextField.text != "" {
      self.saveButton.setTitleColor(SSType.lv2.color, for: .normal)
      self.rightItem.isEnabled = true
    } else {
      self.saveButton.setTitleColor(UIColor.systemGray.withAlphaComponent(0.5), for: .normal)
      self.rightItem.isEnabled = false
    }
  }
  
  @objc private func viewDidTap() {
    self.view.endEditing(true)
  }
  
  @objc private func backButtonDidTap() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func toolBarButtonDidTap() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    
    if self.expirationDateTextField.isEditing {
      self.expirationDateTextField.text = formatter
        .string(from: self.expirationDatePicker.date)
    } else if self.consumptionDateTextField.isEditing {
      self.consumptionDateTextField.text = formatter
        .string(from: self.consumptionDatePicker.date)
    }

    self.view.endEditing(true)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[
            UIResponder.keyboardFrameEndUserInfoKey
          ] as? CGRect else {
      return
    }
    
    self.scrollView.contentInset.bottom = keyboardFrame.size.height
    
    let firstResponder = UIResponder.current
    if let textView = firstResponder as? UITextView {
      self.scrollView.scrollRectToVisible(textView.frame, animated: true)
    }
  }
  
  @objc private func keyboardWillHide() {
    let contentInset = UIEdgeInsets.zero
    self.scrollView.contentInset = contentInset
    self.scrollView.scrollIndicatorInsets = contentInset
  }
  
  @objc private func imageDidTap() {
    
    switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
    case .notDetermined:
      print("DEBUG: 사용자가 앱의 권한을 아무것도 설정하지 않은 경우입니다.")
    case .restricted:
      print("DEBUG: 라이브러리 권한에 제한이 생긴 경우입니다. 사진을 얻어올 수 없습니다.")
    case .denied:
      print("DEBUG: 사용자가 접근을 거부한 것입니다. 사진을 얻어올 수 없습니다.")
    case .authorized:
      print("DEBUG: 사용자가 앱에게 라이브러리를 사용할 수 있도록 권한을 설정한 경우입니다.")
    case .limited:
      print("DEBUG: 사용자가 제한된 접근 권한을 부여한 경우입니다. (iOS 14+)")
    @unknown default:
      print("DEBUG: unKnown")
    }
    
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.allowsEditing = true
    picker.delegate = self
    
    self.present(picker, animated: true)
  }
}

// MARK: - UITextViewDelegate

extension DetailViewController: UITextViewDelegate {
  // TODO: - placeholder를 클릭시 사라지는것이 아닌, 타이핑 시 사라지게 하기
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == self.textViewPlaceholder {
      textView.text = nil
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      self.descriptionTextView.text = self.textViewPlaceholder
      self.descriptionTextView.textColor = SSType.placeholder.color
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension DetailViewController: UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    self.dismiss(animated: true) {
      if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self.thumbnailImageView.image = capturedImage
      }
    }
  }
}

// MARK: - UINavigationControllerDelegate

extension DetailViewController: UINavigationControllerDelegate {

}
