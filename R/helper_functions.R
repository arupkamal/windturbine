library(DBI)
library(RPostgres)
library(safer)

get_data_from_db <- function () {
#################################
  starting_row = 1 + as.integer(Sys.time()) %% 45000

  conn = DBI::dbConnect(RPostgres::Postgres()
                        , host="127.0.0.1"
                        , dbname="opencpu"
                        , user = safer::decrypt_string(user, key = zalt)
                        , password = safer::decrypt_string(password, key = zalt)
                        )

  sql <- "SELECT * FROM public.wind_turbine WHERE time BETWEEN ?p1 AND ?p2"
  SQL <- DBI::sqlInterpolate(DBI::ANSI(), sql, p1 = starting_row, p2 = (starting_row+180-1) )
  data <- DBI::dbGetQuery(conn, SQL)

  data$power_kw = NULL
  data$outlier_power_kw = NULL

  DBI::dbDisconnect(conn)

  data
}
