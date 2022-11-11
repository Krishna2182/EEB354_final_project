arguments=commandArgs(trailingOnly=T)

if(length(arguments) == 1) {
  file=arguments[1]
} else if (length(arguments) == 2) {
  file=arguments[1]
  redo_or_resume=arguments[2]
} else {
  stop('1 or 2 arguments can be provided: the first for the path to the XML and the second (optional) for an option to redo or resume')
}

submit_job=function(pathtoxml, redo=F, resume=F){
  if(redo & resume) {stop('The run can only be redone or resumed, not both.')}
  if (redo) {command = paste0("beast -overwrite ", pathtoxml)}
  else if (resume) {command = paste0("beast -resume ", pathtoxml)}
  else {command = paste0("beast ", pathtoxml)}

  count=count+1
  system(command, intern=F)
  output=tail(readLines(list.files(pattern='*.out')),10)

  if (any(grepl('Too many corrections', output)) || any(grepl('Fatal exception', output))) {   # job fails
    submit_job(pathtoxml, redo=T)
  } else if (any(grepl('slurmstepd: error', output))) {   # job runs out of time
    # I'm pretty sure this won't do anything because the beast run has the same run time as the R script lol
    submit_job(pathtoxml, resume=T)
  }
  
  return(c(count, output))
}

count=0

if (length(arguments) == 2) {
  if (redo_or_resume == 'redo'){
    submit_job(file, redo = T)
  } else if (redo_or_resume == 'resume') {
    submit_job(file, resume = T)
  } else {stop('optional parameter must be redo or resume')}
} else {
  submit_job(file)
}

