FROM gcr.io/google_containers/elasticsearch:v2.4.1-2

# Necesito añadir el path.repo en el /elasticsearch/config
COPY config /elasticsearch/config


RUN chown -R elasticsearch:elasticsearch /elasticsearch/config
CMD ["/run.sh"]
