FROM python:3.14.2-alpine3.23

# Do I really need to do this?
LABEL maintainer="github.com/therappha"

# Recommend for python on docker container, prevents python from buffering stdout/err logs and prints!
ENV PYTHONUNBUFFERED=1

# Copy requirements file
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copy actual app
COPY ./app /app

# Set the working directory to /app so when run the commands we dont need to specify full path
WORKDIR /app

# This one will actually not do anything as docker-compose will be the one exposing the port.
# It's good practice to have it here for documentation purposes
EXPOSE 8000

ARG DEV=false
# Set up the virtual environment, upgrade pip and install requirements
RUN python -m venv /py && \
	/py/bin/pip install --upgrade pip && \
	/py/bin/pip install -r /tmp/requirements.txt && \
	if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt ; fi && \
	rm -rf /tmp
# Remove any temp file you don't need in your project!!!!!!
# Always quote variables:  "$VARIABLE"


# Add our user, best practice is to make the RUN command as a "monolith with all commands" but i wanted to separate the logic for course visualization

# Best practice for docker is to never use root user, because if compromised, the attacker will have full access to your app
# No home directory is important to keep app lightweight
RUN adduser --disabled-password --no-create-home django-user

# Add the venv path first in the PATH variable so when running a venv command, it will look first inside of venv!
ENV PATH="/py/bin:$PATH"

USER django-user
