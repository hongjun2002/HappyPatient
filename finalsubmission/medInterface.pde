import grafica.*;
import uibooster.*;
import uibooster.components.*;
import uibooster.model.*;
import uibooster.model.formelements.*;
import uibooster.utils.*;

import processing.net.*; 

Client myClient; 
int dataIn;

BufferedReader inputFile; 

String line;

String[] reviews = {"", "", "", "", ""};
String[] lines;
String[] sections;
String[] sentiments = {"", "", "", "", ""};
String file = "";
String recommendations = "";
String recList[];

float newestSentiment = 0;

Button generateButton;


void setup()
{
  background(255);
  size(1920, 1080);
 // smooth(1);
  surface.setResizable(true);
  frameRate(30);
  myClient = new Client(this, "127.0.0.1", 50007);
  generateButton = new Button(135, 770, 125, 35, "Get Insights",  12);
  
  //print(file);
}

void draw()
{
  background(255);
  fill(255);
  
  file = "";
  lines = loadStrings("openaitest/data.txt");
  for(int i = 0; i < lines.length; i++)
  {
    file += lines[i];
  }
  
  // Read values from file
  if(file != "")
  {
    //print("file not empty\n");
    
    sections = split(file, '|'); 
    
    //print(sections[0]);
    //print("\n\n\n\n");
    //print(sections[1]);
    //print("\n\n\n\n");
    
    if(sections[0] != "" && sections.length > 1 && sections[1] != "")
    {
      reviews = split(sections[0], '\t');
      sentiments = split(sections[1], '\t');
      recommendations = sections[2];
      recList = split(recommendations, ')');
      
      //print(recommendations);
      
      //print(reviews[0]);
      //print("\n\n\n\n");
      //print(sentiments[0]);
     // print("\n\n\n\n");
      
      if(reviews.length == sentiments.length) // only continue if arrays are parallel
      {
        //print("drawing");
        textSize(16);
        ;
        textFont(createFont("Arial Bold", 16));
        text("Patient Reviews" , 50, 70);
        textFont(createFont("Arial", 16));
        for(int i = 0;(i < reviews.length); i ++)
        {
          // List reviews
          
          if(reviews[i] != "" && parseInt(sentiments[i]) > 0  && parseInt(sentiments[i]) < 10)
          {
           /* ListElement selectedElement = new UiBooster().showList(
                "Reviews and Sentiments",
                "Patient Reviews",
                new ListElement(reviews[0], sentiments[0]),
                new ListElement(reviews[1], sentiments[1]),
                new ListElement(reviews[2], sentiments[2]),
                new ListElement(reviews[3], sentiments[3]),
                new ListElement(reviews[4], sentiments[4]),
                new ListElement(reviews[5], sentiments[5]),
                new ListElement(reviews[6], sentiments[6])
            ); */
            text(reviews[i], 50, 100 + (75*i));
            text("Rating - " + parseInt(sentiments[i]), 50, 129 + (75*i));
          }
        }   
        textFont(createFont("Arial Bold", 16));
        text("Insights", 50, 95 + (700));
        textFont(createFont("Arial", 16));
        generateButton.Draw();
        for(int i = 1; i < recList.length; i++)
        {
          textSize(16);
          text(recList[i].substring(0, recList[i].length() - 1), 50, 140 + (670 + 35*i));
        }
        if(generateButton.IsPressed())
        {
          myClient.write(1); // this means refresh
        }
        else
        {
          myClient.write(0); // don't refresh
        }
      }
      else
      {
        //print("non parallel arrays\n");
      }
    }
    else
    {
      //print("empty sections array");
    }
  }
  else
  {
    print("file empty\n");
     myClient.write(1); // send whatever you need to send here
     delay(3000);
  }
}


class Button
{
  private int x, y, width, height;
  private PFont font;
  private String label;
  private int fontSize;
  
  private int delay = 0, framesPassed = 0;
  
  public Button(int x, int y, int width, int height, String label, int fontSize)
  {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.font = createFont("Arial", 18, true);
    this.fontSize = fontSize;
    this.label = label;
  }
  
  public void Draw()
  {
    if(IsPressed())
    {
      fill(150);
      stroke(0);
      rect(x, y, width, height);
      textFont(font, fontSize);
      noStroke();
      fill(55);
      text(label, x + 5, y + (height - fontSize) / 2 + (height / 2));
    }
    else
    {
      if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height)
      {
        fill(200);
        stroke(0);
        rect(x, y, width, height);
        textFont(font, fontSize);
        noStroke();
        fill(55);
        text(label, x + 5, y + (height - fontSize) / 2 + (height / 2));
      }
      else
      {
        fill(255);
        stroke(0);
        rect(x, y, width, height);
        textFont(font, fontSize);
        noStroke();
        fill(0);
        text(label, x + 5, y + (height - fontSize) / 2 + (height / 2));
      }
    }
    
    
    if(framesPassed < delay)
    {
      framesPassed++;
    }
  }
  
  public void SetFrameDelay(int delay)
  {
    this.delay = delay;
  }
  
  public boolean IsPressed()
  {    
    if(!mousePressed)
    {
      return false;
    }
    
    if(mouseX >= x && mouseX <= x + width)
    {
      if(mouseY >= y && mouseY <= y + (height))
      {
        if(framesPassed == delay)
        {
          framesPassed = 0;
          return true;
        }
      }
    }
    
    return false;
  }
  
}
