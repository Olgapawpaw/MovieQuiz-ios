import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()
            
            alertPresenter = AlertPresenter(delegate: self)
            presenter = MovieQuizPresenter(viewController: self)

            imageView.layer.cornerRadius = 20
        }

        // MARK: - Actions

        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            presenter.yesButtonClicked()
        }

        @IBAction private func noButtonClicked(_ sender: UIButton) {
            presenter.noButtonClicked()
        }

        // MARK: - Private functions

        func show(quiz step: QuizStepViewModel) {
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }

        func show(quiz result: AlertModel) {
            let message = presenter.makeResultsMessage()

            let alert = AlertModel(
                title: result.title,
                message: message,
                buttonText: result.buttonText)

            alertPresenter?.showAlert(alertFinish: alert)
            self.presenter.restartGame()
        }

        func highlightImageBorder(isCorrectAnswer: Bool) {
            noButton.isEnabled = false
            yesButton.isEnabled = false
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }

        func showLoadingIndicator() {
            activityIndicator.startAnimating()
        }

        func hideLoadingIndicator() {
            activityIndicator.stopAnimating()
        }

        func showNetworkError(message: String) {
            hideLoadingIndicator()
            
            let alert = AlertModel(
                title: "Ошибка",
                message: message,
                buttonText: "Попробовать ещё раз")

            alertPresenter?.showAlert(alertFinish: alert)
            self.presenter.restartGame()
        }
    }




