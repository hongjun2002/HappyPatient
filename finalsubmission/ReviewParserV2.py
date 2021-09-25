# This is a sample Python script.

import os
import openai
from array import *
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

# Super Secret API key, please don't steal from me or I will be sad
os.environ["OPENAI_API_KEY"] = "YOUR-API-KEY"  # change this to your key
openai.api_key = os.environ["OPENAI_API_KEY"]

# Note that you may need to change the encoding away from utf8 depending on the input file format.
# Also see line 47, which has a similar situation.
f = open("input.txt", encoding="utf8")  # input file
data = "Summarize what needs to be improved in the hospital:\n"
data += f.read()
data += "\nsummary:\n In general, the hospital should \n"

response = openai.Completion.create(
    engine="davinci-instruct-beta",
    prompt=data,
    temperature=0.7,
    max_tokens=64,
    top_p=1,
    frequency_penalty=0,
    presence_penalty=0
)

improvement = response
print(improvement.choices[0].text)

# This line contains sample reviews to give the API an idea of what to do
reviews = "Generate Ratings 1-10 based on customer's experience:\n1.Excellent hospital. Great nursing staff. Very " \
          "clean rooms and they made our stay comfortable. They took great care of my husband! Food needs improvement " \
          "but that will come in time!!\n2.I brought my girlfriend to the er. she had fell down and I needed to bring " \
          "her in. I dropped her off and went to park the truck. when I got to the ER the cop working the door " \
          "wouldn't check me in so I couldn't be in there with her!!! this is outrageous and is in now way " \
          "acceptable. we will not be returning to your hospital and I will have our baby elsewhere!\n3.Super " \
          "friendly staff and I saw the Doctor right away.\n4.I’m in the hospital & I’ve been told that my nurse will " \
          "help me to the bathroom about 10 times but they won’t let me go. And soooorude\nWe had a great experience " \
          "from start to finish. All the staff were exceptionally helpful & kind. The surgery went very well for my " \
          "spouse. The stay was very comfortable~for both of us. Thank you for setting the standard of what a " \
          "Hospital experience ought to be, and for the Get Well card for her too!!!!\n "

rates = "\n1.Rating: 8\n2.Rating:2\n3.Rating:7\n4.Rating:3\n5.Rating:9\n"
f = open("input.txt", encoding="utf8")

reviewInputs = ""

i = 7
for line in f.readlines():
    if line == "" or line == "\n" or line == "\0":
        break
    reviewInputs = reviewInputs + line + "\t"
    n = str(i)
    num = n + "."
    num += line
    i = i + 1
    reviews = reviews + "\n" + num

reviews += rates

response = openai.Completion.create(
    engine="davinci-instruct-beta",
    prompt=reviews,
    temperature=0.3,
    max_tokens=64,
    top_p=1,
    frequency_penalty=0,
    presence_penalty=0
)

print(response.choices[0].text)

outputRatings = ""

# Generates an array of ratings values
ratings = []
Rates = response.choices[0].text
for line in Rates.split("\n"):

    string = str(line[len(line) - 2:])

    try:
        rating = int(string)
        if rating > 10:
            rating = 10
        outputRatings = outputRatings + str(rating) + "\t"
        ratings.append(rating)
    except ValueError:
        string = str(line[len(line) - 1:])
        rating = int(string)
        outputRatings = outputRatings + string + "\t"
        ratings.append(rating)
        pass
# print(outputRatings)
# print(ratings)

# FrequencyArray stores the number of times a rating of [index+1] was given
frequencyArray = array('b', [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
# xAxisValues is basically a dummy array to provide labels for the X-Axis
xAxisValues = array('b', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

# Iterates frequency array counter depending on what the rating was
for num in ratings:
    frequencyArray[num - 1] += 1

# Exports a bar graph as a PDF
# Specify on the following line the filename and location of the graph
with PdfPages(r'C:\Users\levij\Downloads\Chart.pdf') as export_pdf:
    # This creates the bar graph
    plt.bar(xAxisValues, frequencyArray)
    plt.title("Rating Frequency")
    plt.xlabel("Rating (1-10)")
    plt.ylabel("Frequency")
    export_pdf.savefig()
    plt.close()

# ratings is an array, reviewInputs is a string that contains all the reviews
