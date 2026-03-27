/* Clone to a temp space (for illustrative purposes) */
options dlcreatedir;
%let repoPath = %sysfunc(getoption(WORK))/Git-Functions-in-SAS;
libname repo "&repoPath.";
libname repo clear;
 
/* Fetch latest code from repo */
data _null_;
 rc = git_clone(
   "https://github.com/lleytonse/Git-Functions-in-SAS.git",
   "&repoPath.");
 put rc=;
run;

/*  Build out 'commits' dataset  */
data commits (keep=time message);
  length time_char $ 100 time 8 message $ 100 n 8;
  n = git_commit_log("&repoPath.");
  format time datetime20.;

  do i=1 to n;
    rc = git_commit_get(i,"&repoPath.",'message',message);
    rc = git_commit_get(i,"&repoPath.",'time',time_char);
    time = trim(time_char);
    time = time + "01jan1970 0:0:0"dt;
    output;
  end;
run;

/* Output to ODS */
title "Latest commits to 'Git-Functions-in-SAS' repo";
proc print data=commits;
run;
title;