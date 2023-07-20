import sys
from bardapi import Bard
import pandas as pd
import pathlib
from pathlib import Path
import os 

ROOT_DIR=pathlib.Path().resolve()
ROOT_DIR=f"{ROOT_DIR}\\LinkedIn"
home = str(Path.home())
downloads = f'{home}\\Downloads'
unzip_path = os.path.join(ROOT_DIR, "unzip")
os.makedirs(unzip_path, exist_ok=True)
cookie="WQjKRrrtorh5vfzDVPJv1HH3QNSRVe7XDpGpGNoPTwSCggDZxBoq5nfbUah4odlMpefdXA."


csv_file = pd.read_csv(f"{unzip_path}\\{sys.argv[1]}")
for index, row in csv_file.iterrows():
    


bard = Bard(token=cookie)
answer=bard.get_answer(chat)['content']
print(answer)