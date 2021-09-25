# Takes in a text file full of processed reviews and extracts an array of sentiments

import os
import openai
import socket
import time

os.environ["OPENAI_API_KEY"] = "YOUR-API-KEY"

openai.api_key = os.environ["OPENAI_API_KEY"]

data = "Reviews:\n"
with open('output.txt', 'r') as file:
    data += (file.read())
file.close()
data += "\n\nRecommendations:1) Hospital staff can work to treat each patient with more compassion and care. Patients also enjoy the hospital's food.\n2)"
HOST = ''  # Symbolic name meaning all available interfaces
PORT = 50007  # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
while True:
    data1 = conn.recv(1024)
    if not data1: break
    print(data1)
    if data1 == b'\x01':
        time.sleep(3)
        print("updating")
        # wipe data.txt
        file = open("data.txt", "r+")
        file.truncate(0)
        file.close()

        # generate new response
        response = openai.Completion.create(
              engine="davinci",
              prompt=data,
              temperature=0.55,
              max_tokens=117,
              top_p=1,
              frequency_penalty=0.25,
              presence_penalty=0.13,
              stop=["\n\n"]
        )

        print(response.choices[0].text)

        # Parse sentiments from file

        sentiments = []
        file1 = open("output.txt")
        for line in file1.readlines():
            currentLine = (line.strip().split("Sentiment: "))
            sentimentVal = 0
            for i in currentLine:
                try:
                    sentimentVal = float(i)
                    if(sentimentVal > 0):
                        sentiments.append(sentimentVal)
                except ValueError:
                    pass
        file1.close()

        # Parse reviews from file
        reviews = []
        file1 = open("output.txt")
        chunks = (file1.read().split("###"))
        print(chunks)
        for index, item in enumerate(chunks):
            if (index % 2) != 0: # if index is odd (1, 3, 5, etc.)
                reviews.append(chunks[index])
        file1.close()
        print(len(reviews))
        print(reviews)

        # add reviews
        with open("data.txt", "a") as structured:
            for review in reviews:
                structured.write(review)
                structured.write('\t')
            structured.write('|')

            for sentiment in sentiments:
                structured.write(str(sentiment))
                structured.write('\t')

            structured.write("\n|Summary of complaints and improvements:\n1)")
            structured.write(response.choices[0].text)

        print("closed")
conn.close()
# optionally put a loop here so that you start
# listening again after the connection closes

