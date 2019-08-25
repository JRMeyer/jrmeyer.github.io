---
layout: post
title:  "Some Linux Text Processing Notes"
date:   2019-03-02
categories: misc
comments: True
---

## [cut][cut]

### Edit single column of csv file

{% highlight bash %}
# the following takes the first two columns of a CSV file (FILE), and performs a sed cleaning on the second

paste -d"," <( cut -d"," -f1 FILE ) <( cut -d"," -f2 FILE | sed -e 's/from/to/g' ) >OUTPUT
{% endhighlight %}

### Edit column of single file, skipping header

{% highlight bash %}
paste -d"," <( cut -d"," -f1,2 $INFILE ) \
<( \
   cat <( head -1 $INFILE | cut -d"," -f3- ) \
   <(tail +2 $INFILE | cut -d"," -f3- | ./replace-bytes.sh $NUM_BYTES) \
   ) \
>$OUTFILE
{% endhighlight %}


## [sed][sed]

### Lowercase

{% highlight bash %}
sed -e 's/\(.*\)/\L\1/g'
{% endhighlight %}

### Remove punctuation

{% highlight bash %}
sed -e 's/[[:punct:]]\+//g'
{% endhighlight %}


## [grep][grep]

### Get unique characters in file

{% highlight bash %}
grep -o "." FILE | sort | uniq
{% endhighlight %}


## [awk][awk]

### Sort lines in file by length in characters

{% highlight bash %}
cat FILE | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2-
{% endhighlight %}

[cut]: https://linux.die.net/man/1/cut
[sed]: https://linux.die.net/man/1/sed
[grep]: https://linux.die.net/man/1/grep
[awk]: https://linux.die.net/man/1/awk
