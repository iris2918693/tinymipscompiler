FILES=($(ls ../test| cut -d'.' -f1 | uniq))
rm -rf error
mkdir error
make > /dev/null; mv mcc ./error
make clean > /dev/null
cd ../nas; make nas > /dev/null; mv nas ../compiler/error; make clean > /dev/null
cd ../test
for FILE in ${FILES[@]}
do
  cp $FILE.sc ../compiler/error
  cp $FILE.sample_out ../compiler/error
  if [ -f $FILE.in ] ; then cp $FILE.in ../compiler/error ; fi
done
cd ../compiler/error
touch report
for FILE in ${FILES[@]}
do
  ./mcc $FILE.sc > $FILE.as
  if [ -f $FILE.in ]
    then
      ./nas $FILE.as > $FILE.output < $FILE.in
    else
      ./nas $FILE.as > $FILE.output
  fi
  if diff $FILE.output $FILE.sample_out > $FILE.cmp
  then
    echo -e "\033[32mSucceed: $FILE\033[0m" >> report
    rm $FILE.sc; rm $FILE.as; rm $FILE.sample_out; rm $FILE.output; rm $FILE.cmp
  else
    echo -e "\033[31mFail: $FILE\033[0m" >> report
    mkdir $FILE
    mv $FILE.sc ./$FILE
    mv $FILE.as ./$FILE
    mv $FILE.sample_out ./$FILE
    mv $FILE.output ./$FILE
    mv $FILE.cmp ./$FILE
  fi
done
cd ..
cat ./error/report
