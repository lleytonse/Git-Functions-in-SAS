.
.
/* Variable handling from previous step */
.
.


/* Configure SMTP to send email */
options emailsys=smtp
        emailhost="mailhost.example.com"
        emailport=25;

filename alertmail email
   to=("receiving-team@example.com")
   from="no-reply@example.com"
   subject="Model Retraining Alert: Updated Variable Importance";

/* Generate email body text*/
data _null_;
  file alertmail;

  put "Hello Team,";
  put;
  put "The model retraining process completed and the repository was updated.";
  put;
  put "Flow Details";
  put "------------";
  put "Flow Name    : &flow_name.";
  put "Model Name   : &model_name.";
  put "Run Time     : &run_date.";
  put "Push Status  : &push_status.";
  put "Commit ID    : &commit_id.";
  put "Commit Msg   : &commit_msg.";
  put;
  put "Updated Variable Importance";
  put "---------------------------";
  put "Variable                  Importance      Relative Importance";
  put "------------------------------------------------------------";
  put "&vi_1_name.              &vi_1_abs.          &vi_1_rel.";
  put "&vi_2_name.              &vi_2_abs.          &vi_2_rel.";
  put "&vi_3_name.              &vi_3_abs.          &vi_3_rel.";
  put "&vi_4_name.              &vi_4_abs.          &vi_4_rel.";
  put "&vi_5_name.              &vi_5_abs.          &vi_5_rel.";
  put;
  put "This message was sent automatically from SAS.";
run;