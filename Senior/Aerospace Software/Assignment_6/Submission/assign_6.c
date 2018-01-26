#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include<time.h>

// Constants
static double PI=3.14159265;
static double G=0.00000000006674;
static double mM=73476730900000000000000.0;
static double mE=5972190000000000000000000.0;
static double mS=28833.0;
static double rM=1737100.0;
static double rE=6371000.0;

struct body {
  double posX,posY,velX,velY;
};

void change(double *var, double val)
{
  *var=val;
}

double distance(struct body body1, struct body body2)
{
  double d;
  d=sqrt(pow(body1.posX-body2.posX,2)+pow(body1.posY-body2.posY,2));
  return d;
}

double force(double pos1, double pos2, double m1, double m2, double d)
{
  double F;
  F=((G*m1*m2)*(pos1-pos2))/(pow(d,3));
  return F;
}

double euler(struct body* SCn, struct body SC, struct body* Moonn, struct body Moon, struct body Earth, double dt)
{
  double F_MSx,F_MSy,F_ESx,F_ESy,F_EMx,F_EMy,F_SMx,F_SMy,d_MS,d_ES,d_EM;

  d_MS=distance(Moon,SC);
  d_ES=distance(Earth,SC);
  d_EM=distance(Earth,Moon);

  F_MSx=force(Moon.posX,SC.posX,mM,mS,d_MS);
  F_MSy=force(Moon.posY,SC.posY,mM,mS,d_MS);

  F_ESx=force(Earth.posX,SC.posX,mE,mS,d_ES);
  F_ESy=force(Earth.posY,SC.posY,mE,mS,d_ES);

  F_EMx=force(Earth.posX,Moon.posX,mE,mM,d_EM);
  F_EMy=force(Earth.posY,Moon.posY,mE,mM,d_EM);

  F_SMx=force(SC.posX,Moon.posX,mS,mM,d_MS);
  F_SMy=force(SC.posY,Moon.posY,mS,mM,d_MS);

  SCn->posX=SC.posX+dt*SC.velX;
  SCn->posY=SC.posY+dt*SC.velY;

  Moonn->posX=Moon.posX+dt*Moon.velX;
  Moonn->posY=Moon.posY+dt*Moon.velY;

  SCn->velX=SC.velX+dt*((F_MSx+F_ESx)/mS);
  SCn->velY=SC.velY+dt*((F_MSy+F_ESy)/mS);

  Moonn->velX=Moon.velX+dt*((F_EMx+F_SMx)/mM);
  Moonn->velY=Moon.velY+dt*((F_EMy+F_SMy)/mM);

  return 0;
}

void objective1(struct body SC, struct body Moon, struct body Earth, double theta_S, double v_S,double dt, double clear, double acc)
{
  // Initialize variables
  double t,tn,dy,dx,dysmall,dxsmall,d_ES,d_EM,d_SM;
  struct body SC_reset,Moon_reset;

  SC_reset=SC;
  Moon_reset=Moon;

  d_ES=340000000.0;
  d_EM=384403000.0;
  d_SM=distance(SC,Moon);

  tn=10000000.0;

  dysmall=-100;
  dxsmall=-100;

  dy=-100;
  while (dy<100) {
    dx=-100;
    while (dx<100) {
      Moon=Moon_reset;
      SC=SC_reset;
      if (sqrt(pow(dy,2)+pow(dx,2))<100 && sqrt(pow(dy,2)+pow(dx,2))<sqrt(pow(dysmall,2)+pow(dxsmall,2)))
      {
        SC.velX=v_S*cos(theta_S)+dx;
        SC.velY=v_S*sin(theta_S)+dy;

        t=1.0;
        while(t<=tn)
        {
          euler(&SC,SC,&Moon,Moon,Earth,dt);

          // distances for termination
          change(&d_SM,distance(SC,Moon));
          change(&d_ES,distance(SC,Earth));
          change(&d_EM,distance(Moon,Earth));

          if ( d_SM<(rM+clear) ) {
            // printf("Hit Moon!\n");
            // printf("%lf\n", t);
            break;
          }
          else if ( d_ES<rE ) {
            // printf("Made it!\n");
            if (sqrt(pow(dy,2)+pow(dx,2))<sqrt(pow(dysmall,2)+pow(dxsmall,2))) {
              change(&dysmall,dy);
              change(&dxsmall,dx);
            }
            // printf("%lf\n", t);
            break;
          }
          else if ( d_ES>2*d_EM ) {
            // printf("Lost in Space\n");
            // printf("%lf\n", t);
            break;
          }
          else {
            t=t+dt;
          }
        }
      }
      dx=dx+acc;
    }
    dy=dy+acc;
  }
  printf("dx: %lf dy: %lf\n",dxsmall,dysmall);

  // Output to file
  // Reset for final run to be saved
  Moon=Moon_reset;
  SC=SC_reset;

  // Creating the file name takes about 90% of this, the answer is 15 lines
  // turn the clearance into a string
  char clearstr[10],accstr[10];
  sprintf(clearstr, "%1.0lf", clear);

  // turn the accuracy into a string and replace the period.
  // Yes this entire thing is written for that stupid operation
  int j=0;
  sprintf(accstr, "%1.1lf", acc);
  char *with_a_p = malloc(strlen(accstr) + 1);
  while (accstr[j] != '\0'){
    if (accstr[j] == '.') {
      with_a_p[j]='p';
    } else {
      with_a_p[j]=accstr[j];
    }
    j++;
  }
  with_a_p[j] = 0; // end the string

  // Combining all of the strings (c really sucks at strings)
  char final[50],line[2],extension[4];
  strcpy(final,"Optimum_1_");
  strcpy(line,"_");
  strcpy(extension,".txt");

  strcat(final,clearstr);
  strcat(final,line);
  strcat(final,with_a_p);
  strcat(final,extension);

  // finally making the file
  FILE *f = fopen(final, "w");
  if (f == NULL)
  {
    printf("Error opening file!\n");
    exit(1);
  }

  SC.velX=v_S*cos(theta_S)+dxsmall;
  SC.velY=v_S*sin(theta_S)+dysmall;

  t=1.0;
  while(t<=tn)
  {
    euler(&SC,SC,&Moon,Moon,Earth,dt);
    change(&d_ES,distance(SC,Earth));
    if ( d_ES<rE ) {
      break;
    }
    t=t+dt;
    double trajectory[7]={t,SC.posX,SC.posY,Moon.posX,Moon.posY,Earth.posX,Earth.posY};
    for (int i = 0; i < 7; i++) {
      fprintf(f, "%lf ", trajectory[i]);
    }
    fprintf(f, "\n");
  }

}

void objective2(struct body SC, struct body Moon, struct body Earth, double theta_S, double v_S,double dt, double clear, double acc)
{
  // Initialize variables
  double t,tn,tsmall,dyfast,dxfast,dy,dx,d_ES,d_EM,d_SM;
  struct body SC_reset,Moon_reset;

  SC_reset=SC;
  Moon_reset=Moon;

  d_ES=340000000.0;
  d_EM=384403000.0;
  d_SM=distance(SC,Moon);

  tn=10000000.0;
  tsmall=10000000.0;

  dyfast=-100;
  dxfast=-100;

  dy=-100;
  while (dy<100) {
    dx=-100;
    while (dx<100) {
      Moon=Moon_reset;
      SC=SC_reset;
      if (sqrt(pow(dy,2)+pow(dx,2))<100)
      {
        SC.velX=v_S*cos(theta_S)+dx;
        SC.velY=v_S*sin(theta_S)+dy;

        t=1.0;
        while(t<=tsmall)
        {
          euler(&SC,SC,&Moon,Moon,Earth,dt);

          // distances for termination
          change(&d_SM,distance(SC,Moon));
          change(&d_ES,distance(SC,Earth));
          change(&d_EM,distance(Moon,Earth));

          if ( d_SM<(rM+clear) ) {
            // printf("Hit Moon!\n");
            // printf("%lf\n", t);
            break;
          }
          else if ( d_ES<rE ) {
            // printf("Made it!\n");
            if (t<tsmall) {
              change(&dyfast,dy);
              change(&dxfast,dx);
              change(&tsmall,t);
            }
            // printf("%lf\n", t);
            break;
          }
          else if ( d_ES>2*d_EM ) {
            // printf("Lost in Space\n");
            // printf("%lf\n", t);
            break;
          }
          else {
            t=t+dt;
          }
        }
      }
      dx=dx+acc;
    }
    dy=dy+acc;
  }
  printf("dx: %lf dy: %lf\n",dxfast,dyfast);

  // Output to file
  Moon=Moon_reset;
  SC=SC_reset;
  // Creating the file name takes about 90% of this, the answer is 15 lines
  // turn the clearance into a string
  char clearstr[10],accstr[10];
  sprintf(clearstr, "%1.0lf", clear);

  // turn the accuracy into a string and replace the period.
  // Yes this entire thing is written for that stupid operation
  int j=0;
  sprintf(accstr, "%1.1lf", acc);
  char *with_a_p = malloc(strlen(accstr) + 1);
  while (accstr[j] != '\0'){
    if (accstr[j] == '.') {
      with_a_p[j]='p';
    } else {
      with_a_p[j]=accstr[j];
    }
    j++;
  }
  with_a_p[j] = 0; // end the string

  // Combining all of the strings (c really sucks at strings)
  char final[50],line[2],extension[4];
  strcpy(final,"Optimum_2_");
  strcpy(line,"_");
  strcpy(extension,".txt");

  strcat(final,clearstr);
  strcat(final,line);
  strcat(final,with_a_p);
  strcat(final,extension);

  // finally making the file
  FILE *f = fopen(final, "w");
  if (f == NULL)
  {
    printf("Error opening file!\n");
    exit(1);
  }

  SC.velX=v_S*cos(theta_S)+dxfast;
  SC.velY=v_S*sin(theta_S)+dyfast;

  t=1.0;
  while(t<=tn)
  {
    euler(&SC,SC,&Moon,Moon,Earth,dt);
    change(&d_ES,distance(SC,Earth));
    if ( d_ES<rE ) {
      break;
    }
    t=t+dt;
    double trajectory[7]={t,SC.posX,SC.posY,Moon.posX,Moon.posY,Earth.posX,Earth.posY};
    for (int i = 0; i < 7; i++) {
      fprintf(f, "%lf ", trajectory[i]);
    }
    fprintf(f, "\n");
  }

}

int main(int argc, char **argv)
{
  clock_t tic = clock();
  // Initialize structs
  struct body SC,Moon,Earth;

  // find initial conditions
  double theta_S,theta_M,d_ES,d_EM,d_SM,deg2rad,v_S,v_M;
  deg2rad=PI/180.0;
  theta_S=deg2rad*50.0;
  theta_M=deg2rad*42.5;
  d_ES=340000000.0;
  d_EM=384403000.0;
  v_S=1000.0;
  v_M=sqrt((G*mE*mE)/((mE+mM)*d_EM));

  SC.posX=d_ES*cos(theta_S);
  SC.posY=d_ES*sin(theta_S);
  SC.velX=v_S*cos(theta_S);
  SC.velY=v_S*sin(theta_S);

  Moon.posX=d_EM*cos(theta_M);
  Moon.posY=d_EM*sin(theta_M);
  Moon.velX=(-1)*v_M*sin(theta_M);
  Moon.velY=v_M*cos(theta_M);

  Earth.posX=0.0;
  Earth.posY=0.0;
  Earth.velX=0.0;
  Earth.velY=0.0;

  double acc,clear,dt;
  acc=atof(argv[3]);
  clear=atof(argv[2]);
  dt=10;
  if (atoi(argv[1])==1) {
    objective1(SC,Moon,Earth,theta_S,v_S,dt,clear,acc);
  }
  else if (atoi(argv[1])==2) {
    objective2(SC,Moon,Earth,theta_S,v_S,dt,clear,acc);
  }
  else {
    printf("I'm Sorry Dave, I'm afriad I can't do %s\n",argv[1]);
  }

  clock_t toc = clock();
  double runtimes = (double)(toc - tic) / CLOCKS_PER_SEC;
  printf("Time to run program: %lf seconds\n", runtimes);

  return 0;
}
