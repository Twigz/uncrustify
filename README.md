Add this script as a run phase to use uncrustify.

```
scriptPath=ucscript.sh

curl -o $scriptPath -L https://github.com/Twigz/uncrustify/raw/master/Uncrustify-CI/uncrustifyscript.sh

if [ -f $scriptPath ]
then
sh $scriptPath
fi

rm -f $scriptPath
```
