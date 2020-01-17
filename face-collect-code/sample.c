#include <stdint.h>
#include <stdio.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/sysinfo.h>

void get_systeminfo()
{
  struct sysinfo info;

  if (sysinfo(&info) == 0)
  {
          printf("loadaverage1: %lu\n",info.loads[0]);
          printf("freeram: %lu\n",info.freeram);
          printf("procs: %lu\n",info.procs);
  }
}

void milliseconds_sleep(unsigned long mSec){
    struct timeval tv;
    tv.tv_sec=mSec/1000;
    tv.tv_usec=(mSec%1000)*1000;
    int err;
    do{
       err=select(0,NULL,NULL,NULL,&tv);
    }while(err<0 && errno==EINTR);
}

int main()
{
        int i = 0;
        for(i=0;i<=14000000;i++)
        {
                get_systeminfo();
                //milliseconds_sleep(1);
        }
        return 0;
}
