install.packages("RMariaDB") # to be run only once if yet to be installed

# Initialise imported package
library(DBI)

# Connect to the MySQL database
con <- dbConnect(RMariaDB::MariaDB(), 
                 dbname = "London_Paris_DB", 
                 host = "<host>", 
                 port = <port>,
                 user = "<username>",
                 password = "<password>")

# Get table names
tables <- dbListTables(con)

# Display structure of tables
str(tables) # showed four table names of "country_ids",
# "sample_char_genotypes", "sample_characteristics" and "sample_genotypes"

# While still connected, import data
sample_genotypes <- dbReadTable(con, "sample_genotypes")
head(sample_genotypes)

# Always cleanup by disconnecting the database
dbDisconnect(con)
