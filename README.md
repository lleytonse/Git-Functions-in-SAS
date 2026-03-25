# GitFunctions
## Overview

A practical starter repository that explores a lightweight model governance/versioning workflow using Git Functions. 

### Prerequisites

An active SAS 9 / SAS Viya license and environment

### Installation

Start your SAS®9 or SAS® Viya® instance and clone the repository into the root of your workspace:
`git clone https://github.com/lleytonse/Git-Functions-in-SAS.git`

*Please note: if using SAS®9 the modeling sections will need modifications to the code, but the Git Functions will still work*

### Quick Resource Links
- [Git Functions Documentation](https://documentation.sas.com/doc/en/pgmsascdc/v_073/lefunctionsref/n1mlc3f9w9zh9fn13qswiq6hrta0.htm)
- [Cloning and Opening a Git Repository (SAS Studio)](https://documentation.sas.com/doc/en/webeditorcdc/v_065/webeditorug/p08km3y02yo0fen10y30gqoxgyxf.htm)
- [How to Use Git in SAS (Youtube)](https://www.youtube.com/watch?v=0eVhllpj11A)
- [SAS Communities Articles](https://communities.sas.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&q=Git%20functions)
- [Git Functions – SAS Studio Custom Steps](https://github.com/sassoftware/sas-studio-custom-steps/blob/main/Git%20-%20Stage%2C%20Commit%2C%20Pull%20and%20Push%20Changes/README.md)


## License & Data

This demo uses an adapted [Hochschule Esslingen - University of Applied Sciences](https://www.osicild.org/kaggle01.html) data set licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

The original data set was taken from [this location](https://doi.org/10.34740/kaggle/dsv/8684322), and the following changes were made:

- N/A

While this example focuses on modeling, feel free to adapt the examples to another dataset. SAS provides more than 200 data sets in the Sashelp library. These data sets are available for you to use for examples and for testing code. For example, the following step uses the Sashelp.LeuTrain data set:

```sas
title 'Leukemia Training Data';
proc contents data=sashelp.LeuTrain varnum;
   ods select position;
run;
```

You do not need to provide a DATA step to use Sashelp data sets.

The following steps list all the data sets that are available in Sashelp:

```sas
ods select none;
proc contents data=sashelp._all_;
   ods output members=m;
run;
ods select all;

proc print;
   where memtype = 'DATA';
run;
```


## Contact

- Lleyton Seymour (lleyton.seymour@sas.com)


## Change Log

- Version 1.0.0 (27MAR2026)
  - Initial release on GitHub