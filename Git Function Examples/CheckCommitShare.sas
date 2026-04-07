/* Clone to a temp space (for illustrative purposes) */
options dlcreatedir;
%let repoPath = %sysfunc(getoption(WORK))/ollama;
libname repo "&repoPath.";
libname repo clear;

/* Fetch latest code from repo */
data _null_;
 rc = git_clone(
   "https://github.com/ollama/ollama.git",
   "&repoPath.");
 put rc=;
run;

/*  Build out 'commit_history' dataset  */
data commit_history;
  length 
    time_char $100
    message   $300
    author    $200
    email     $200
    commit_id $100
  ;
  length time 8 n 8 i 8 rc 8;
  format time datetime20.;

  n = git_commit_log("&repoPath.");

  do i = 1 to n;

    rc = git_commit_get(i, "&repoPath.", "message", message);
    rc = git_commit_get(i, "&repoPath.", "time", time_char);
    rc = git_commit_get(i, "&repoPath.", "author", author);
    rc = git_commit_get(i, "&repoPath.", "id", commit_id);
    time = input(strip(time_char), best32.);
    if not missing(time) then time = time + "01JAN1970:00:00:00"dt;

    output;
  end;
run;

data commit_history;
  set commit_history;
  length contributor $200;
  if not missing(author) then contributor = strip(author);
  else contributor = "UNKNOWN";
run;

/* Summarize commit counts and contribution percentage */
proc sql;
  create table top_contributors as
  select 
    contributor,
    count(*) as commit_count,
    calculated commit_count / 
      (select count(*) from commit_history) as pct_commits format=percent8.1
  from commit_history
  group by contributor
  order by commit_count desc;
quit;

/* Output to ODS */
title "Top Contributors to 'ollama' Repo";
proc print data=top_contributors (obs=10) noobs label ;
  label 
    contributor = "Contributor"
    commit_count = "Commits"
    pct_commits = "Percent of Total Commits";
run;
title;
