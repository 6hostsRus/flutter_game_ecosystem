
class SurvivorRunState { int wave=0; double timeSec=0; double damagePerSec=1; double health=100;
  void tick(double dt){ timeSec+=dt; if (timeSec ~/ 30 > wave){ wave+=1; } }
}
