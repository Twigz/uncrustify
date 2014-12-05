cd $(git rev-parse --show-toplevel)

#There's no reason for the 5040z other than uniqueness. I just chose some random numbers and a letter.
uncrustifyDirectory=Uncrustify-CI5040z
uncrustifyPath=$uncrustifyDirectory/uncrustify
uncrustifyConfigurationPath=$uncrustifyDirectory/uncrustify.cfg

mkdir -p $uncrustifyDirectory

curl -o $uncrustifyPath -L https://github.com/Twigz/uncrustify/raw/master/Uncrustify-CI/uncrustify
curl -o $uncrustifyConfigurationPath -L https://raw.githubusercontent.com/Twigz/uncrustify/master/Uncrustify-CI/uncrustify.cfg

modifiedFilesPath=$uncrustifyDirectory/modified.txt
addedFilesPath=$uncrustifyDirectory/added.txt
diffFilesPath=$uncrustifyDirectory/diff.txt

git ls-files -m > $modifiedFilesPath
git diff --cached --name-only --diff-filter=A > $addedFilesPath

cat $modifiedFilesPath $addedFilesPath > $diffFilesPath

if [ -f $uncrustifyPath ]
then
    chmod 755 $uncrustifyPath

    while read p; do

        if [[ $p == *.h ]] || [[ $p == *.m ]]
        then
            copyPath=$uncrustifyDirectory/$(basename $p)

            $uncrustifyPath -c $uncrustifyConfigurationPath -f $p > $copyPath
            cp -f $copyPath $p
        fi
    done <$diffFilesPath
fi

rm -rf $uncrustifyDirectory