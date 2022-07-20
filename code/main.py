import threading
from multiprocessing.pool import ThreadPool as Pool
from pathlib import Path
from time import sleep, time

import pandas
import requests
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
from webdriver_manager.chrome import ChromeDriverManager

def run_driver(case):
    key = str(case)
    driver = create_driver()
    driver.get("https://weblink.co.thurston.wa.us/DCCASES/CustomSearch.aspx?SearchName=CivilCases")
    search_bar = driver.find_element(By.NAME, 'CivilCases_Input0')
    search_bar.send_keys("%s" % key)
    search_bar.send_keys(Keys.RETURN)
    try: 
        driver.find_element(By.XPATH, "// a[text()='Last']").click()
    except NoSuchElementException:
        pass

    driver.find_elements(By.CLASS_NAME, 'DocumentTitle')[-1].click()
    documents = driver.find_elements(By.CLASS_NAME, 'DocumentBrowserNameLink')
    doc_suffix = 0
    for document in documents:
        # sleep(1)
        document.click()
        driver.find_element(By.CLASS_NAME, 'DocumentRightPanelToolbarIcon').click()
        driver.find_element(By.ID, 'PdfDialog_download').click()
        sleep(5)
        driver.switch_to.window(driver.window_handles[-1])
        print("capture pdf url: {url}".format(url=driver.current_url))
        write_pdf(driver.current_url, key, doc_suffix)
        driver.switch_to.window(driver.window_handles[0])
        driver.back()
        doc_suffix += 1
        # sleep(100)
    driver.close()


def create_driver():
    # chrome_options = webdriver.ChromeOptions()
    # chrome_options.add_argument('--ignore-certificate-errors-spki-list')
    # chrome_options.add_argument('--ignore-ssl-errors')
    # driver = webdriver.Chrome(ChromeDriverManager().install(), chrome_options=chrome_options)
    driver = webdriver.Chrome(ChromeDriverManager().install())
    return driver


def write_pdf(url, key, suffix):
    pdf_key = 'D:/new_raw_cases/{key}/{key}_{suffix}.pdf'.format(key=key, suffix=suffix)
    print("write pdf: {pdf_name}".format(pdf_name=pdf_key))
    case_dir = 'D:/new_raw_cases/{key}'.format(key=key)
    Path(case_dir).mkdir(exist_ok=True)
    filename = Path(pdf_key)
    response = requests.get(url)
    filename.write_bytes(response.content)
    print("finish write pdf: {pdf_name}".format(pdf_name=pdf_key))


def load_csv():
    df = pandas.read_excel('./source.xlsx', engine='openpyxl')
    row, _ = df.shape
    return df, row


def case_scripting():
    print("start process case_number: {case_number}".format(case_number=case_number))
    run_driver(case_number)
    print("finished process case_number: {case_number}".format(case_number=case_number))


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print("start load csv")
    df, row = load_csv()
    start_time = time()
    threads = []
    # for i in range(0, row - 1):
    for i in range(1000, 1500, 5):
        for j in range(i, i + 5):
            try:
                case_number = int(df.iloc[j]['Case Number'])
                th = threading.Thread(target=run_driver, args=(case_number,))
                th.start()  # could `time.sleep` between 'clicks' to see whats'up without headless option
                threads.append(th)
            except Exception as ex:
                # swallow exception
                print(ex)
        for th in threads:
            th.join()  # Main thread wait for threads finish
    print("multiple threads took ", (time() - start_time), " seconds")
