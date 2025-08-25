FROM liquibase/liquibase:4.25

# Set maintainer information
LABEL maintainer="developer"
LABEL description="Custom Liquibase image with MySQL JDBC driver pre-installed"

# Switch to root user to install dependencies
USER root

# Download MySQL JDBC driver and create changelog directory
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /liquibase/lib/mysql-connector-j-8.0.33.jar

RUN chmod 644 /liquibase/lib/mysql-connector-j-8.0.33.jar && \
    mkdir -p /liquibase/changelog

# Set the working directory
WORKDIR /liquibase/changelog

# Switch back to liquibase user for security
USER liquibase

# Set default environment variables
ENV LIQUIBASE_CLASSPATH="/liquibase/lib/mysql-connector-j-8.0.33.jar"

# Default command
CMD ["update"]
