library('DBI')
library('RMariaDB')
library('ggplot2')
library('dplyr')


# Ein Verbindungsobjekt erzeugen
con <- dbConnect(RMariaDB::MariaDB(), 
                 dbname = "movies", 
                 username ="", 
                 password = "", 
                 host = '', 
                 port = 3306)


queryGetFilms = "SELECT year, titleEn, myRating, violence, primaryGenre as genre FROM movies.film WHERE myRating IS NOT NULL";

# Query abschicken und das Resultset benennen
rs = dbSendQuery(con, queryGetFilms);

# Das Ergebnis abrufen und in einer Dataframe speichern
# (dbFetch, weil fetch deprecated ist!)
movies = dbFetch(rs, -1);

# Plot vorbereiten
# Hängt das Reting mit der im Film ausgeübten Gewalt zusammen?
ViolenceVsRating <- ggplot(movies) + 
  geom_boxplot(aes(x=as.factor(violence), y=myRating)) + 
  ggtitle('Violence Level and Rating') + 
  xlab('Violence Level')
ylab('Personal Rating (0 to 5)')

# Plot ausgeben
ViolenceVsRating

# Scatterplot
ratingByYear <- ggplot() + 
  geom_point(data = movies, 
             aes(x = year
                 , y = myRating
                 # Einfärbung und Shape nach Genre nicht genutzt, weil zu viele
                 # für eine sinnvolle Darstellung: Gruppierung notwendig
                 #, color = factor(genre)
                 #, shape = factor(genre)
                 , size = 1.5)
             ) + 
  ggtitle('Bewertung nach Jahr und Genre') + 
  xlab('Erscheinungsjahr') + 
  ylab('persönliches Rating (0 bis 5)') + 
  theme_bw()

ratingByYear














queryMoviesRecoded = "
SELECT
    myRating,
rottenTomatoesAvg, 
YEAR,
(
  CASE genre WHEN 'Horror' THEN 'Action' 
WHEN 'Spy Film' THEN 'Action' 
WHEN 'Western' THEN 'Action' 
WHEN 'War' THEN 'Action' 
WHEN 'Anime' THEN 'Fantasy' 
WHEN 'Superhero movie' THEN 'Action' 
WHEN 'Thriller' THEN 'Action' 
ELSE genre -- fängt alle anderen Fälle ab und behält den Ursprungswert!
  END
) AS genre,
  violence
  FROM
  movies.v_films
  WHERE
  genre NOT IN(
  'Fantasy',
  'Documentation',
  'Historical / Historical Fiction'
  );
  ";

# send the query and name the result:
rsCC = dbSendQuery(con, queryMoviesRecoded);
# store the result into a dataframe
# (using dbFetch as fetch is deprecated)
moviesRecoded = dbFetch(rsCC, -1);




CategoryVsRating <- ggplot(moviesRecoded) + 
  geom_boxplot(aes(x=as.factor(genre), y=myRating)) + 
  ggtitle('Category and Rating') + 
  xlab('Category')
ylab('Personal Rating (0 to 5)')


CategoryVsRating







ratingByYearRecoded <- ggplot() + 
  geom_point(data = moviesRecoded, 
             aes(x = year
                 , y = myRating
                 , color = factor(genre)
                 , shape = factor(genre)
                 , size = 1.5)
  ) + 
  ggtitle('Bewertung nach Jahr und Genre') + 
  xlab('Erscheinungsjahr') + 
  ylab('persönliches Rating (0 bis 5)') + 
  theme_bw()

ratingByYearRecoded













ratingsCompared <- ggplot() + 
  geom_point(data = moviesRecoded, aes(
    x = rottenTomatoesAvg,
    y = (myRating * 2)
  )) +  
  geom_smooth(method = 'lm') + 
  ggtitle('Ratings im Vergleich') + 
  xlab('Rotten Tomatoes (average score)') + 
  ylab('persönliches Rating (transformiert)')

ratingsCompared













queryGetAllSpringfieldsInTheUS = 'SELECT latitude, longitude FROM geo.geonames2019feb_mod WHERE name= "Springfield" AND country_code = "US";'
queryGetAllSpringfieldsInTheUS

GetSpringfieldsUS <- dbSendQuery(con, queryGetAllSpringfieldsInTheUS);

SpringfieldsUS = dbFetch(GetSpringfieldsUS, -1);



# library(ggmap)
# 
# basicMap <- get_openstreetmap(location = "United States",
#                     source = "osm",
#                     maptype = "toner",
#                     crop = FALSE,
#                     zoom = 6,
#                     color = "bw") %>% ggmap()
# 
# 
# basicMap



library(rworldmap)

newmap <- getMap(resolution = "low")
plot(newmap)
points(SpringfieldsUS$longitude, SpringfieldsUS$latitude, col = "red", cex = .6)






# close the connection.
dbDisconnect(con)


# "SELECT name, longitude, latitude FROM `geonames2019feb_mod` WHERE feature_class = 'P' AND population > 3000000;"

conGeo <- dbConnect(RMySQL::MySQL(), 
                 dbname = "geo", 
                 username ="dummy02", 
                 password = "ph4cawvKFbCd", 
                 host = 'ruediger-voigt.eu', 
                 port = 3306)


geonamesDB <- tbl(conGeo, "geonames2019feb_mod")
geonamesDB


largeCities_db <- geonamesDB %>% 
  filter(feature_class = 'P') %>% 
  filter(population > 3000000)

largeCities_db %>% show_query


largeCities_db <- geonamesDB %>% 
  filter(feature_class = 'P' & population > 3000000) 

# ask for the data (triggers database action)
largeCities <- largeCities_db %>% collect()
