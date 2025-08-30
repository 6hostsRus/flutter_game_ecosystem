
class PlayerController { bool grounded=false; double vx=0, vy=0; bool canDoubleJump=true;
  void jump(){ if(grounded){ vy=-400; grounded=false; canDoubleJump=true; } else if(canDoubleJump){ vy=-320; canDoubleJump=false; } }
  void move(double dir){ vx=160*dir; } void tick(double dt){ vy += 980*dt; }
}
