import sys
import os
import traceback
from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import (QApplication, QMainWindow, QToolBar, QLineEdit,
                             QAction, QTabWidget, QStatusBar, QFileDialog, QMessageBox)
from PyQt5.QtWebEngineWidgets import QWebEngineView, QWebEngineProfile
from PyQt5.QtGui import QIcon

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

DOWNLOAD_DIR = r"C:\Kishka Browser\Downloads"
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

def global_exception_handler(exc_type, exc_value, exc_traceback):
    err_msg = "".join(traceback.format_exception(exc_type, exc_value, exc_traceback))
    msg = QMessageBox()
    msg.setIcon(QMessageBox.Critical)
    msg.setWindowTitle("Помилка Kishka Browser")
    msg.setText("Сталася помилка при запуску або роботі:")
    msg.setDetailedText(err_msg)
    msg.exec_()
    sys.exit(1)

sys.excepthook = global_exception_handler

class Browser(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Kishka Browser V1.5")
        self.setWindowIcon(QIcon(resource_path("icon.ico")))
        self.resize(1200, 800)

        self.profile = QWebEngineProfile.defaultProfile()
        # Імітуємо ПК
        self.profile.setHttpUserAgent(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/120.0.0.0 Safari/537.36"
        )
        self.profile.setDownloadPath(DOWNLOAD_DIR)
        self.profile.downloadRequested.connect(self.handle_download)

        self.tabs = QTabWidget()
        self.tabs.setDocumentMode(True)
        self.tabs.setTabsClosable(True)
        self.tabs.tabCloseRequested.connect(self.close_tab)
        self.tabs.currentChanged.connect(self.current_tab_changed)
        self.setCentralWidget(self.tabs)

        navtb = QToolBar("Навігація")
        self.addToolBar(navtb)

        back_btn = QAction("←", self)
        back_btn.triggered.connect(lambda: self.current_browser().back())
        navtb.addAction(back_btn)

        forward_btn = QAction("→", self)
        forward_btn.triggered.connect(lambda: self.current_browser().forward())
        navtb.addAction(forward_btn)

        reload_btn = QAction("⟳", self)
        reload_btn.triggered.connect(lambda: self.current_browser().reload())
        navtb.addAction(reload_btn)

        home_btn = QAction("🏠", self)
        home_btn.triggered.connect(self.navigate_home)
        navtb.addAction(home_btn)

        navtb.addSeparator()

        self.urlbar = QLineEdit()
        self.urlbar.returnPressed.connect(self.navigate_to_url)
        navtb.addWidget(self.urlbar)

        stop_btn = QAction("✕", self)
        stop_btn.triggered.connect(lambda: self.current_browser().stop())
        navtb.addAction(stop_btn)

        self.status = QStatusBar()
        self.setStatusBar(self.status)

        # ЗМІНЕНО: Стартова сторінка - DuckDuckGo (без сервісів Google)
        self.add_tab(QUrl("https://duckduckgo.com"), "Старт")

    def current_browser(self):
        return self.tabs.currentWidget()

    def add_tab(self, qurl=None, label="Нова вкладка"):
        if qurl is None:
            qurl = QUrl("https://duckduckgo.com")
        browser = QWebEngineView()
        browser.setUrl(qurl)
        i = self.tabs.addTab(browser, label)
        self.tabs.setCurrentIndex(i)

        browser.urlChanged.connect(lambda qurl, b=browser: self.update_urlbar(qurl, b))
        browser.loadFinished.connect(lambda _, i=i, b=browser: self.tabs.setTabText(i, b.page().title()))
        browser.loadProgress.connect(lambda p, b=browser: self.status.showMessage(f"Завантаження... {p}%"))

    def close_tab(self, i):
        if self.tabs.count() < 2:
            return
        self.tabs.removeTab(i)

    def current_tab_changed(self, i):
        if i == -1:
            return
        qurl = self.current_browser().url()
        self.update_urlbar(qurl, self.current_browser())
        self.setWindowTitle(f"{self.tabs.tabText(i)} — Kishka Browser")

    def navigate_home(self):
        self.current_browser().setUrl(QUrl("https://duckduckgo.com"))

    def navigate_to_url(self):
        text = self.urlbar.text().strip()
        if not text:
            return
        if "." not in text and "://" not in text:
            # ЗМІНЕНО: Пошук через DuckDuckGo
            text = "https://duckduckgo.com/?q=" + text
        q = QUrl(text)
        if q.scheme() == "":
            q.setScheme("https")
        self.current_browser().setUrl(q)

    def update_urlbar(self, q, browser=None):
        if browser != self.current_browser():
            return
        self.urlbar.setText(q.toString())
        self.urlbar.setCursorPosition(0)

    def handle_download(self, item):
        path, _ = QFileDialog.getSaveFileName(
            self, "Зберегти файл",
            os.path.join(DOWNLOAD_DIR, item.downloadFileName()),
            "All Files (*.*)"
        )
        if path:
            item.setPath(path)
            item.accept()
            self.status.showMessage(f"Завантаження: {path}", 5000)
        else:
            item.cancel()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setApplicationName("Kishka Browser")
    window = Browser()
    window.show()
    sys.exit(app.exec_())
