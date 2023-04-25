import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!

        // MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

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

            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
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

            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: "Попробовать ещё раз",
                style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)
        }
    }




