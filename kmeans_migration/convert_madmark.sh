#!/bin/bash

# Set DEST to be the destination directory where the tests will be placed;
# probably shouldn't be madlib/tests in case of overwriting or whatever
DEST="$HOME/workspace/tests/kmeans_migration"
# Set MTT_DIR to the directory containing madmark_to_tinc.py
MTT_DIR="$HOME/workspace/tests/kmeans_migration"

cd $DEST
mkdir -p "Madmark_Tests"
cd "Madmark_Tests"
BASE_DIR=`pwd`


for xmlfile in "casespec/kmeans_rewrite_kmeans.xml" "casespec/kmeans_rewrite_kmeanspp.xml" "casespec/kmeans_rewrite_kmeansrandom.xml" "casespec/kmeans_rewrite_seeding.xml" "casespec/kmeans_rewrite_kmeans_perf.xml" "casespec/kmeans_rewrite_kmeanspp_perf.xml" "casespec/kmeans_rewrite_kmeansrandom_perf.xml"
do
    filename=$(basename "$xmlfile")
    filename="${filename%.*}"
    capsname=`echo "$filename"`
    mkdir -p "$capsname"
    cd "$capsname"
    python "$MTT_DIR/madmark_to_tinc.py" "$xmlfile" > "${capsname}Test.py"
    mkdir -p "expected_input"
    mkdir -p "expected_output"
    touch "__init__.py"

    cd "$BASE_DIR"
done
