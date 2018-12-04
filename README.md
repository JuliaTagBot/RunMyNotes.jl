# RunMyNotes.jl

I like to write up notes of how to use my packages in plain `.jl` files, 
which the package `Literate` can run & turn into `.ipynb` notebooks, with graphs embedded. 
This little package automates that slightly: running 
```
RunMyNotes.folder("~/.julia/dev/MyPackage/notes/")
```
or equivalently
```
import MyPackage
RunMyNotes.package(MyPackage)
```
will run all files in that folder, and also convert the resulting notebooks to `.html`
to make it easier to preview last week's graphs. 

By default everything is saved in the same folder, 
but rather than sync every copy of MB of figures etc, 
I add to `.gitignore` these lines:
```
.DS_Store
*.ipynb
*.html
```
Then I can happily include this in the package's tests. 
In fact if you `] test RunMyNotes` this will happen. 

ToDo:
* Add date to end of output
* Read file dates to just update

Michael Abbott, December 2018
