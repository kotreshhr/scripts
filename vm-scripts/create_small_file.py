for i in {1..100}
do
    mkdir dir-$i
    for j in {1..500}
    do
        echo "dfjasldfjkasl;fkdja;sldfjkal;sdfja;ldfkjal;kfjasl;dfkjal;ja;lfdkja;df" > dir-$i/file-$j
    done
done
