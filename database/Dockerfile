FROM liquibase/liquibase:4.25

# Set maintainer information
LABEL maintainer="developer"
LABEL description="Custom Liquibase image with MySQL JDBC driver and changelog files pre-installed"

# Switch to root user to install dependencies
USER root

# Download MySQL JDBC driver
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /liquibase/lib/mysql-connector-j-8.0.33.jar

# Create changelog directory and set permissions
RUN chmod 644 /liquibase/lib/mysql-connector-j-8.0.33.jar && \
    mkdir -p /liquibase/changelog

# Copy all changelog files into the image
COPY database/ /liquibase/changelog/

# Set correct permissions for changelog files and configure liquibase properties
RUN chown -R liquibase:liquibase /liquibase/changelog && \
    cp /liquibase/liquibase.docker.properties /liquibase/liquibase.docker.properties.bak && \
    echo "classpath: /liquibase/changelog:/liquibase/classpath" > /liquibase/liquibase.docker.properties && \
    echo "liquibase.headless: true" >> /liquibase/liquibase.docker.properties && \
    chown liquibase:liquibase /liquibase/liquibase.docker.properties

# Set the working directory
WORKDIR /liquibase/changelog

# Switch back to liquibase user for security
USER liquibase

# Set default environment variables
ENV LIQUIBASE_CLASSPATH="/liquibase/lib/mysql-connector-j-8.0.33.jar"

# Default command
CMD ["update"]
