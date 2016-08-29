#include <stdio.h>
#include <math.h>
#include <stdlib.h>

double Phi(double x)
{
  long double s=x,t=0,b=x,q=x*x,i=1;
  while(s!=t) s=(t=s)+(b*=q/(i+=2));
  return .5+s*exp(-.5*q-.91893853320467274178L);
}

double cPhi(double x)
{
  long double R[9]=
  {1.25331413731550025L, .421369229288054473L,.236652382913560671L,
  .162377660896867462L,  .123131963257932296L,.0990285964717319214L,
  .0827662865013691773L,.0710695805388521071L,.0622586659950261958L};
  int i,j=.5*(fabs(x)+1);
  long double pwr=1,a=R[j],z=2*j,b=a*z-1,h=fabs(x)-z,s=a+h*b,t=a,q=h*h;
  for(i=2;s!=t;i+=2) {a=(a+z*b)/i; b=(b+z*a)/(i+1); pwr*=q; s=(t=s)+pwr*(a+h*b);}
  s=s*exp(-.5*x*x-.91893853320467274178L);
  return (double) 2.*s;
}

int main(int argc, char *argv[])
{
  if(argc==2) printf("%.16lf\n",cPhi(atof(argv[1])));
  return 0;
}
