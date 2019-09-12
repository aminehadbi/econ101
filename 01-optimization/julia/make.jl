using Weave
import Base64:stringmime
weave("optimization.jmd",out_path=:doc,fig_path="figures",
      mod=Main,
      doctype="pandoc2html",
      pandoc_options=["--toc","--toc-depth=2","--filter=pandoc-citeproc"],
      cache=:refresh) 
using IJulia
notebook("optimization.jmd")
