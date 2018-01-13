library(SPARQL) # SPARQL querying package
 
# Step 1 - Set up preliminaries and define query
# Define the data.gov endpoint
uptax <- "http://sparql.uniprot.org/sparql"
 
# create query statement
query <-
  "
  PREFIX up:<http://purl.uniprot.org/core/> 
  SELECT ?taxon
  FROM <http://sparql.uniprot.org/taxonomy>
  WHERE
  {
      ?taxon a up:Taxon .
  }
  LIMIT 10
  "


query <-
"
PREFIX xsd:<http://www.w3.org/2001/XMLSchema#> 
PREFIX up:<http://purl.uniprot.org/core/> 
SELECT ?protein
WHERE
{
	?protein a up:Protein . 
	?protein up:created '2016-11-30'^^xsd:date
}
LIMIT 10
"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
d <- SPARQL(url=uptax, query=query)
