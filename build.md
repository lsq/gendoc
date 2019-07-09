https://superuser.com/questions/1202426/compile-pdf-book-from-multiple-markdown-files
https://stackoverflow.com/questions/40993488/convert-markdown-links-to-html-with-pandoc
obtained from https://github.com/atom/markdown-preview/issues/289
https://github.com/MatrixManAtYrService/md_htmldoc


Yep, have a look at http://pandoc.org/ or markdown-it https://github.com/markdown-it

It now depends, whether you want to merge the HTMl files or not:

```bash
# Single output files
for f in *.md ; do pandoc ${f} -f markdown -t html -s -o ${f}.html  ; done
# One output file
pandoc *.md -f markdown -t -s html -o merged.html
```


There are other ways to do it recursively according to https://stackoverflow.com/questions/26126362/converting-all-files-in-a-folder-to-md-using-pandoc-on-mac

You can run this in the parent directory in the terminal

```bash
find ./ -iname "*.md" -type f -exec sh -c 'pandoc "${0}" -o "${0%.md}.pdf"' {} \;
```
