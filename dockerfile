# Filename dockerfile (so you can run it) 
# lets dockerize this beeyatch

#Latest attempt i see of someone dockerizing from Deastrom
#*************************************************************************************************************
#**************************************************************************************************************
#FROM node:14-bullseye

#RUN apt-get update \
# && apt-get install -y make g++ gcc libsqlite3-dev

#WORKDIR /usr/karaoke

#COPY . .

#RUN npm install sqlite3 --build-from-source --sqlite=/usr \
# && npm install\
# && npm run build

#EXPOSE 3000

#ENTRYPOINT [ "node", "server/main.js", "-p 3000", "--scan" ]

#END ******************************************************************************************
#************************************************************************************************

##The last time i was sucessful in getting this to work was from this guys code mr. vze22jjw


### sudo docker run --detach -p 8880:8880 --name=karaoke-forever-server -v /MNT-TO-DB-FILE/database.sqlite3:/usr/local/lib/node_modules/karaoke-forever/database.sqlite3 -v /MNT-TO-KARAOKE-FILES/FILES:/mnt/KARAOKE_FILES karaoke-forever-server ##
### default db path === /usr/local/lib/node_modules/karaoke-forever/database.sqlite3 ##

FROM node:lts


ARG PORT="8880"
ENV RUN_PORT ${PORT}

ARG CURRENT_VERSION="0.8.0"
ARG VERSION=${CURRENT_VERSION}

### SET TIMEZONE HERE
ENV TZ=America/Chicago

### CHANGE TIME ZONE ##
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

### MAKE MOUNT DIR FOR VOLUME MOUNT ##
RUN mkdir /mnt/KARAOKE_FILES && chmod 0777 /mnt/KARAOKE_FILES

### INSTALL KARAOKE FORVER SERVER NPM ##
RUN npm -g config set user root \
    && npm -g install karaoke-forever@${VERSION}

### KARAOKE-FOREVER SERVER AT STARTUP ##
CMD [ "sh", "-c", "karaoke-forever-server --port $RUN_PORT" ]

### MAKE SURE PORT IS OPEN ON CONTAINER ##
EXPOSE $PORT
