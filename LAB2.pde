//NOTE:  all images for the textures are taken from this website
//       http://planetpixelemporium.com/

//Use the array list to store MANY SPHERES so we can generate
//     new spheres while the old ones are still bouncing
ArrayList<sphere> sphereList = new ArrayList<sphere>(); //USE ARRAY LIST FOR SPHERES

//Textures used for the spheres...
PImage earth;
PImage mars;
PImage jupiter;
PImage neptune;

class sphere{
  //The sphere object has:
  //   -X and Y coordinates
  //   -Speed affected by gravity
  //   -Gravity
  
  float xCoord;//X, Y and Z positions of the sphere...
  float yCoord;
  float zCoord;
  
  float xSpeed; //Change in speed and positions for the sphere...
  float ySpeed;
  float zSpeed;
  int gravity;
  
  PShape circle; //Used to map textures to spheres...
  
  //When we make a new sphere we need to set the varaibles to the
  //new values...
  sphere(int x, int y, int z, float xS, float yS, float zS, int g){
    //Make a new sphere and set the variables...
    xCoord = x;
    yCoord = y;
    zCoord = z;
    xSpeed = xS;
    ySpeed = yS;
    zSpeed = zS;
    gravity = g; //Constant...
    
    float rand = random(4); //RANDOMLY CHOOSES FROM 4 TEXTURES TO ADD TO SPHERE
    
    if(rand < 1){
      circle = createShape(SPHERE, 20);
      circle.setTexture(earth);
    }else if(rand < 2){
      circle = createShape(SPHERE, 20);
      circle.setTexture(mars);
    }else if(rand < 3){
      circle = createShape(SPHERE, 20);
      circle.setTexture(jupiter);
    }else{
      circle = createShape(SPHERE, 20);
      circle.setTexture(neptune);
    }
  }
  
  //Update the location of the spheres...
  //So the sphere actually move and bounce
  void updateLocation(){
    //Formulas
    //y = 1/2gt^2 + v*t + y0
    //v = u + gt
    //v^2 = u^2 + 2gy
    //x = v(x)t + x0
    
    //Translate the sphere according to the new coordinates
    //New coordinates found with formulas below...
    pushMatrix();
    translate(xCoord, yCoord, zCoord);
    noStroke();
    noFill();
    shape(circle);
    popMatrix();
    
    //I decided to multiply the speed by number smaller than one
    //so that the spheres don't randomly bounce forever...
    xSpeed = xSpeed * 0.995; 
    ySpeed = (ySpeed + gravity)*0.99; //From second formula...
    zSpeed = zSpeed * 0.995;
    
    xCoord = xCoord + xSpeed; //Change the X coord...
    yCoord = gravity/2 + ySpeed + yCoord; //From the first formula...
    zCoord = zCoord + zSpeed; //Change the Z coord...
    
    //Note the coords are based around the centre of the sphere
    //So we need to subtract or add 20 when checking the boundaries
    //Because 20 is size of sphere...
    //Made the total legnth of box to be 500, so it goes from 
    //minus 250 to 250.
    if((xCoord+20) > 250 || (xCoord-20) < -250){
      if((xCoord+20) > 250){
        xCoord = 230;
      }
      if((xCoord -20) < -250){
        xCoord = -230;
      }
      xSpeed = -zSpeed;
    }
    if((yCoord+20) > 250 || (yCoord-20) < -250){
      if((yCoord+20) > 250){
        yCoord = 230;
        ySpeed = -ySpeed - gravity;//I had to add this in else it won't work
      }else{
        yCoord = -230;
        ySpeed = -ySpeed;
      }
    }
    if((zCoord+20) > 250 || (zCoord-20) < -250){
      if((zCoord+20) > 250){
        zCoord = 230;
      }
      if((zCoord -20) < -250){
        zCoord = -230;
      }
      zSpeed = -zSpeed;
    }
  }
}

void setup(){
  size(500,500,P3D);
  earth = loadImage("earthmap.jpg"); //Set images...
  mars = loadImage("marsmap.jpg");
  jupiter = loadImage("jupitermap.jpg");
  neptune = loadImage("neptunemap.jpg");
}

void draw(){
  //Stuff about the background and the box etc...
  background(0);
  stroke(255);
  translate(width/2,height/2,0);
  pushMatrix();
  noFill();
  translate(0,0,0);
  box(500);
  popMatrix();
  
  //For every sphere in the image we need to update the location...
  for(int i = 0; i < sphereList.size(); i++){
    sphere s = sphereList.get(i); //Get the current sphere
    s.updateLocation(); //Update the location of the sphere
  }
}

void mousePressed(){
  //GENERATES A NEW BALL
  if(mouseButton == LEFT){
    //Left click to make a sphere (ball)...
    int xC = mouseX; //Get mouse coordinates...
    int yC = mouseY; //Mouse coords go from 0 to 500
    
    //We need to convert mouse coords from (0 to 500) to (-250 to 250)
    print("OLD: ", xC, yC, "\n"); //testing stuff...
    xC = (xC - 250);
    yC = (yC - 250);
    print("NEW: ", xC, yC, "\n"); //testing stuff...
    
    //Can go in NEGATIVE direction!
    float negative = random(2); //FOR X direciton: can be between 0 and 2
    float negative2 = random(2); //FOR Y direction;
    float negative3 = random(2); //FOR Z direction;
    
    float speedX; //Insert these variables into the constructor...
    float speedY;
    float speedZ;
    
    //RANDOM X Y Z DIRECTION
    if(negative < 1){
      speedX = random(20);
    }else{
      speedX = -random(20);
    }
    
    if(negative2 < 1){
      speedY = random(30);
    }else{
      speedY = -random(30);
    }
    
    if(negative3 < 1){
      speedZ = random(20);
    }else{
      speedZ = -random(20);
    }
    
    //Now the sphere will have a random X, Y, Z direction
    //The sphere STARTS AT THE Z AXIS (z coordinate is 0)
    sphere s = new sphere(xC, yC, 0, speedX, speedY, speedZ, 3); //3 is gravity...
    sphereList.add(s); //Add the new sphere to the list
  }
}
