These data files are sampling with sample.c (using syscall to get "sysinfo")

The time taken by sampling is 9.9s

The sampling times is 14000000

The information contains
```
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
```
And we find the snp 119762175 may locate on
start is  2219087
target is  2228618
end is  2247050

start is  1942621
target is  1951353
end is  1969514

dstart is  2191824
target is  2201870
end is  2222659

start is  2392760
target is  2402806
end is  2422513

start is  2313390
target is  2322973
end is  2341830

In pic-HGdata is not resize with (-1,1), needs to try ...
