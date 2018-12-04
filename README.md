# RunMyNotes.jl

I like to write up notes of how to use my packages in plain `.jl` files,
which the package [Literate.jl](https://github.com/fredrikekre/Literate.jl) can run
producing turn into `.ipynb` notebooks, with graphs embedded.
This little package automates that slightly. Typing this:  
```
RunMyNotes.folder("~/.julia/dev/MyPackage/notes/")
```
or equivalently
```
import MyPackage
RunMyNotes.package(MyPackage)
```
will run all files in that folder.
Then it will convert the resulting notebooks to `.html`
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
In fact if you type `] test RunMyNotes` this will happen for this package itself,
for a simple [note.jl](notes/note.jl).

ToDo:
* Read file dates to (optionally) just update changed
* Should this know about `manifest.toml` or something? 

Michael Abbott, December 2018
