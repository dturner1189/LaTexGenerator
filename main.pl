#!/usr/bin/perl -w
# David Turner

# Strict and warnings prevent compilation errors and help debugging.
use strict;
use warnings;

use File::Copy;

# Define the number of arguments passed in.
my $number_args = @ARGV;
my $p_file;

main_routine();

sub main_routine {
    determine_input_method();
    generate_all();
    success_exit();
}

sub determine_input_method {
    if ( $number_args == 1 ) {
        my $path = $ARGV[0];

        unless(chdir($path)) {
            mkdir($path, 0700);
            chdir($path) or die failure_exit();
        }
    }
    else {
        my $path = "project";
        mkdir($path, 0700);
        chdir($path) or die failure_exit();
    }

}

sub generate_all {
    create_pics();
    create_bib();
    create_paper();
    create_compilation_script();
}

sub create_pics {
    my $project_dir;

    my $PICS = "pics";
    mkdir($PICS, 0700);

    my $source_dir = "../pics_t";


    if (-e "../project" and -d "../project") {
        $project_dir = "../project/pics";
        $p_file = "../project";
    }
    else {
        my $temp = $ARGV[0];
        $p_file = "../".$temp;
        $project_dir = "../".$temp."/pics";
    }


    opendir(my $DIR, $source_dir) || die "can't opendir $source_dir: $!";
    my @files = readdir($DIR);

    foreach my $t (@files) {

        if(-f "$source_dir/$t" ) {
            #print "copy $source_dir/$t  into $project_dir/$t.\n";
            #Check with -f only for files (no directories)
            copy "$source_dir/$t", "$project_dir/$t";
        }
    }

    closedir($DIR);
}

sub create_bib {
    my $file = "refs.bib";

    unless(open FILE, '>'.$file) {
        die "\nUnable to create $file\n";
    }

    print FILE
"\@ARTICLE{Citation1,
\tauthor    = \"Free Software Foundation\",
\ttitle     = \"GNU Make\",
\tjournal   = \"https://www.gnu.org/software/make/\",
\tyear      = 2016,
}";

    print FILE
"\@ARTICLE{Citation2,
\tauthor    = \"David P. Turner\",
\ttitle     = \"How to make a Latex Document\",
\tjournal   = \"https://www.github.com/dturner1189\",
\tyear      = 2019,
}";


    close FILE;
}


sub create_compilation_script {
    my $file = "run.sh";

    unless(open FILE, '>'.$file) {
        die "\nUnable to create $file\n";
    }

    print FILE
    "\#!/bin/bash
function RemoveFiles {
    clear
    if [ -e \"paper.aux\" ]; then
        rm ./paper.aux
    fi;
    if [ -e \"paper.bbl\" ]; then
        rm ./paper.bbl
    fi;
    if [ -e \"paper.blg\" ]; then
        rm ./paper.blg
    fi;
    if [ -e \"paper.log\" ]; then
        rm ./paper.log
    fi;
    if [ -e \"paper.pdf\" ]; then
        rm ./paper.pdf
    fi;
    if [ -e \"missfont.log\" ]; then
        rm ./missfont.log
    fi;
}

function Compile {
    pdflatex paper.tex > /dev/null 2>&1
    bibtex paper > /dev/null 2>&1
    pdflatex paper.tex > /dev/null 2>&1
    pdflatex paper.tex > /dev/null 2>&1
}

function CheckOutput {
    if [ -e \"paper.pdf\" ]; then
        chmod 700 ./paper.pdf
    else
        echo -e \"\\n\"
        read -p \" Err [No PDF]  Press any key [Exit]\" DONE
        clear
        exit 0
    fi
}

function Display {
    okular ./paper.pdf > /dev/null 2>&1
    echo -e \"\\n\"
    read -p \" Done..  Press any key [Exit]\" DONE
}

function Main {
    RemoveFiles
    Compile
    CheckOutput
    Display
    RemoveFiles
}

Main
exit 1

";

    chmod 0755, $file;
    close FILE;
}


# Somthings gone wrong, Exit program.
sub failure_exit {
    print "LaTex Project Not Created.";
    print "Error: Exiting program with status code 1.\n";
    exit 1;
}

# Everything went smoothly, exit successfully.
sub success_exit {
    print "\nLaTex Project Created Successfully.\n";
    exit 0;
}


sub create_paper {
    my $file = "paper.tex";

    unless(open FILE, '>'.$file) {
        die "\nUnable to create $file\n";
    }

    print FILE "
    \\documentclass[ebook,12pt,oneside,openany]{article}
    \\usepackage[utf8x]{inputenc}
    \\usepackage[english]{babel}
    \\usepackage{url}
    \\usepackage{graphicx}
    \\usepackage{subcaption}
    \\usepackage{sidecap}
    \\usepackage{titlesec}
    \\usepackage{wrapfig}
    \\usepackage{listings}

    \\usepackage{titling}

    \\usepackage[legalpaper, portrait, margin=1in, top=3.75cm, bottom=3.50cm,]{geometry}


    % Keywords command
    \\providecommand{\\keywords}[1]
    {
      \\small
      \\textbf{\\textit{Keywords---}} #1
    }

    \\setlength{\\parskip}{1em}

    \\linespread{1.8}
    \\setlength{\\droptitle}{5em}

    \\author{
        Author A. Writer\\\\
        \\texttt{AuthorA\@university.edu}
        \\and
        Research State University\\\\
        Department of Sciences
    }

    \\title{Documents Title; How to Make a LaTex Document.}

    \\date{\\vspace{-5ex}}

    \\begin{document}

    \\maketitle



    \\begin{abstract}
    \\textit{In hac habitasse platea dictumst. Aenean tempor interdum lectus, in ultrices magna fringilla at. Curabitur nisi dolor, consectetur in aliquam vitae, suscipit sed dui. Quisque vel eros pulvinar, tempor urna a, venenatis risus. Nunc blandit viverra ante, eget aliquam leo pulvinar et. Cras id ante est. Aliquam tincidunt, nisl sed convallis dapibus, mi purus dignissim nisi, vitae eleifend libero leo vel ligula. Morbi condimentum ipsum vel urna ultrices condimentum. }
    \\end{abstract}

    \\keywords{Latex, Bibliography, Create, Project}

    \\newpage



    \\section{Introduction}

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer elit nulla, interdum vel ornare nec, consequat imperdiet orci. Duis pharetra nulla mauris, vitae egestas risus efficitur at. Suspendisse euismod quis urna dignissim ullamcorper. Suspendisse a erat placerat, convallis sapien in, congue est. Maecenas vitae magna lacinia, rhoncus metus ac, blandit purus. Nulla luctus facilisis elit, convallis auctor erat pellentesque quis. In hac habitasse platea dictumst. Aenean tempor interdum lectus, in ultrices magna fringilla at. Curabitur nisi dolor, consectetur in aliquam vitae, suscipit sed dui. Quisque vel eros pulvinar, tempor urna a, venenatis risus. Nunc blandit viverra ante, eget aliquam leo pulvinar et. Cras id ante est. Aliquam tincidunt, nisl sed convallis dapibus, mi purus dignissim nisi, vitae eleifend libero leo vel ligula. Morbi condimentum ipsum vel urna ultrices condimentum. Nunc pretium iaculis ante, porttitor ullamcorper justo lacinia sed. Donec nec nisl ornare, consectetur odio vel, vulputate arcu.



    \\begin{wrapfigure}{l}{5.5cm}
    \\caption{\\textbf{\\emph{Examples of Accepted Syntax.}}}\\label{wrap-fig:1}
    \\includegraphics[width=5.5cm]{./pics/first.png}
    \\end{wrapfigure}

    Nulla at dictum ex. Etiam in lacus sed tellus ullamcorper sagittis a vitae risus. Suspendisse pharetra tellus quis commodo aliquam. Suspendisse tempus augue a fringilla imperdiet. Proin blandit aliquam bibendum. Praesent semper, dolor in mollis facilisis, dolor sem efficitur augue, et ultrices est massa et libero. Duis vel felis nec risus scelerisque dictum eget id tortor. Duis nulla mauris, gravida vel maximus at, tincidunt ac odio. Aenean ullamcorper sodales vulputate. Etiam sed sagittis risus. Mauris a leo hendrerit, semper enim id, dignissim sem. Donec lacinia bibendum tincidunt. Vestibulum cursus mauris velit, quis aliquam libero tincidunt vel. Duis vestibulum cursus mauris id convallis. Fusce scelerisque lobortis nisi, sed laoreet risus dictum sit amet. Donec ut dolor nisl. \\cite{Citation1}.



    \\section{Second Part}

    Vivamus vestibulum lacus egestas efficitur lobortis. Nam cursus velit at dui molestie, imperdiet accumsan lacus facilisis. Nullam eu augue malesuada sem finibus hendrerit sed non lorem. Quisque imperdiet eu orci molestie consectetur. Donec quis augue justo. Nulla facilisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer quis faucibus nibh, quis aliquam mauris. Nullam id tellus et lorem posuere consequat. Praesent lacus metus, lacinia ac imperdiet sed, efficitur ultrices magna.\\cite{Citation2}.

    \\begin{wrapfigure}{r}{5.5cm}
    \\caption{\\textbf{\\emph{Examples of Accepted Syntax.}}}\\label{wrap-fig:1}
    \\includegraphics[width=5.5cm]{./pics/second.png}
    \\end{wrapfigure}

    Curabitur non eleifend ligula, et pretium urna. Duis posuere nisl tellus, ut lacinia arcu faucibus vel. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In cursus libero sed neque venenatis, eu suscipit tellus consectetur. Quisque imperdiet mauris sed lacus facilisis, ut facilisis eros porta. Praesent vitae euismod nulla. Proin in felis tincidunt, scelerisque quam at, sagittis augue. Ut tempor tellus turpis, ac placerat ex fermentum vel. Mauris vehicula est tincidunt metus porttitor venenatis. Nulla ullamcorper nisi vel ante venenatis, vel dignissim nisi aliquam. Nullam nec magna venenatis, fermentum leo vitae, mollis ante. Sed egestas tellus sit amet lectus tincidunt, ac pharetra dui rhoncus. Mauris in ornare quam, id pellentesque ligula.



    \\section{Other Important Issues}

    Ut fermentum dignissim eros, finibus imperdiet metus condimentum ut. Sed ac metus pharetra, consequat felis vitae, dictum purus. Cras ullamcorper libero et leo dignissim feugiat. Nullam gravida maximus erat, luctus tincidunt dui rhoncus eu. Nulla suscipit metus vel sem convallis pellentesque. Donec vehicula odio vel metus placerat aliquam. Sed eu finibus erat. Pellentesque dapibus mauris quis nisl dictum sodales. Nunc mollis suscipit porta.


    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer elit nulla, interdum vel ornare nec, consequat imperdiet orci. Duis pharetra nulla mauris, vitae egestas risus efficitur at. Suspendisse euismod quis urna dignissim ullamcorper. Suspendisse a erat placerat, convallis sapien in, congue est. Maecenas vitae magna lacinia, rhoncus metus ac, blandit purus. Nulla luctus facilisis elit, convallis auctor erat pellentesque quis. In hac habitasse platea dictumst. Aenean tempor interdum lectus, in ultrices magna fringilla at. Curabitur nisi dolor, consectetur in aliquam vitae, suscipit sed dui. Quisque vel eros pulvinar, tempor urna a, venenatis risus. Nunc blandit viverra ante, eget aliquam leo pulvinar et. Cras id ante est. Aliquam tincidunt, nisl sed convallis dapibus, mi purus dignissim nisi, vitae eleifend libero leo vel ligula. Morbi condimentum ipsum vel urna ultrices condimentum. Nunc pretium iaculis ante, porttitor ullamcorper justo lacinia sed. Donec nec nisl ornare, consectetur odio vel, vulputate arcu.

    \\begin{wrapfigure}{l}{3.5cm}
    \\caption{\\textbf{\\emph{Examples of Accepted Syntax.}}}\\label{wrap-fig:1}
    \\includegraphics[width=3.5cm]{./pics/third.png}
    \\end{wrapfigure}

    Nulla at dictum ex. Etiam in lacus sed tellus ullamcorper sagittis a vitae risus. Suspendisse pharetra tellus quis commodo aliquam. Suspendisse tempus augue a fringilla imperdiet. Proin blandit aliquam bibendum. Praesent semper, dolor in mollis facilisis, dolor sem efficitur augue, et ultrices est massa et libero. Duis vel felis nec risus scelerisque dictum eget id tortor. Duis nulla mauris, gravida vel maximus at, tincidunt ac odio. Aenean ullamcorper sodales vulputate. Etiam sed sagittis risus. Mauris a leo hendrerit, semper enim id, dignissim sem. Donec lacinia bibendum tincidunt. Vestibulum cursus mauris velit, quis aliquam libero tincidunt vel. Duis vestibulum cursus mauris id convallis. Fusce scelerisque lobortis nisi, sed laoreet risus dictum sit amet. Donec ut dolor nisl. \\cite{Citation1}.




    \\section{Conclusion}

    Vivamus vestibulum lacus egestas efficitur lobortis. Nam cursus velit at dui molestie, imperdiet accumsan lacus facilisis. Nullam eu augue malesuada sem finibus hendrerit sed non lorem.


    Quisque imperdiet eu orci molestie consectetur. Donec quis augue justo. Nulla facilisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer quis faucibus nibh, quis aliquam mauris. Nullam id tellus et lorem posuere consequat. Praesent lacus metus, lacinia ac imperdiet sed, efficitur ultrices magna.\\cite{Citation2}.


    Curabitur non eleifend ligula, et pretium urna. Duis posuere nisl tellus, ut lacinia arcu faucibus vel. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In cursus libero sed neque venenatis, eu suscipit tellus consectetur. Quisque imperdiet mauris sed lacus facilisis, ut facilisis eros porta. Praesent vitae euismod nulla. Proin in felis tincidunt, scelerisque quam at, sagittis augue. Ut tempor tellus turpis, ac placerat ex fermentum vel. Mauris vehicula est tincidunt metus porttitor venenatis. Nulla ullamcorper nisi vel ante venenatis, vel dignissim nisi aliquam. Nullam nec magna venenatis, fermentum leo vitae, mollis ante. Sed egestas tellus sit amet lectus tincidunt, ac pharetra dui rhoncus. Mauris in ornare quam, id pellentesque ligula.

    \\begin{wrapfigure}{r}{5.5cm}
    \\caption{\\textbf{\\emph{Examples of Accepted Syntax.}}}\\label{wrap-fig:1}
    \\includegraphics[width=5.5cm]{./pics/fourth.png}
    \\end{wrapfigure}

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer elit nulla, interdum vel ornare nec, consequat imperdiet orci. Duis pharetra nulla mauris, vitae egestas risus efficitur at. Suspendisse euismod quis urna dignissim ullamcorper. Suspendisse a erat placerat, convallis sapien in, congue est. Maecenas vitae magna lacinia, rhoncus metus ac, blandit purus. Nulla luctus facilisis elit, convallis auctor erat pellentesque quis. In hac habitasse platea dictumst. Aenean tempor interdum lectus, in ultrices magna fringilla at. Curabitur nisi dolor, consectetur in aliquam vitae, suscipit sed dui. Quisque vel eros pulvinar, tempor urna a, venenatis risus. Nunc blandit viverra ante, eget aliquam leo pulvinar et. Cras id ante est. Aliquam tincidunt, nisl sed convallis dapibus, mi purus dignissim nisi, vitae eleifend libero leo vel ligula. Morbi condimentum ipsum vel urna ultrices condimentum. Nunc pretium iaculis ante, porttitor ullamcorper justo lacinia sed. Donec nec nisl ornare, consectetur odio vel, vulputate arcu.





    \\newpage
    \\bibliography{refs}
    \\bibliographystyle{plain}


    \\end{document}


    ";

}
