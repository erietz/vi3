function books -d 'open books given either as a title or criteria query using rofi to narrow down multiple results or recent-reads if no input given'
    if exists $argv
        if test -f "$argv"
            open-book "$argv"
            return 0
        end
        if test (count $argv) -gt 1
            set tail $argv[2..-1]
        end
        switch $argv[1]
            case --add
                badd $tail
            case -a
                books --add $tail
            case --replacecover
                pdfkillcover "$tail"
                coverit "$tail"
            case -r
                books --replacecover $tail
            case --removewatermark
                remove-pdf-watermark "$tail"
            case -w
                books --removewatermark $tail
            case -l
                switch (count $argv)
                    case 1
                        select-library
                    case 2
                        switch-library $argv[2]
                    case '*'
                        switch-library $argv[2]
                        books $argv[3..-1]
                end
            case -s
                bsrch $tail
            case --search
                bsrch $tail
            case --cover
                coverit "$tail"
            case -c
                books --cover $tail
            case --erase
                set -e recent_reads
            case -e
                books --erase
            case --query
                gvfs-open (choose-format (get-fname-of-book (select-book (query-calibre-title (return-query $tail)))))
                # e open choose-format get-fname-of-book select-book query-calibre-title return-query $tail
            case -q
                books --query $tail
            case "*"
                books --query $argv
        end

    else
        show-recent-reads
    end
end

function query-calibre -d "usage: query-calibre [exact,contains] criteria query returns answer in json"
    set type $argv[1]
    set field $argv[2]
    set query $argv[3..-1]
    switch $type
        case "exact"
            set com (echo calibredb list --fields formats,title,$field -s {$field}:\\\"=\"$query\"\\\" --for-machine)
        case "contains"
            set com (echo calibredb list --fields formats,title,$field -s $field:$query --for-machine)
    end
    eval $com
end

function query-calibre2 -d "usage: query-calibre query returns answer in json"
    set fields (odds $argv)
    set queries (evens $argv)
    for i in (seq (count $fields))
        set acc $acc $fields[$i]:$queries[$i] and
    end
    calibredb list --fields formats,title -s $argv --for-machine
end

function query-calibre-title2
    set result (query-calibre2 \' $argv \' | jq .[].title)
    echo $result
end

function book-exists
    set result (query-calibre exact title $argv | jq .[].title)
    positive (count $result)
end

function query-calibre-title -d "returns list of titles, exact if present or list containing chosen phrase"
    set result (query-calibre contains $argv | jq .[].title)
    set exact (println $result | grep -i "$argv[2..-1]")
    if exists $exact
        println $exact
    else
        println $result
    end
end

# if you hit escape when narrowing a search
# this will be called with title "" and result
# in the first book found being returned

function query-calibre-formats -d "returns files for a given exact title"
    if test (sizeof $argv[2]) -gt 0
        query-calibre exact $argv | jq .[].formats[]
    end
end

function return-query -d "returns a properly formated query for query-calibre-title"
    set selector $argv[1]
    if match $selector author
        set selector authors
    end
    if match $selector tag
        set selector tags
    end
    set criteria authors title publisher series tags

    if contains $selector $criteria
        set query $argv[2..-1]
    else
        set selector title
        set query $argv
    end
    println $selector $query
end

function get-fname-of-book -d "get whole filename of book given its title"
    set title (stripquotes $argv)
    set files (query-calibre-formats title $title)
    set name (stripquotes (get-fname-of-file $files[1]))
    echo $name
end

function choose-format -d "for the given list of formats in preferential order return the first that exists for the given book"
    set formats pdf epub mobi djvu lit chm txt
    set name $argv

    for i in $formats
        if test -f $name.$i
            echo $name.$i
            return 0
        end
    end
    return 1
end

function select-book -d "use rofi to select a book if more than one is possible"
    if test (count $argv) -gt 1
        set val (rfi match "select book: " $argv)
        if not exists $val
            return 1
        end
        if contains $val $argv
            echo $val
        end
    else
        echo $argv
    end
end

function add-to-recent-reads -d "keep a list of the 10 most recent unique items opened via this script"
    if exists $argv
        set title $argv
        # set library (get-current-calibre-library)
        # set entry \"$title @$library\"
        set -U recent_reads (take 10 (unique (println "$title" $recent_reads)))
    else
        msg could not add to recent reads
        return 1
    end
end

function extract-title-from-recent-list-entry
    if substr $argv @
        switch-library (echo $argv | cut -d "@" -f2 | cut -d '"' -f1)
        echo $argv | cut -d "@" -f1 | trim | append-strings '"' 
    else
        echo $argv
    end
end

function append-strings
    while read -l line
        echo $line"$argv"
    end
end

function show-recent-reads -d "use rofi to pick one of the items from recent_reads and open it with sopen if it is a file or books if it is a title"
    set choice (rfi match "choose a book" $recent_reads)
    if exists $choice
        if test -f $choice
            sopen $choice
        else
            books $choice
        end
    else
        return 0
    end
end

function pdfextract -d "replaces pdf with range of pdf defined in args"
    set file $argv[1]
    set tmp /tmp/(uid)
    set range $argv[2]
    set range (echo $range | sed 's#end#z#')
    qpdf $file --pages $file $range -- $tmp
    mv $tmp $file
end

function pdfkillcover
    pdfextract $argv[1] 2-end
end

function pdfcat
    set file1 $argv[1]
    set file2 $argv[2]
    set tmp /tmp/(uid)
    set output $argv[3]
    qpdf $file1 --pages $file1 1-z $file2 1-z -- $tmp
    mv $tmp $output
end

function coverit -d "converts image file in clipboard to pdf and prepends to pdf supplied in argv"
   set url (xclip -o)
   wget $url --output-document=cover
   convert cover cover.pdf
   set tmp /tmp/(uid)
   rm cover
   pdfcat cover.pdf $argv temp.pdf
   # pdftk cover.pdf $argv cat output temp.pdf
   mv temp.pdf $argv
   rm cover.pdf
end

function replacecover
    pdfkillcover $argv
    coverit $argv
end

function remove-pdf-watermark -d "removes all watermarks from text of pdf"
    set file $argv
    set tmp /tmp/pdf_(uid)
    set watermarks[1] "www.it-ebooks.info"
    set watermarks[2] 'Licensed to michael rose'
    set watermarks[3] '.*rosenetwork.net.*'
    # set watermarks[3] '<Michael@rosenetwork.net>'
    # set watermarks[2] 'Licensed to michael rose <Michael@rosenetwork.net>'
    # set watermarks[3] '<Michael@rosenetwork.net>'
    qpdf --stream-data=uncompress "$file" "$tmp" 
    # for i in $watermarks
    #     replacestr "$i" '' "$tmp"
    # end
    cp $tmp abook.txt
    qpdf --stream-data=compress "$tmp" "$file"
end

function switch-library
    if not contains $argv (ls ~/calibre)
        sendit library $argv does not exist
        return 1
    end
    if pgrep calibre
        calibre -s
        calibre --with-library ~/calibre/$argv --detach &
        sleep 2
    else
        change-calibre-library-offline $argv
    end
end

function select-library
    switch-library (rfi match 'select a library: ' (ls ~/calibre))
end


function badd -d "add one or more books wherein the book consists of a file or an archive containing one or more formats of the same book"
    for i in $argv
        set tmp /tmp/thebook
        mkdir $tmp
        set archives rar

        if contains (get-ext $i) $archives
            atool -X $tmp $i
            rm $tmp/*.txt
        else
            mv $i $tmp/
        end
        calibredb add -1 $tmp
        rm -rf $tmp
        # rm $i
    end
end

function sopen
    if exists $argv
        if test -f $argv
            gvfs-open (quote $argv)
        end
    else
        return 1
    end
end

function open-book
    set fullpath (pwd)/$argv
    set ext (cutlast "." $argv)
    set library $HOME/calibre
    if substr $fullpath $library #if path is in $library
        set title (query-calibre-title title (escape-chars (extract-title $fullpath)))
        add-to-recent-reads "$title"
    end

    switch $ext
        case "pdf"
            zathura "$argv"
        case "*"
            ebook-viewer "$argv"
    end
end

function extract-title
    cutlast "/" "$argv" | cut -d "-" -f1 | trim | sed 's/_/:/g'
end

function bsrch
    calibredb list -s $argv
end

function escape-chars
    echo "$argv" | sed "s/'/\\\'/g"
end
