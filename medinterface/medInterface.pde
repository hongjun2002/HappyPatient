import grafica.*;

import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.utils.*;



BufferedReader inputFile; 
String line;

String[] reviews = {"", "", "", "", ""};
String[] lines;
String[] sections;
String[] sentiments = {"", "", "", "", ""};
String file = "";

float newestSentiment = 0;


void setup()
{
  size(1920, 1080);
  smooth(2);
  surface.setResizable(true);
  lines = loadStrings("interface.txt");
  frameRate(30);
  for(int i = 0; i < lines.length; i++)
  {
    file += lines[i];
  }
  //print(file);
}

void draw()
{
  // Read values from file
  if(file != "")
  {
//print(file);
    sections = split(file, '|'); 
    //print(sections[0]);
    //print("\n\n\n\n");
    //print(sections[1]);
    //print("\n\n\n\n");
    if(sections[0] != "" && sections.length > 1 && sections[1] != "")
    {
      reviews = split(sections[0], '\t');
      sentiments = split(sections[1], '\t');
      
      print(reviews[0]);
      print("\n\n\n\n");
      print(sentiments[0]);
      print("\n\n\n\n");
      
      if(reviews.length == sentiments.length && sentiments.length == sections.length) // only continue if arrays are parallel
      {
        textSize(14);
        ;
        text("Reviews" , 50, 70);
        for(int i = 0;(i < reviews.length); i ++)
        {
          // List reviews
          if(reviews[i] != "" && parseInt(sentiments[i]) > 0  && parseInt(sentiments[i]) < 10)
          {
            text(reviews[i], 50, 100 + (100*i));
            text("Review sentiment: " + parseInt(sentiments[i]), 70, 150 + (100*i));
          }
        }   
        text("Suggestions", 50, 550);
      }
    }
    else
    {
     // print("empty sections array");
    }
  }
}
