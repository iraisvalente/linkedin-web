import openai
openai.api_key = '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'
messages = [ {"role": "system", "content": 
              "GOOGLE CEO."} ]
while True:
    message = input("User : ")
    if message:
        messages.append(
            {"role": "user", "content": message},
        )
        chat = openai.ChatCompletion.create(
            model="gpt-3.5-turbo", messages=messages
        )
    reply = chat.choices[0].message.content
    print(f"ChatGPT: {reply}")
    messages.append({"role": "assistant", "content": reply})