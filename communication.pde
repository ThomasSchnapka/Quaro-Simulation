import hypermedia.net.*;
UDP udp;  // define the UDP object
String UDP_IP = "127.0.0.1";
int UDP_PORT_receive = 6000;
int UDP_PORT_send = 5006;

void setupUDP(){
  
  udp = new UDP( this, UDP_PORT_receive ); //for incoming messages
  udp.log(false);
  udp.listen( true );
}

void receive( byte[] data ) { //Event
  String raw_string = new String(subset(data, 0, data.length));
  String message = raw_string.substring(raw_string.indexOf("<")+1,raw_string.indexOf(">"));
  if (!message.equals("end")) {
    if (message.indexOf(":")>0) { //when datatype is empty
      String s[] = split(message,":");
      applyNewData(s[0],float(s[1]));
    } else {
      applyNewData(message,0);
    }
  } else {
    //after mes = "end" send Data
    sendData();
  }
}

void sendData() {
  udp.send("Insert sensoring data here", UDP_IP, UDP_PORT_send );
}

float c[]={0, 0, 0, 0};
float f[]={0, 0, 0, 0};
float t[]={0, 0, 0, 0};

void applyNewData(String mes, float value) { //Handling strings is not easy
  if (mes.charAt(0)=='c') {
    c[int(mes.charAt(1))-49]=value*(2*PI/360);
  }else if (mes.charAt(0)=='f') {
    f[int(mes.charAt(1))-49]=value*(2*PI/360);
  }else if (mes.charAt(0)=='t') {
    t[int(mes.charAt(1))-49]=value*(2*PI/360);
  }else if (mes.charAt(0)=='x') {
    x_shift = value;
  }else if (mes.charAt(0)=='s') {
    speed = value;
  }else if (mes.charAt(0)=='y') {
    y_shift = value;
  }else {
    println("No match: "+mes+": "+value);
  }
  position(f,t,c);
}
