//
//  LoginViewController.swift
//  RxSwift-Login
//
//  Created by 정진배 on 2021/01/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()

    let userEmail = "pino-day@test.co.kr"
    let userPassword = "test123"

    // MARK: - Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.text = "RxSwift & MVVM & Login Validation"
    }

    private let emailView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요"
    }

    private let passwordView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }

    private let loginButton = UIButton().then {
        $0.setTitle("Login", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        $0.titleLabel?.textColor = .white
        $0.backgroundColor = #colorLiteral(red: 0.6, green: 0.8078431373, blue: 0.9803921569, alpha: 1)
        $0.layer.cornerRadius = 15
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        setupControl()
    }

    // MARK: - Helpers
    func configureUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150)
            $0.centerX.equalToSuperview()
        }

        view.addSubview(emailView)
        emailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }

        emailView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }

        view.addSubview(passwordView)
        passwordView.snp.makeConstraints {
            $0.top.equalTo(emailView.snp.bottom).offset(10)
            $0.leading.equalTo(emailView.snp.leading)
            $0.trailing.equalTo(emailView.snp.trailing)
            $0.height.equalTo(50)
        }

        passwordView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }

        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(emailView)
        }
    }

    func setupControl() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)

        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)

        loginButton.rx.tap.subscribe(
            onNext: { [weak self] _ in
                if self?.userEmail == self?.viewModel.emailObserver.value &&
                    self?.userPassword == self?.viewModel.passwordObserver.value {
                    let alert = UIAlertController(title: "로그인 성공", message: "환영합니다", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "로그인 실패", message: "아이디 혹은 비밀번호를 다시 확인해주세요", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        ).disposed(by: disposeBag)
    }

}
