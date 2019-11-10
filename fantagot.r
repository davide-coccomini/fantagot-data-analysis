
dev.off()
library(RMariaDB)
library(ggplot2);

localuserpassword <- ""
db <- dbConnect(RMariaDB::MariaDB(), user='root', password=localuserpassword, dbname='fantagot', host='localhost')
dbListTables(db)

# Number of logs per day
query<-paste("SELECT MONTH(timestamp),DAY(timestamp), COUNT(*) as count FROM logs GROUP BY MONTH(timestamp),DAY(timestamp)");
rs = dbSendQuery(db,query)
dbRows<-dbFetch(rs)

count<-c(as.integer(dbRows$count))
qts1 = ts(count)

plot(qts1, 
    lwd=3,
    col = "red",
    xlab="Day",
    ylab="Number of logs",
    main=paste("Number of logs per day.",sep=""),
    sub="")


# Number of registration per day
dev.new();
query<-paste("SELECT MONTH(timestamp),DAY(timestamp), COUNT(*) as count FROM logs WHERE evento ='registrazione' GROUP BY MONTH(timestamp),DAY(timestamp)");
rs = dbSendQuery(db,query)
dbRows<-dbFetch(rs)

count<-c(as.integer(dbRows$count))
qts2 = ts(count)

plot(qts2, 
    lwd=3,
    col = "red",
    xlab="Day",
    ylab="Number of registration",
    main=paste("Number of registration per day.",sep=""),
    sub="")

# Number of purchases per character
dev.new();
query<-paste("SELECT P.nome as name, COUNT(*) as count FROM personaggi P INNER JOIN personaggiacquistati PA ON PA.personaggio = P.id GROUP BY P.nome");

rs = dbSendQuery(db,query)
dbRows<-dbFetch(rs)

print(dbRows)

StockGroupProfitChart <- ggplot(data=dbRows, aes(x=dbRows$name, y=as.integer(dbRows$count))) + geom_bar(stat="identity") + coord_flip() + xlab("Characters") +
  ylab("Purchases") + ggtitle("Purchases per character")

print(StockGroupProfitChart)

dbDisconnect(db)
