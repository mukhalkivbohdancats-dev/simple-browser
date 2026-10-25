import sys
from PyQt5.QtCore import QUrl
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtWidgets import QApplication, QLineEdit, QMainWindow, QVBoxLayout, QWidget


class MiniBrowser(QMainWindow):

  def __init__(self):
    super().__init__()
    self.setWindowTitle("Simple Winlator Browser")
    self.resize(1024, 768)

    # Головний віджет та компонування
    central_widget = QWidget()
    self.setCentralWidget(central_widget)
    layout = QVBoxLayout(central_widget)
    layout.setContentsMargins(0, 0, 0, 0)

    # Рядок адреси / пошуку
    self.url_bar = QLineEdit()
    self.url_bar.setPlaceholderText(
        "Введіть URL або пошуковий запит і натисніть Enter..."
    )
    self.url_bar.returnPressed.connect(self.navigate_to_url)
    layout.addWidget(self.url_bar)

    # Вікно веб-переглядача (Chromium)
    self.browser = QWebEngineView()
    self.browser.setUrl(QUrl("https://www.google.com"))
    self.browser.urlChanged.connect(self.update_url_bar)
    layout.addWidget(self.browser)

  def navigate_to_url(self):
    text = self.url_bar.text().strip()
    # Якщо це схоже на пошуковий запит, а не на посилання
    if "." not in text and " " in text:
      url = f"https://www.google.com/search?q={text.replace(' ', '+')}"
    elif "." not in text and not text.startswith("http"):
      url = f"https://www.google.com/search?q={text}"
    elif not text.startswith("http://") and not text.startswith("https://"):
      url = "http://" + text
    else:
      url = text
    self.browser.setUrl(QUrl(url))

  def update_url_bar(self, q):
    self.url_bar.setText(q.toString())


app = QApplication(sys.argv)
window = MiniBrowser()
window.show()
sys.exit(app.exec_())
