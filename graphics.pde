float rotX = (PI*3/8), rotY, rotZ = (PI*1/8), alpha[]={0, 0, 4, 0}, beta[]={0, 0, 0, 0}, gamma[]={0, 0, 0, 0}, alphaPassed[]={0, 0, 0, 0}, betaPassed[]={0, 0, 0, 0}, gammaPassed[]={0, 0, 0, 0}, platzhalter = 1, zoom = 2;
PShape leg, body;
float x_shift = 0, y_shift = 0; //oscillating body
float speed;
float x[]= {0, 0, 0, 0}, y[]= {0, 0, 0, 0}, z[]= {0, 0, 0, 0};  //coordinates
float stepheight = 150; //distance between body and ground
float len= 80;

void setupGraphics() {   
  leg = loadShape("leg.obj");
  body = loadShape("body.obj");
}

void loadGraphics() {
  background(32);
  smooth();
  lights();
  pText();
  pBottomview();
  translate(width/2, height/4);
  scale(zoom);
  rotateX(rotX);
  rotateZ(rotZ);
  pBody();
  pLegs();
}

float tip_x[] = {10, 10, 10, 10};
float tip_y[] = {10, 10, 10, 10};
float tip_z[] = {10, 10, 10, 10};

void pBottomview() {
  translate(7*width/8, 4*height/16);
  int shift_z[] = {70, -70, +70, -70}; //original dimensions (mm)
  int shift_x[] = {100, 100, -100, -100};
  float lineList[][] = {{0, 0}, {0, 0}, {0, 0}, {0, 0}};
  int lineCounter = 0;
  fill(255);
  ellipse(0, 0, 10, 10); //center of mass
  stroke(255);
  fill(0,0,0,0);
  ellipse(0,0,210,210);
  lineCounter = 0;
  for (int i = 0; i<4; i++) {
    tip_x[i]=80*(sin(betaPassed[i]-alphaPassed[i])-sin(alphaPassed[i]));
    float y_temp = 80*(cos(betaPassed[i]-alphaPassed[i])+cos(alphaPassed[i]));
    tip_y[i]=cos(gammaPassed[i])*sqrt(pow(tip_x[i], 2)+pow(y_temp, 2));
    tip_z[i]=sin(gammaPassed[i])*sqrt(pow(tip_x[i], 2)+pow(y_temp, 2));
    if (tip_y[i]>148) {
      fill(255, 100, 100);
      lineList[lineCounter][0]=(-tip_z[i]+shift_z[i]);
      lineList[lineCounter][1]=(tip_x[i]+shift_x[i]);
      lineCounter++;
    }
  }
  stroke(200);
  strokeWeight(3); 
  line(lineList[0][0], lineList[0][1], lineList[1][0], lineList[1][1]);
  line(lineList[1][0], lineList[1][1], lineList[2][0], lineList[2][1]);
  line(lineList[2][0], lineList[2][1], lineList[0][0], lineList[0][1]);
  stroke(0);
  strokeWeight(1);
  for (int i = 0; i<4; i++) {
    if (tip_y[i]>145) {
      fill(100, 255, 100);
    } else {
      fill(150);
    }
    ellipse((-tip_z[i]+shift_z[i]), (tip_x[i]+shift_x[i]), 20, 20); //zoom by 4
  }
  fill(100, 255, 255);
  ellipse(0, 0, 10, 10); //Center of mass
  translate(-7*width/8, -4*height/16);
}

void pBody() {
  float bodyMovement = 0, groundMovement = speed*(millis());
  float level = stepheight; //distance ground body
  translate(-groundMovement, 0, -level);
  fill(#363f3f);
  strokeWeight(1);
  stroke(0);
  for (float i = -700+int(groundMovement/25)*25; i<=700+groundMovement; i = i+25) {
    line(i, -100, i, 100);
  }
  for (int p = -100; p<=100; p = p+25) {
    line(groundMovement-725, p, 700+groundMovement, p);
  }
  translate(groundMovement, 0, level);
  translate(x_shift+25+bodyMovement, 10-y_shift, -106);
  shape(body);
  translate(-x_shift-25, -10+y_shift, 106);
}

void pLegs() {
  translate(-70+x_shift, 65-y_shift, 0);
  pWholeLeg(3, alphaPassed[3], -betaPassed[3], gammaPassed[3]);
  translate(70, -65, 0);
  translate(70, 65, 0);
  pWholeLeg(1, alphaPassed[1], -betaPassed[1], gammaPassed[1]);
  translate(-70, -65, 0);
  translate(-70, -65, 0);
  pWholeLeg(2, alphaPassed[2], -betaPassed[2], gammaPassed[2]);
  translate(70, 65, 0);
  translate(70, -65, 0);
  pWholeLeg(0, alphaPassed[0], -betaPassed[0], gammaPassed[0]);
  translate(-70-x_shift, 65+y_shift, 0);
}

void pWholeLeg(int num, float femur, float tibia, float coxa) { //ein Bein, Koordinatensytsem soll anschl. zurück an Ursprung gesetzt werden
  text(num, 10, 5);
  rotateX(coxa);
  rotateY(femur);
  translate(24, 128, -80);
  shape(leg);
  translate(-24, -128, 80);
  translate(0, 0, -80);
  rotateY(tibia);
  translate(24, 128, -80);
  shape(leg);
  translate(-24, -128, 80);
  rotateY(-tibia);
  translate(0, 0, 80);
  rotateY(-femur);
  rotateX(-coxa);
}


void mouseDragged() {
  rotY -= (mouseX - pmouseX) * 0.01;
  platzhalter-= (mouseY - pmouseY) * 0.01;
}

void keyPressed() {
  if (key == 'q') {
    zoom = zoom + 0.25;
  } else if (key == 'w') {
    zoom = zoom - 0.25;
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      rotZ += PI/8;
    } else if (keyCode == RIGHT) {
      rotZ -= PI/8;
    } else if (keyCode == UP) {
      rotX += PI/8;
    } else if (keyCode == DOWN) {
      rotX -= PI/8;
    }
  }
}

void position(float pa[], float pb[], float pg[]) { //simulates the "position" function in arduino (angles are not updates constantly)
  for (int p = 0; p<4; p++) {
    alphaPassed[p]=pa[p];
    betaPassed[p]=pb[p];
    gammaPassed[p]=pg[p];
  }
}

void pText(){
  fill(#FFFFFF);
  textAlign(LEFT, BOTTOM);
  text("(q/w)     Zoom: " + zoom,20,20);
  text("(up/do)  rotX: " + round(rotX/(2*PI)*360)+"°",20,40);
  text("(mou)     rotY: " + round(rotY/(2*PI)*360)+"°",20,60);
  text("(le/ri)     rotZ: " + round(rotZ/(2*PI)*360)+"°",20,80);
  //text("Time: " + gTime,20,100);
  //text("speed: " + speed,20,120);
  translate(0,600);
  text("  alpha[0]: " + (360*alphaPassed[0]/(2*PI)),20,-20);
  pie(50,0,alphaPassed[0], "alpha[0]");
  pie(100,0,betaPassed[0], "beta[0]");
  translate(0,-600);
}

void pie(int posX, int posY, float angle, String pieName){
  if(angle <= 0){
    arc(posX, posY, 30, 30, HALF_PI, HALF_PI-angle, PIE);
  }else{
    arc(posX, posY, 30, 30, HALF_PI-angle , HALF_PI, PIE);
  }
  textAlign(CENTER, BOTTOM);
  text(pieName, posX, posY);
}
