#!/bin/bash
# Test code for syspro2023 kadai1
# Written by Shinichi Awamoto
# Edited by PENG AO

state=0
warn() { echo $1; state=1; }
dir=$(mktemp -d XXXX)
trap "rm -rf $dir" 0

kadai-a() {
    if [ -d kadai-a ]; then
        cp -r kadai-a $dir
        pushd $dir/kadai-a > /dev/null 2>&1

        if [ ! -f Makefile ]; then
            warn "kadai-a: missing Makefile."
        fi
        
        if [ -f kadai-a ]; then
            warn "kadai-a: Do not include the binary(kadai-a) in your submissions!"  
        fi

        make kadai-a > /dev/null 2>&1

        if [ ! -f kadai-a ]; then
            warn "kadai-a: Failed to generate the binary(kadai-a) with '$ make kadai-a'"
        fi

        make clean > /dev/null 2>&1

        if [ -f kadai-a ]; then
            warn "kadai-a: Failed to remove the binary(kadai-a) with '$ make clean'."
        fi

        if [ ! -z "`find . -name \*.o`" ]; then
            warn "kadai-a: Failed to remove object files(*.o) with '$ make clean'."
        fi

        if [ `grep '\-Wall' Makefile | wc -l` -eq 0 ]; then
            warn "kadai-a: Missing '-Wall' option."
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-a: No 'kadai-a' directory!"
    fi
}

kadai-b() {
    if [ -d kadai-b ]; then
        cp -r kadai-b $dir
        cp coreutils-8.9.tar.gz $dir
        pushd $dir/kadai-b > /dev/null 2>&1

        export LC_ALL=C
        tar xf ../coreutils-8.9.tar.gz

        if [ ! -f sort.sh ]; then
            warn "kadai-b: Missing 'sort.sh'."
        fi

        ./sort.sh > /dev/null 2>&1

        if [ ! -f result.txt ]; then
            warn "kadai-b: Failed to generate 'result.txt' with '$ ./sort.sh'."
        elif [ `cat result.txt | wc -l` -eq 0 ]; then
            warn "kadai-b: 'result.txt' is empty!"
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-b: No 'kadai-b' directory!"
    fi
}

kadai-c() {
    if [ -d kadai-c ]; then
        cp -r kadai-c $dir
        pushd $dir/kadai-c > /dev/null 2>&1

        tmpfile=$(mktemp XXXX)
        wget http://www.pf.is.s.u-tokyo.ac.jp/syspro/static/1.pdf -O $tmpfile > /dev/null 2>&1

        if [ ! -f concatenation.sh ]; then
            warn "kadai-c: Missing 'concatenation.sh'."
        fi

        ./concatenation.sh > /dev/null 2>&1

        if [ ! -f 1.pdf ]; then
            warn "kadai-c: Failed to generate '1.pdf' with '$ ./concatenation.sh'."
        elif [ ! -z "`diff $tmpfile 1.pdf`" ]; then
            warn "kadai-c: Is your 1.pdf valid? (detect diff)"
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-c: No 'kadai-c' directory!"
    fi
}

kadai-d() {
    if [ -d kadai-d ]; then
        cp -r kadai-d $dir
        pushd $dir/kadai-d > /dev/null 2>&1

        if [ ! -f convert.sh ]; then
            warn "kadai-d: Missing 'convert.sh'."
        fi

        ./convert.sh > /dev/null 2>&1

        if [ ! -z "`find . -name \*.cpp`" ]; then
            warn "kadai-d: Did you convert *.cpp to *.cc?"
        else
            if [ `grep 'NEET the 3rd' *.cc | wc -l` -ne 0 ]; then
                warn "kadai-d: Did you replace 'NEET the 3rd' to your name?"
            fi
            if [ `grep 'neet3@example.com' *.cc | wc -l` -ne 0 ]; then
                warn "kadai-d: Did you replace 'neet3@example.com' to your email address?"
            fi
            if [ `grep " $" *.cc | wc -l` -ne 0 ]; then
                warn "kadai-d: Did you remove all trailing whitespaces?"
            fi
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-d: No 'kadai-d' directory!"
    fi
}

kadai-e() {
    if [ -d kadai-e ]; then
        cp -r kadai-e $dir
        pushd $dir/kadai-e > /dev/null 2>&1

        if [ ! -f output.sh ]; then
            warn "kadai-e: Missing 'output.sh'."
        fi

        ./output.sh > /dev/null 2>&1

        if [ ! -f cat.txt ]; then
            warn "kadai-e: Failed to generate 'cat.txt' with '$ ./output.sh'."
        fi

        if [ ! -f strace.txt ]; then
            warn "kadai-e: Failed to generate 'strace.txt' with '$ ./output.sh'."
        fi

        if [ ! -f all.txt ]; then
            warn "kadai-e: Failed to generate 'all.txt' with '$ ./output.sh'."
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-e: No 'kadai-e' directory!"
    fi
}

kadai-f() {
    if [ -d kadai-f ]; then
        cp -r kadai-f $dir
        pushd $dir/kadai-f > /dev/null 2>&1

        if [ ! -f report.txt ]; then
            warn "kadai-f: Missing report.txt."
        fi

        popd > /dev/null 2>&1
    else
        warn "kadai-f: No 'kadai-f' directory!"
    fi
}

echo "#############################################"
echo "Running tests..."
if [ -z $1 ] || [ $1 = "a" ]; then kadai-a; fi
if [ -z $1 ] || [ $1 = "b" ]; then kadai-b; fi
if [ -z $1 ] || [ $1 = "c" ]; then kadai-c; fi
if [ -z $1 ] || [ $1 = "d" ]; then kadai-d; fi
if [ -z $1 ] || [ $1 = "e" ]; then kadai-e; fi
if [ -z $1 ] || [ $1 = "f" ]; then kadai-f; fi
if [ $state -eq 0 ]; then
    echo "All tests have past!"
fi
echo "#############################################"
exit $state
