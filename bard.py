import sys
import requests
cookie="Xwj3gSD38KvVzyxHFGXiBu80aR-cmKx-CFQRZwEyLtTK9-BDdshhv8vPO2iSXXUvizvgZA."


from bardapi import Bard

name=""
token = cookie
question = f"{sys.argv[1]}  {sys.argv[2]}"
try:
    bard = Bard(token=token)
    answer= bard.get_answer(question)['content']
except Exception as e:
    if "Check __Secure-1PSID" in str(e):
        print("Secure-1PSID ::: Invalid")
        exit(1)
if "Error" in answer:
    print(f"{sys.argv[1]}  {sys.argv[2]}")
try:
    answer_list=answer.split(".")
    correct_answer= [x for x in answer_list if f"{sys.argv[1].upper()}" in x.upper() and  f"{sys.argv[2].upper()}" in x.upper() and  "IS" in x.upper()]
    complete_answer = ''.join(correct_answer)
    name = correct_answer[0]
    name = name.split("is")
    name = [y for y  in name if "THE" not in y.upper()]
    Real_answer = name[0].strip() + ".\n" + complete_answer  
    print(Real_answer)
except:
    print(f"{sys.argv[1]}  {sys.argv[2]}")
else:
    try:
        name=name[0].split(" ")
        name= '+'.join(x for x in name)[1:]
        search= f"https://google.com/search?q={name}+linkedin&btnI=I%27m+Feeling+Lucky&source=hp"
        #print(search)
        response=requests.get(search)
        #print(response.text)
        link=response.text.split('<a href="')[1].split('"')[0]
        print(f"Linked in link: {link}")
    except:
        print(f"")