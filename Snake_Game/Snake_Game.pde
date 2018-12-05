import ddf.minim.*;
//--------------Variables----------------------
Minim minim;
AudioPlayer player;
AudioSample impacto;
AudioSample die;
int puntaje;
int puntaje_max;
int filas=40;//tamaño de filas
int columnas = 40;//tamaño de columnas
int bs=10; //tamaño de cuadrados
PImage background;//imagen de fondo

ArrayList<Integer> posX = new ArrayList<Integer>();//posicion de la serpiente
ArrayList<Integer> posY = new ArrayList<Integer>();//posicion de la serpiente

int dir=0;//dirección hacia donde se mueve la serpiente
//vectores para movimiento
int[]dx ={0,0,-1,1};
int[]dy={-1,1,0,0};

//objeto que come la serpiente
int appleX;
int appleY;

boolean gameOver=false;
//--------------Inicializacion-----------------
void  setup(){
  size(400,400);
  frameRate(15);//velocidad del juego
  background=loadImage("fondojuego.jpg");//imagen de fondo
  
  minim=new Minim(this);
  //sonidos incorporados
  impacto= minim.loadSample("Coin.mp3");
  die= minim.loadSample("Die.mp3");
  player = minim.loadFile("song.mp3");
  player.play();
  
  //posición de la serpiente inicializada
  posX.add(20);
  posY.add(20);
  
  //pocision de la fruta aleatoria, en el rango de los cuadros
  appleX=(int)random(0,filas);
  appleY=(int)random(0,filas);  
}

//--------------Main---------------------------
void draw(){  
  //background(255);//fondo de pantalla blanco
  image(background, 0, 0);//fondo de pantalla con la imagen en la posicion 0,0
   
 System.out.println(posX+" "+posY);//tamaño de Snake y ubicaciones
 
 if (gameOver){
   puntaje=0;
   player.rewind();//stop cancion al perder   
   fill(255);//color del texto
   textSize(20);//tamaño del texto    
   text("Press space to continue.",85,height/2);//mensaje y posicion del mensaje
      
   fill(255);//color del texto
   textSize(25);//tamaño del texto 
   text("TOP SCORE \n"+puntaje_max,135,height/6);//mensaje y posicion del mensaje
 
 }else{
   
     fill(255);//color del texto
     textSize(10);//tamaño del texto    
     text("Puntaje "+puntaje,0,height);//mensaje y posicion del mensaje
   
   /*//regilla
   fill(0);
   for (int i = 0; i < filas; i++) {
     line(0, i*bs, width, i*bs);
   }
   for (int j = 0; j < columnas; j++) {
     line(j*bs, 0, j*bs, height);
   }*/   
    
   //movimiento de la serpiente
   posX.add(0, posX.get(0)+dx[dir]);
   posY.add(0, posY.get(0)+dy[dir]);
   posX.remove(posX.size()-1);//borrar rastro
   posY.remove(posY.size()-1);//borrar rastro
   
   //detectarBorde
   if ((posX.get(0)<0)||(posX.get(0)>filas-1)||( posY.get(0)<0)||(posY.get(0)>columnas-1)){//posiciones por todos los bordes
     die.trigger();//die song al tocar los bordes
     gameOver=true;     
   }  
   if(puntaje>puntaje_max){//puntaje max
     puntaje_max=puntaje;
   }
   //comer
   if ((posX.get(0)==appleX)&&(posY.get(0)==appleY)) {//si la posicion de la serpiente esta en la misma de la fruta
     //al comer la fruta, esta vuelve a salir en otro lugar
     puntaje+=100;
     impacto.trigger();
     appleX = (int) random(0, filas);
     appleY = (int) random(0, filas);
     //al comer la serpiente crece
     posX.add(posX.get(posX.size()-1));
     posY.add(posY.get(posY.size()-1));
   }   
   //dibujar fruta
   fill(0);//color de la fruta
   rect(appleX*bs,appleY*bs,bs,bs);
    
   //dibujar snake
   fill(255);//color snake
   for(int i = 0;i<posX.size();i++){
     rect(posX.get(i)*bs,posY.get(i)*bs,bs,bs);//ubicacion de la serpiente
   }
 }
}
//movimiento
void keyPressed(){
  if(key=='w')dir=0;//arriba
  if(key=='s')dir=1;//abajo
  if(key=='a')dir=2;//izquierda
  if(key=='d')dir=3;//derecha
  if(key==' '){gameOver=false;
    player.play();
    //reinicio de posiciones
    posX.clear();
    posY.clear();
    posX.add(10);
    posY.add(10);
    appleX = (int) random(0, filas);
    appleY = (int) random(0, filas);
  }
}
