

## Todo
  * try to see if we can omit specifying both hostname and myid -- maybe infer myid from processing server list (first server gets id 0) and then see if hostname in question resolves to oneself.
  * **ATM** - if both myid and serverlist should be defined, fail on the absense of a myid PROVIDED the serverlist is defined (otherwise, accept running in standalone mode)