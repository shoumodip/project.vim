" The directory where all the projects are located
if !exists("g:project#location")
  let g:project#location = ""
endif

" The project configuration file path
if !exists("g:project#config_path")
  let g:project#config_path = "project.ini"
endif

" The command to run to open the repl for a project
if !exists("g:project#repl")
  let g:project#repl = ""
endif

" The command to run to build the project
if !exists("g:project#build")
  let g:project#build = "make -B"
endif

" The command to run to reload the project
if !exists("g:project#reload")
  let g:project#reload = ""
endif

" The entry point to the project functions
noremap <silent> <plug>(ProjectEntry) :call project#entry()<cr>
nmap <silent> <c-p> <plug>(ProjectEntry)
