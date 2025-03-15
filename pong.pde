/*
Sai Sohan Gogineni
 UID: 120659584
 Section: 0105
 03/11/2025
 CMSC131 Project 3: Pong
 I pledge on my honor that I have not given or received any unauthorized assistance on this assignment/examination.
*/

//globals
boolean showMessage = false;
boolean waitingForReset = false;
boolean gameOver = false;
boolean moveP1Up = false;
boolean moveP1Down = false;
boolean moveP2Up = false;
boolean moveP2Down = false;

int canvasWidth = 800;
int canvasHeight = 600;
int paddleW = 20;
int paddleH = 100;
int ballR = 10;
float ballX, ballY, p1X, p2X, p1Y, p2Y;
int bvX = 0, bvY = 0;
int p1Lives = 3, p2Lives = 3;
boolean gameStarted = false;

int trailLength = 10;
float[] trailsX = new float[trailLength];
float[] trailsY = new float[trailLength];

void setup() {
    size(800, 600);
    reset();
}

void draw() {
    background(0);

    //draw court
    fill(80);
    noStroke();
    rect(width / 2 - 1, 0, 2, height);
    noFill();
    stroke(80, 80, 80, 255);
    strokeWeight(2);
    ellipse(width / 2, height / 2, 200, 200);

    // draw paddles
    fill(255);
    noStroke();
    rect(p1X, p1Y, paddleW, paddleH);
    rect(p2X, p2Y, paddleW, paddleH);

    // display live score
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("p1 lives: " + p1Lives + "   |   p2 lives: " + p2Lives, width / 2, 40);

    if (gameOver) {
        textSize(30);
        fill(255, 0, 0);
        text("game over!", width / 2, height / 2 - 20);
        textSize(20);
        text("press n to start a new game.", width / 2, height / 2 + 20);
        return;
    }

    //move paddles
    if (moveP1Up && p1Y > 0) p1Y -= 5;
    if (moveP1Down && p1Y + paddleH < height) p1Y += 5;
    if (moveP2Up && p2Y > 0) p2Y -= 5;
    if (moveP2Down && p2Y + paddleH < height) p2Y += 5;

    //ball movement
    if (gameStarted) {
        for (int i = trailLength - 1; i > 0; i--) {
            trailsX[i] = trailsX[i - 1];
            trailsY[i] = trailsY[i - 1];
        }

        trailsX[0] = ballX;
        trailsY[0] = ballY;

        ballX += bvX;
        ballY += bvY;

        if (collisionY()) bvY = -bvY;
        if (collisionX()) bvX = -bvX;

        if (ballX <= -ballR) {
            p1Lives--;
            gameStarted = false;
            waitingForReset = true;
            showMessage = true;
            checkGameOver();
        } else if (ballX >= width + ballR) {
            p2Lives--;
            gameStarted = false;
            waitingForReset = true;
            showMessage = true;
            checkGameOver();
        }
    }

    //draw ball trail
    for (int i = 0; i < trailLength; i++) {
        fill(150, 255, 132, map(i, 0, trailLength, 255, 50));
        ellipse(trailsX[i], trailsY[i], ballR * 2 - i, ballR * 2 - i);
    }

    //draw ball
    fill(255);
    ellipse(ballX, ballY, ballR * 2, ballR * 2);

    //show text if waiting for reset
    if (showMessage) {
        fill(255);
        textSize(20);
        text("press c to reset, then t to continue.", width / 2, height / 2);
    }
}

boolean collisionY() {
    if (ballY - ballR <= 0 || ballY + ballR >= height) {
        return true;
    }
    return false;
}

boolean collisionX() {
    if (ballX - ballR <= p1X + paddleW && ballY >= p1Y && ballY <= p1Y + paddleH) {
        if (bvX < 0) return true;
    }
    if (ballX + ballR >= p2X && ballY >= p2Y && ballY <= p2Y + paddleH) {
        if (bvX > 0) return true;
    }
    return false;
}

void ballInit() {
    bvX = random(1) < 0.5 ? -4 : 4;
    bvY = int(random(3, 11)) * (random(1) < 0.5 ? -1 : 1);
}

void clearTrail() {
    for (int i = 0; i < trailLength; i++) {
        trailsX[i] = ballX;
        trailsY[i] = ballY;
    }
}

void reset() {
    p1X = 0;
    p2X = width - paddleW;
    p1Y = height / 2 - paddleH / 2;
    p2Y = height / 2 - paddleH / 2;
    ballX = canvasWidth / 2;
    ballY = canvasHeight / 2;
    bvX = 0;
    bvY = 0;
    p1Lives = 3;
    p2Lives = 3;
    gameStarted = false;
    waitingForReset = false;
    showMessage = false;
    gameOver = false;
    clearTrail();
}

void cReset() {
    if (!waitingForReset || gameOver) return;

    int val2 = int(random(3, 11)) * (random(1) < 0.5 ? -1 : 1);

    if (ballX <= 0 - ballR) {
        bvX = 4;
        bvY = val2;
        ballX = p1X + paddleW + ballR + 5;
        ballY = p1Y + 50;
    } else if (ballX >= width + ballR) {
        bvX = -4;
        bvY = val2;
        ballX = p2X - ballR - 5;
        ballY = p2Y + 50;
    }

    showMessage = false;
    waitingForReset = false;
    clearTrail();
}

void checkGameOver() {
    if (p1Lives == 0 || p2Lives == 0) {
        gameOver = true;
    }
}

void keyPressed() {
    if (key == 't' || key == 'T') {
        if (!waitingForReset && !gameStarted && !gameOver) {
            ballInit();
            gameStarted = true;
        }
    }
    if (key == 'n' || key == 'N') {
        reset();
    }
    if (key == 'c' || key == 'C') {
        if (waitingForReset && !gameOver) {
            cReset();
        }
    }
    if (key == 'w' || key == 'W') moveP1Up = true;
    if (key == 's' || key == 'S') moveP1Down = true;
    if (key == 'i' || key == 'I') moveP2Up = true;
    if (key == 'k' || key == 'K') moveP2Down = true;
}

void keyReleased() {
    if (key == 'w' || key == 'W') moveP1Up = false;
    if (key == 's' || key == 'S') moveP1Down = false;
    if (key == 'i' || key == 'I') moveP2Up = false;
    if (key == 'k' || key == 'K') moveP2Down = false;
}
