import os
import sys
from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QIcon
from PyQt5.QtWebEngineWidgets import QWebEngineProfile, QWebEngineView
from PyQt5.QtWidgets import (
    QAction,
    QApplication,
    QFileDialog,
    QHBoxLayout,
    QLineEdit,
    QMainWindow,
    QProgressBar,
    QToolBar,
    QVBoxLayout,
    QWidget,
)


class ChromeLite(QMainWindow):

  def __init__(self):
    super().__init__()
    self.setWindowTitle("Kishka Browser Lite")
    self.setGeometry(100, 100, 1024, 720)

    # Встановлення іконки вікна
    icon_path = os.path.join(os.path.dirname(__file__), "icon.ico")
    if os.path.exists(icon_path):
      self.setWindowIcon(QIcon(icon_path))

    # Налаштування профілю для завантаження файлів
    profile = QWebEngineProfile.defaultProfile()
    profile.downloadRequested.connect(self.on_download_requested)

    # Головний віджет
    central_widget = QWidget()
    self.setCentralWidget(central_widget)
    main_layout = QVBoxLayout(central_widget)
    main_layout.setContentsMargins(0, 0, 0, 0)
    main_layout.setSpacing(0)

    # Верхня панель навігації (Chrome Style)
    nav_bar = QToolBar()
    nav_bar.setStyleSheet("""
            QToolBar { background: #202124; padding: 4px; border: none; }
            QLineEdit { 
                background: #303134; color: #ffffff; border-radius: 14px; 
                padding: 6px 12px; font-size: 14px; border: 1px solid #5f6368; 
            }
            QLineEdit:focus { border: 1px solid #8ab4f8; }
            QToolButton { color: #e8eaed; background: transparent; padding: 4px; font-weight: bold; }
            QToolButton:hover { background: #3c4043; border-radius: 4px; }
        """)
    self.addToolBar(nav_bar)

    # Кнопки навігації
    self.back_btn = QAction("◄", self)
    self.back_btn.triggered.connect(lambda: self.browser.back())
    nav_bar.addAction(self.back_btn)

    self.forward_btn = QAction("►", self)
    self.forward_btn.triggered.connect(lambda: self.browser.forward())
    nav_bar.addAction(self.forward_btn)

    self.reload_btn = QAction("↻", self)
    self.reload_btn.triggered.connect(lambda: self.browser.reload())
    nav_bar.addAction(self.reload_btn)

    self.home_btn = QAction("⌂", self)
    self.home_btn.triggered.connect(self.navigate_home)
    nav_bar.addAction(self.home_btn)

    # Рядок пошуку / URL
    self.url_bar = QLineEdit()
    self.url_bar.setPlaceholderText("Пошук у Google або URL-адреса...")
    self.url_bar.returnPressed.connect(self.navigate_to_url)
    nav_bar.addWidget(self.url_bar)

    # Прогрес-бар завантаження сторінки
    self.progress_bar = QProgressBar()
    self.progress_bar.setMaximumHeight(3)
    self.progress_bar.setTextVisible(False)
    self.progress_bar.setStyleSheet(
        "QProgressBar::chunk { background-color: #8ab4f8; }"
    )
    main_layout.addWidget(self.progress_bar)

    # Движок браузера (Chromium Lite)
    self.browser = QWebEngineView()
    self.browser.setUrl(QUrl("https://www.google.com"))
    self.browser.urlChanged.connect(self.update_url)
    self.browser.loadProgress.connect(self.progress_bar.setValue)
    main_layout.addWidget(self.browser)

  def navigate_home(self):
    self.browser.setUrl(QUrl("https://www.google.com"))

  def navigate_to_url(self):
    text = self.url_bar.text().strip()
    if not text:
      return

    if "." not in text and " " in text:
      url = f"https://www.google.com/search?q={text.replace(' ', '+')}"
    elif "." not in text and not text.startswith("http"):
      url = f"https://www.google.com/search?q={text}"
    elif not text.startswith("http://") and not text.startswith("https://"):
      url = "http://" + text
    else:
      url = text

    self.browser.setUrl(QUrl(url))

  def update_url(self, q):
    self.url_bar.setText(q.toString())

  def on_download_requested(self, download):
    # Обробник скачування будь-яких файлів (.apk, .exe, .msix тощо)
    default_path = download.path()
    file_path, _ = QFileDialog.getSaveFileName(
        self, "Зберегти файл як...", default_path
    )
    if file_path:
      download.setPath(file_path)
      download.accept()


if __name__ == "__main__":
  app = QApplication(sys.argv)
  app.setApplicationName("Kishka Browser")
  window = ChromeLite()
  window.show()
  sys.exit(app.exec_())
