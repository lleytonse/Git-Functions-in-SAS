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

%let oldCommit  = 3e20c3cce3396d710959a7cba0f57aa03e0f757b;
%let newCommit  = b22750cef7ab21ec0c9978915063d1d7e5b5f4f7;
%let diffFile   = /home/[userpath]/diff_content.txt;
%let threshold  = 0.10;   /* Setting a flag to hold model from produciton */

/* Run GIT_DIFF between the two commit IDs */
data _null_;
   n = git_diff(
      "&repoPath.",
      "&oldCommit.",
      "&newCommit."
   );
   call symputx('diffCount', n);
   put n=;

   /* Write to file using GIT_DIFF_TO_FILE */
   if n > 0 then do;
      rc = git_diff_to_file(
         1,
         "&repoPath.",
         "&oldCommit.",
         "&newCommit.",
         "&diffFile."
      );
      put rc=;
   end;
run;

/* Parse the created file and calculate importance change in 'Differential_pressure'*/
data diff_check;
   infile "&diffFile." lrecl=1000 truncover;
   length variable $50 line $1000 value $100 type $20;
   retain in_block 0 old_rel new_rel . variable 'Differential_pressure';
   input line $char1000.;

   if index(line, 'Differential_pressure') then in_block = 1;

   if index(line, '"type":"deletion"') then type='deletion';
   else if index(line, '"type":"addition"') then type='addition';
   else if index(line, '"type":"context"') then type='context';
   else type='other';

   if in_block and index(line, 'relative_importance') then do;
      value = prxchange('s/.*relative_importance":\s*([0-9.]+).*/$1/', 1, line);

      if type='deletion' then old_rel = input(value, best32.);
      if type='addition' then new_rel = input(value, best32.);
   end;

   if not missing(old_rel) and not missing(new_rel) then do;
      abs_change = old_rel - new_rel;
      pct_drop   = divide(old_rel - new_rel, old_rel);
      flag_hold  = (pct_drop > &threshold.);
      output;
      stop;
   end;
run;

/* Output to ODS */
title "Variable Importance Change Check";
proc print data=diff_check noobs label;
   var variable old_rel new_rel abs_change pct_drop flag_hold;
   label variable = "Variable" old_rel = "Relative Importance (old)" new_rel = "Relative Importance (new)" 
   abs_change = "Absolute Change" pct_drop = "Percent Drop" flag_hold = "Hold from Production";
   format pct_drop percent8.2;
run;
title;