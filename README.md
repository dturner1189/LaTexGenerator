# Automatic LaTex Generation

This is a program designed to create a pre-formated LaTex project directory. The created directory will contain a Tex file where the user can put their desired text, as well as a bibliography file named refs.bib that the user can again customize for their needs. In addition to those files needed for paper writing this program will also generate a directory for pictures to be inserted into the document with filler pictures for reference. Lastly this program will generate a compilation script needed to compile and run the users LaTex documents.

## What This Is

This is intended to be used as an aid to get a quick start in writing LaTex documents. This should eliminate most of the start time to creating a beautiful pdf document.

This program does support file traversals on a UNIX system, so you can use ../.. in naming conventions if you know where you want the project to go. Otherwise the project folder will be created where you ran this perl file. Yes, the project folder can simply be copy pasted elsewhere if you want to move it.

### Running

Unix users proceed with the following commands in your terminal:

For a default project (named 'project'):
```
$ ./run.sh
or
$ ./main.pl
```
For a project named by user (your choice):
```
$ ./main.pl <project name>

ex:
$ ./main.pl Assignment2
```

Windows users will need to compile themselves. Simply run the perl script named "main.pl".

Once the project folder has been created users need only run the "run.sh" script found inside of their NEW project directory to compile and view their generated pdf's.


### Manifest

```
run.sh
```
Compilation instructions for users machines.


```
main.pl
```
Instruction set for program. Single and only file involved in the actual program running.

```
/pics_t
```
This is a directory that stores filler pictures for the user to better gauge their formatting. 


## Authors

* **David P. Turner** - https://github.com/dturner1189
