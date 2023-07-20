from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from time import sleep
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome  import ChromeDriverManager
from selenium.webdriver import ActionChains
import os
from pathlib import Path
import zipfile
import sys
import pandas as pd
import sqlite3
import keyboard
import pathlib
import mysql.connector
import shutil

try:
    cnx = mysql.connector.connect(user='root', password='Aiver!2023!',host='127.0.0.1',database='linkedin')
    print("Connected to DB")
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
    print("Something is wrong with your user name or password")
  elif err.errno == errorcode.ER_BAD_DB_ERROR:
    print("Database does not exist")
  else:
    print(err)

###Verify
####https://www.linkedin.com/uas/login-submit
###incorrect password or user

#ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROOT_DIR=pathlib.Path().resolve()
ROOT_DIR=f"{ROOT_DIR}\\LinkedIn"
home = str(Path.home())
downloads = f'{home}\\Downloads'
unzip_path = os.path.join(ROOT_DIR, "unzip")
os.makedirs(unzip_path, exist_ok=True)
#con = sqlite3.connect(f"{ROOT_DIR}\\linkedin.db")


#cur.execute("CREATE TABLE if not exists linkedin(First_Name TEXT,Last_Name TEXT ,Email_Address TEXT,Company TEXT,Position TEXT)")

def choice(user,passwd):
    assert user, "User is not defined"
    assert passwd,"Password not defined" 
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    driver.get("https://www.linkedin.com/")
    sleep(10)
    search_bar = driver.find_element(By.ID,"session_key")
    search_bar.clear()
    search_bar.send_keys(user)
    search_bar = driver.find_element(By.ID,"session_password")
    search_bar.clear()
    search_bar.send_keys(f"{passwd}{Keys.RETURN}")
    sleep(10)
    driver.get('https://www.linkedin.com/mypreferences/d/download-my-data')
    sleep(10)
    driver.switch_to.frame(0)
    search_bar=driver.find_element(By.XPATH,'/html/body/div/form/fieldset/ul/li[2]/label').click()
    sleep(3)
    search_bar=driver.find_element(By.XPATH,'/html/body/div/form/fieldset/ul/li[2]/ul/li[2]/label').click()
    sleep(3)
    search_bar=driver.find_element(By.XPATH,'/html/body/div/form/fieldset/span/button').click()
    sleep(5)
    driver.close()
    
def download(user,passwd):
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    driver.get("https://www.linkedin.com/")
    sleep(10)
    search_bar = driver.find_element(By.ID,"session_key")
    search_bar.clear()
    search_bar.send_keys(user)
    search_bar = driver.find_element(By.ID,"session_password")
    search_bar.clear()
    search_bar.send_keys(f"{passwd}{Keys.RETURN}")
    sleep(3)
    driver.get('https://www.linkedin.com/mypreferences/d/download-my-data')
    sleep(10)
    driver.switch_to.frame(0)
    search_bar=driver.find_element(By.XPATH,'/html/body/div/form/fieldset/span/button').click()
    sleep(30)

def extract():
    print(downloads)
    file_list=os.listdir(downloads)
    for file in file_list:
        if file.endswith(".zip"):
            if "Basic_LinkedInDataExport_" in file:
                print(f"{downloads}\\{file}")
                with zipfile.ZipFile(f"{downloads}\\{file}", 'r') as unzipper:
                    unzipper.extractall(f"{unzip_path}\\{file.split('.zip')[0]}")
                    print(f"Copied to {unzip_path}\\{file.split('.zip')[0]}")


def append(connection):
    print("append")
    for dir_name, dirs, files in os.walk(unzip_path):
        print(f"verifying {dir_name}")
        for file_name in files:
            print(f"verifying {file_name}")
            if file_name=="Connections.csv":
                cur = cnx.cursor()
                print("Running connections")            
                csv_file = pd.read_csv(f"{dir_name}\\{file_name}",skiprows=3,encoding='utf-8-sig')
                for index, row in csv_file.iterrows():
                    FirstName=str(row["First Name"]).replace("'s","s").replace("'S","S").strip()
                    LastName=str(row["Last Name"]).replace("'s","s").replace("'S","S").strip()	
                    EmailAddress=str(row["Email Address"]).replace("'s","s").replace("'S","S").strip()
                    Company=str(row["Company"]).replace("'s","s").replace("'S","S").strip()
                    CompanyPosition=str(row["Position"]).replace("'s","s").replace("'S","S").strip()	
                    SOAConnection=connection
                    try:
                        print(f'{LastName.upper()}')
                        print(FirstName,LastName,EmailAddress,Company,CompanyPosition)
                        statement=f"Select * from connections where First_Name = '{FirstName.upper()}' and Last_Name = '{LastName.upper()}' and  Company = '{Company.upper()}'"
                        print(statement)
                    except:
                        print("Cannot print")
                    try:
                        cur.execute(statement)
                        fetched= cur.fetchall()
                        if len(fetched) == 0:
                            statement=f"Insert into connections (First_Name,Last_Name,Email_Address,Company,Position,Connection) Values('{FirstName.upper()}','{LastName.upper()}','{EmailAddress.upper()}','{Company.upper()}','{CompanyPosition.upper()}','{SOAConnection.upper()}')"
                            print(statement)
                            cur.execute(statement)
                    except:
                        print("Error Ocurrs")
                cur.close()
    cnx.commit()
    print("commited")

                        

def Copy(src):
    print("Copy")
    name=src.split("\\")[-1]
    print(name)
    print(src)
    shutil.copyfile(src,f"{unzip_path}\\{name}")
    print(f"Copied to {unzip_path}")
    
    
if '__main__':
    print("on main")
    if len(sys.argv) == 1:
        print(f"Please don't double click on me. Open a terminal and run {sys.argv[0]}")
        print(f"Please try {sys.argv[0]} [user,pass] action\naction= choice, download,extract or append (choice or download require user and pass {{Sequence should be choice,download,extract then append}})") 
        keyboard.read_key()
        print( "Error")
        sys.exit(1)
    try:
        user=sys.argv[1]
        passw=sys.argv[2]
    except:
        action=sys.argv[1]
    else:  
        try:  
            action=sys.argv[3]
        except:
            action=sys.argv[1]
            connection=sys.argv[2]
            print(f"{action},{connection}")
            #print("Error occurred: 1.-User, password or action not defined, 2.-Parameter declared in a function that doesn't requires any parameter.")
            #sys.exit(2)
    #print(f"User:{user},Password:{passw},Action:{action}")
    print(f"Action:{action}")
    if action == "choice":
        if len(sys.argv) < 4:
            print("User or passwd not defined")
        else:
            choice(user,passw)
            print("Done")
    elif action == "download" :
        if len(sys.argv) < 4:
            print("User or passwd not defined")
        else:
            download(user,passw)
            print("Downloaded")
    elif action == "extract":
        if len(sys.argv) > 2:
            print("extract doesnt have any parameter")
        else:
            extract()
            print("Extracted")
    elif action == "append":
        if len(sys.argv) < 3:
            print("You need to send the mail connection")
        else:
            append(connection)
            print(f"Data base saved in {ROOT_DIR}")
    elif action == "Copy":
        if len(sys.argv) < 3:
            print("You need to send the file to copy")
        else:
            print("trying to copy")
            Copy(connection)
    else:
        print("Action not defined")