FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y gnupg2 wget mdm \
&& ncpus \
&& apt-get install -y software-properties-common dirmngr \
&& wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /usr/share/keyrings/r-project.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | tee -a /etc/apt/sources.list.d/r-project.list \
&& apt-get update \
&& apt-get install r-base -y \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y inotify-tools \
    && mkdir src \
    && echo 'inotifywait -m /path -e create -e moved_to | \
    while read dir action file; do \
        echo "The file '$file' appeared in directory '$dir' via '$action'" \
        ./src/renderengine.sh \
    done' >> bot.sh echo \
    && echo 'rmarkdown::render("*.rmd, output_dir="Export" '

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y git \
&& apt-get install -y libreoffice \
&& apt-get install -y texlive-full texlive-xetex \
&& echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
&& apt-get install -y ttf-mscorefonts-installer \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y libgit2-dev build-essential libcurl4-gnutls-dev libxml2-dev  \
&& apt-get install -y libssl-dev cmake libfontconfig1-dev freetype2-doc libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
&& apt-get clean all && \
apt-get purge && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#https://stackoverflow.com/questions/65433724/configuration-failed-to-find-libgit2-library
#https://github.com/r-lib/devtools/issues/2131

RUN echo "options(Ncpus = 2)" >> .Rprofile

RUN R -e "if (!library(devtools, logical.return=T)) install.packages('devtools', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(tidyverse, logical.return=T)) install.packages('tidyverse', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(sjlabelled, logical.return=T)) install.packages('sjlabelled', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(haven, logical.return=T)) install.packages('haven', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(magrittr, logical.return=T)) install.packages('magrittr', dependencies=TRUE, repos='https://cran.wu.ac.at/') "
RUN R -e "if (!library(dplyr, logical.return=T)) install.packages('dplyr', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(psych, logical.return=T)) install.packages('psych', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(knitr, logical.return=T)) install.packages('knitr', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(ggthemes, logical.return=T)) install.packages('ggthemes', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
#https://stackoverflow.com/questions/45289764/install-r-packages-using-docker-file
#http://www.sthda.com/english/wiki/one-way-anova-test-in-r
RUN R -e "if (!library(apa, logical.return=T)) install.packages('apa', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(jtools, logical.return=T)) install.packages('jtools', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(car, logical.return=T)) install.packages('car', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
RUN R -e "if (!library(ggpubr, logical.return=T)) install.packages('ggpubr', dependencies=TRUE, repos='https://cran.wu.ac.at/')"
 
RUN R -e "if (!library(devtools, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(tidyverse, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(sjlabelled, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(haven, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(magrittr, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(dplyr, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(psych, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(knitr, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(ggthemes, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(apa, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(jtools, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(car, logical.return=T)) quit(status=10)"
RUN R -e "if (!library(ggpubr, logical.return=T)) quit(status=10)"
 
RUN R -e "devtools::install_github('LukasKraiger/frame')"

RUN git clone https://github.com/LukasKraiger/R_Renderengine.git \
		&& cd R_Renderengine \
    && chmod u+x setup.sh \
    && ./setup.sh 

RUN rm -rf .Rprofile