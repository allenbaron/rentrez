context("fetching-records")


pop_ids = c("307082412", "307075396", "307075338", "307075274")
pop_summ_xml <- entrez_summary(db="popset", 
                               id=pop_ids, version="1.0")
pop_summ_json <- entrez_summary(db="popset", 
                                id=pop_ids, version="2.0")
coi <- entrez_fetch(db = "popset", id = pop_ids[1], 
                    rettype = "fasta")

test_that("Functions to fetch summaries work", {
          #tests
          expect_that(pop_summ_xml, is_a("list"))
          expect_that(pop_summ_json, is_a("list"))

          expect_that(pop_summ_xml[[4]], is_a("esummary"))
          expect_that(pop_summ_json[[4]], is_a("esummary"))
          sapply(pop_summ_json, function(x)
                 expect_that(x[["title"]], matches("Muraenidae"))
          )         
})  

test_that("Fetching sequences works", {
     expect_that(length(strsplit(coi, ">")[[1]]), equals(30))
          
})

test_that("List elements in XML are parsable", {
         rec <- entrez_summary(db="pubmed", id=25696867, version="1.0")
         expect_named(rec$History)
         expect_more_than(length(rec$History), 0)
})
         

test_that("JSON and XML objects are similar", {
          #It would be nice to test whether the xml and json records
          # have the same data in them, but it turns out they don't
          # when they leave the NCBI, so let's ensure we can get some
          # info from each file, even if they won't be exactly the same
          sapply(pop_summ_xml, function(x)
                 expect_that(x[["Title"]], matches("Muraenidae")))
          sapply(pop_summ_json, function(x)
                 expect_that(x[["title"]], matches("Muraenidae")))
          
          expect_that(length(pop_summ_xml[[1]]), is_more_than(12))
          expect_that(length(pop_summ_json[[1]]), is_more_than(12))
          
})

test_that("Suggestions when slicing verion 2.0 records ", { 
    sapply(pop_summ_json,  function(x) 
           expect_warning(x$Journal, "has no object named 'Journal'"))
    sapply(pop_summ_json,  function(x) 
           expect_warning(x[['Journal']], "has no object named 'Journal'"))
    sapply(pop_summ_json,  function(x) 
           expect_warning(x['Journal']))
})
    
         


                         
          


