CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'
cd student-submission 
cp ../TestListExamples.java ./ 
cp -r ../lib ./
#JAVAPATH=$(find . | grep "/ListExamples.java")
#echo $JAVAPATH
JAVAPATH="ListExamples.java"
if [[ -f "$JAVAPATH" ]]
then
    echo "Found ListExamples.java"
else
    echo "Could not find ListExamples.java"
    exit 1
fi
cp $JAVAPATH ./
CRESULT="$(javac -cp $CPATH *.java 2>&1)"
if [[  $? != 0  ]]
then
    echo "Compilation failed: $CRESULT"   
    exit 1
else 
    echo "Compilation succeeded"
fi
TESTRESULTS=$(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples)
if [[ $? == 0 ]]
then 
    echo "Full score!"
    exit 0
else 
    echo "Some issues"
fi
#echo $TESTRESULTS
FAILURES=$(grep -oP "Failures:\s+\K\w+" <<< $TESTRESULTS)
TESTS=$(grep -oP "Tests run:\s+\K\w+" <<< $TESTRESULTS)
PASSED=$((TESTS-FAILURES))
echo "Score: " $PASSED/$TESTS
echo $TESTRESULTS
