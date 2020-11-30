#On utilise une image python (la plus récente)
FROM python:latest

#On copie le dossier manager de notre working directory dans un dossier manager
# que l'on crée dans notre conteneur.
COPY manager manager

#On pourrait aussi mettre ces variables d'environnement dans 
#le docker compose sous le service manager
ENV POSTGRES_USER=valot
ENV POSTGRES_PASSWORD=cv
ENV POSTGRES_DB=database
ENV CSV_FILENAME=data.csv

#On doit installer cette librairie car c'est la seule qui n'est pas 
#inhérente à python (contrairement à os ou unittest)
RUN pip install psycopg2

# the python code should wait for the database server to be ready before connecting to it, 
# otherwise, this will result in an error message. 
# Hence those 3 lines:
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -P /
RUN chmod +x /wait-for-it.sh
ENTRYPOINT ["/wait-for-it.sh", "db:5432", "--"]

#On run le programme python car la commande au dessus ne le fait pas,
#elle se charge juste d'attendre que la database soit prête à être connectée.
CMD ["python", "-m", "manager"]