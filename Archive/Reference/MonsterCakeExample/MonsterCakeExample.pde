// CAKE MONSTER
// Assignment 3 Program 2 KIB205 Laura Packer n6874606

// One Monster class object
Monster monster;
// One Timer class object
Timer timer;
// Declare cakes as Arraylist
// Array list is used so that objects can be deleted later
// So program does not slow down with build up of objects
ArrayList cakes;
// Window Size Variable
int wSize = 500;

void setup() {
  // Window Size
  size(wSize,wSize);
  // Smooth edges
  smooth();
  // New monster with diametre of 165 and random eye colour
  monster = new Monster(165, color(int(random(255)),int(random(255)),int(random(255))));
  // Create new ArrayList
  cakes = new ArrayList();
  // Create a new Timer
  timer = new Timer(300);
  // Start Timer
  timer.start();
}

void draw() {
  // Redraw purple background each frame
  background(136,112,165);
  // Draw monster class at mouseX, mouseY
  monster.setLocation(mouseX,mouseY); 
  monster.display(); 
  // If isFinished() function returns TRUE
  if (timer.isFinished()) {
    // Add a new cake object
    cakes.add(new Cake()); 
    // Start timer again
    timer.start();
 }
 // Move and display cakes
 for (int i = 0; i < cakes.size(); i++) {
   // Create Cake object 'd' and get index
   Cake d = (Cake)cakes.get(i);
   // Move d as per Move method
   d.move();
   // Display d as per Display method
   d.display();
   // If the monster 'eats' a cake
   if (monster.intersect(d) ){
     d.ate();
     // Change the monster's eye colour
     monster.eCol = color(int(random(255)),int(random(255)),int(random(255)));
   }
   // Once there are greater than 20 cakes in array
   if (cakes.size() > 20) {
     // Remove cake from beginning of array
     // This means the program will not slow down
     cakes.remove(0);
   }
 }
}
