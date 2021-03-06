NewProjectButton <- function(container){
  gbutton(gettext("New Project", domain = "R-RQDA"),container=container,handler=function(h,...){
    path=gfile(type="save",text = gettext("Type a name for the new project and click OK.", domain = "R-RQDA"))
    if (Encoding(path) != "UTF-8") {
        Encoding(path) <- "UTF-8"
    }
    if (path!=""){
     ## if path="", then click "cancel".
     new_proj(path,assignenv=.rqda)
     path <- .rqda$qdacon@dbname
     Encoding(path) <- "UTF-8" ## path created by gfile is in utf8 encoding
     path <- gsub("\\\\","/",path,fixed=TRUE)
     path <- gsub("/","/ ",path,fixed=TRUE)
      svalue(.rqda$.currentProj) <- gsub("/ ","/",paste(strwrap(path,60),collapse="\n"),fixed=TRUE)
      unblockHandler(button$cloprob)
      unblockHandler(button$BacProjB)
      enabled(button$saveAsB) <- TRUE
      unblockHandler(button$proj_memo)
      unblockHandler(button$CleProB)
      unblockHandler(button$CloAllCodB)
      unblockHandler(button$ImpFilB)
      enabled(button$NewFilB) <- TRUE
      unblockHandler(.rqda$.fnames_rqda)
      enabled(button$AddJouB) <- TRUE
      enabled(button$AddCodB) <- TRUE
      enabled(button$AddCodCatB) <- TRUE
      enabled(button$AddCasB) <- TRUE
      enabled(button$AddAttB) <- TRUE
      enabled(button$AddFilCatB) <- TRUE
      enabled(.rqda$.JournalNamesWidget) <- TRUE
      enabled(.rqda$.codes_rqda) <- TRUE
      enabled(.rqda$.SettingsGui) <- TRUE
      enabled(.rqda$.CodeCatWidget) <- TRUE
      enabled(.rqda$.CasesNamesWidget) <- TRUE
      enabled(.rqda$.AttrNamesWidget) <- TRUE
      enabled(.rqda$.FileCatWidget) <- TRUE
  }
}
          )
}

OpenProjectButton <- function(container){
  gbutton(gettext("Open Project", domain = "R-RQDA"),container=container,handler=function(h,...){
    path <- gfile(text = gettext("Select a *.rqda file and click OK.", domain = "R-RQDA"),type="open",
                  filter=list("rqda"=list(patterns = c("*.rqda")), "All files" = list(patterns = c("*"))))
    if (!is.na(path)){
      Encoding(path) <- "UTF-8"
      openProject(path,updateGUI=TRUE)
  }
}
          )
}

openProject <- function(path,updateGUI=FALSE) {
    tryCatch(.rqda$.codes_rqda[]<-NULL,error=function(e){})
    tryCatch(.rqda$.fnames_rqda[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CasesNamesWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CodeCatWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CodeofCat[]<-NULL,error=function(e){})
    tryCatch(.rqda$.FileCatWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.FileofCat[]<-NULL,error=function(e){})
    tryCatch(.rqda$.AttrNamesWidget[] <- NULL,error=function(e){})
    tryCatch(.rqda$.JournalNamesWidget[] <- NULL,error=function(e){})
    tryCatch(closeProject(assignenv=.rqda),error=function(e){})
    ## close currect project before open a new one.
    open_proj(path,assignenv=.rqda)
    if (updateGUI) {
        svalue(.rqda$.currentProj) <- gettext("Opening ...", domain = "R-RQDA")
        UpgradeTables()
        tryCatch(CodeNamesUpdate(sortByTime=FALSE),error=function(e){})
        tryCatch(FileNamesUpdate(sortByTime=FALSE),error=function(e){})
        tryCatch(CaseNamesUpdate(),error=function(e){})
        tryCatch(UpdateTableWidget(Widget=.rqda$.CodeCatWidget,FromdbTable="codecat"),error=function(e){})
        tryCatch(UpdateCodeofCatWidget(),error=function(e){})
        tryCatch(UpdateTableWidget(Widget=.rqda$.FileCatWidget,FromdbTable="filecat"),error=function(e){})
        tryCatch(UpdateFileofCatWidget(),error=function(e){})
        tryCatch(AttrNamesUpdate(),error=function(e){})
        tryCatch(JournalNamesUpdate(),error=function(e){})
        path <- .rqda$qdacon@dbname
        Encoding(path) <- "UTF-8"
        path <- gsub("\\\\","/", path)
        path <- gsub("/","/ ",path)
        svalue(.rqda$.currentProj) <- gsub("/ ","/",paste(strwrap(path,50),collapse="\n"))
        unblockHandler(button$cloprob)
        unblockHandler(button$BacProjB)
        enabled(button$saveAsB) <- TRUE
        unblockHandler(button$proj_memo)
        unblockHandler(button$CleProB)
        unblockHandler(button$CloAllCodB)
        unblockHandler(button$ImpFilB)
        enabled(button$NewFilB) <- TRUE
        unblockHandler(.rqda$.fnames_rqda)
        enabled(button$AddJouB) <- TRUE
        enabled(button$AddCodB) <- TRUE
        enabled(button$AddCodCatB) <- TRUE
        enabled(button$AddCasB) <- TRUE
        enabled(button$AddAttB) <- TRUE
        enabled(button$AddFilCatB) <- TRUE
        enabled(.rqda$.JournalNamesWidget) <- TRUE
        enabled(.rqda$.codes_rqda) <- TRUE
        enabled(.rqda$.SettingsGui) <- TRUE
        enabled(.rqda$.CodeCatWidget) <- TRUE
        enabled(.rqda$.CasesNamesWidget) <- TRUE
        enabled(.rqda$.AttrNamesWidget) <- TRUE
        enabled(.rqda$.FileCatWidget) <- TRUE
    }
}

closeProjBF <- function(){
    svalue(.rqda$.currentProj) <- gettext("Closing ...", domain = "R-RQDA")
    tryCatch(.rqda$.codes_rqda[]<-NULL,error=function(e){})
    tryCatch(.rqda$.fnames_rqda[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CasesNamesWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.FileofCase[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CodeCatWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.CodeofCat[]<-NULL,error=function(e){})
    tryCatch(.rqda$.FileCatWidget[]<-NULL,error=function(e){})
    tryCatch(.rqda$.FileofCat[]<-NULL,error=function(e){})
    tryCatch(.rqda$.AttrNamesWidget[] <- NULL,error=function(e){})
    tryCatch(.rqda$.JournalNamesWidget[] <- NULL,error=function(e){})
    svalue(.rqda$.currentProj) <- gettext("No project is open.", domain = "R-RQDA")
    names(.rqda$.fnames_rqda) <- gettext("Files", domain = "R-RQDA")
    names(.rqda$.codes_rqda) <- gettext("Codes List", domain = "R-RQDA")
    names(.rqda$.CodeCatWidget)<-gettext("Code Category", domain = "R-RQDA")
    names(.rqda$.CodeofCat)<-gettext("Codes of This Category", domain = "R-RQDA")
    names(.rqda$.CasesNamesWidget) <- gettext("Cases", domain = "R-RQDA")
    names(.rqda$.FileofCase)<-gettext("Files of This Case", domain = "R-RQDA")
    names(.rqda$.FileCatWidget)<-gettext("File Category", domain = "R-RQDA")
    names(.rqda$.FileofCat)<-gettext("Files of This Category", domain = "R-RQDA")
    blockHandler(.rqda$.fnames_rqda)
    enabled(.rqda$.JournalNamesWidget) <- FALSE
    enabled(.rqda$.codes_rqda) <- FALSE
    enabled(.rqda$.SettingsGui) <- FALSE
    enabled(.rqda$.CodeCatWidget) <- FALSE
    enabled(.rqda$.CodeofCat) <- FALSE
    enabled(.rqda$.CasesNamesWidget) <- FALSE
    enabled(.rqda$.FileofCase) <- FALSE
    enabled(.rqda$.AttrNamesWidget) <- FALSE
    enabled(.rqda$.FileCatWidget) <- FALSE
    enabled(.rqda$.FileofCat) <- FALSE
    blockHandler(button$cloprob)
    blockHandler(button$BacProjB)
    enabled(button$saveAsB) <- FALSE
    blockHandler(button$proj_memo)
    blockHandler(button$CleProB)
    blockHandler(button$CloAllCodB)
    blockHandler(button$ImpFilB)
    enabled(button$NewFilB) <- FALSE
    blockHandler(button$DelFilB)
    blockHandler(button$VieFilB)
    blockHandler(button$FilMemB)
    blockHandler(button$FilRenB)
    enabled(button$FileAttrB) <- FALSE
    enabled(button$AddJouB) <- FALSE
    enabled(button$DelJouB) <- FALSE
    enabled(button$RenJouB) <- FALSE
    enabled(button$OpeJouB) <- FALSE
    enabled(button$AddCodB) <- FALSE
    enabled(button$RetB) <- FALSE
    enabled(button$DelCodB) <- FALSE
    enabled(button$codememobuton) <- FALSE
    enabled(button$FreCodRenB) <- FALSE
    ## enabled(button$c2memobutton) <- FALSE
    enabled(button$AddCodCatB) <- FALSE
    enabled(button$DelCodCatB) <- FALSE
    enabled(button$CodCatMemB) <- FALSE
    enabled(button$CodCatRenB) <- FALSE
    enabled(button$CodCatAddToB) <- FALSE
    enabled(button$CodCatADroFromB) <- FALSE
    enabled(button$AddCasB) <- FALSE
    enabled(button$DelCasB) <- FALSE
    enabled(button$CasRenB) <- FALSE
    enabled(button$CasMarB) <- FALSE
    enabled(button$CasUnMarB) <- FALSE
    enabled(button$CasAttrB) <- FALSE
    enabled(button$profmatB) <- FALSE
    enabled(button$AddAttB) <- FALSE
    enabled(button$DelAttB) <- FALSE
    enabled(button$RenAttB) <- FALSE
    enabled(button$AttMemB) <- FALSE
    enabled(button$SetAttClsB) <- FALSE
    enabled(button$AddFilCatB) <- FALSE
    enabled(button$DelFilCatB) <- FALSE
    enabled(button$FilCatRenB) <- FALSE
    enabled(button$FilCatMemB) <- FALSE
    enabled(button$FilCatAddToB) <- FALSE
    enabled(button$FilCatDroFromB) <- FALSE
}

CloseProjectButton <- function(container){
  cloprob <- gbutton(gettext("Close Project", domain = "R-RQDA"),container=container,handler=function(h,...){
  closeProjBF()
  closeProject(assignenv=.rqda)
  }
                     )
  assign("cloprob",cloprob,envir=button)
  blockHandler(button$cloprob)
}

BackupProjectButton <- function(container){
  BacProjB <- gbutton(gettext("Backup Project", domain = "R-RQDA"),container=container,handler=function(h,...){
    backup_proj(con=.rqda$qdacon)
  }
                      )
  assign("BacProjB",BacProjB,envir=button)
  blockHandler(button$BacProjB)
}


Proj_MemoButton <- function(label=gettext("Project Memo", domain = "R-RQDA"),container,...){
  ## Each button a separate function -> more easy to debug, and the main function root_gui is shorter.
  ## The memo in dataset is UTF-8
  ## label of button
  ## name of contaianer or TRUE
  proj_memo <- gbutton(label, container=container, handler=function(h,...) {
    ProjectMemoWidget()
  }
                       )
  assign("proj_memo",proj_memo,envir=button)
  blockHandler(button$proj_memo)
}


CleanProjButton <- function(label=gettext("Clean Project", domain = "R-RQDA"),container,...){
  CleProB <- gbutton(label, container=container, handler=function(h,...) {
    CleanProject(ask=FALSE)
  }
                     )
  assign("CleProB",CleProB,envir=button)
  blockHandler(button$CleProB)
}

CloseAllCodingsButton <- function(label=gettext("Close All Codings", domain = "R-RQDA"),container,...){
  CloAllCodB <- gbutton(label, container=container, handler=function(h,...) {
    close_AllCodings()
  }
                        )
  assign("CloAllCodB",CloAllCodB,envir=button)
  blockHandler(button$CloAllCodB)
}


####################
## defunct functions
####################
## ProjectInforButton <- function(container){
## gbutton(gettext("Current Project", domain = "R-RQDA"),container=container,handler=function(h,...){
##     if (is_projOpen(envir=.rqda,conName="qdacon")) {
##       con <- .rqda$qdacon
##       dbname <- dbGetInfo(.rqda$qdacon)$dbname
##       ##substr(dbname, nchar(dbname)-15,nchar(dbname))
##       gmessage(dbname,title=gettext("Info about current project.", domain = "R-RQDA"),container=TRUE)
##     }
##   },
##                              action=list(env=.rqda,conName="qdacon")
##                              )
## }
