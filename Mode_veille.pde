// Si on est en mode veille on repasse dans le mode principal et on met à jour le temps de dernière action
void Action_detectee() {
  if (indicateur_mode == 0) {
    indicateur_mode =1;
  }
     temps_derniere_action=System.currentTimeMillis();
}

