FROM openeats/openeats-api:1.5.1
RUN apk add --no-cache postgresql-dev
RUN pip install psycopg2-binary
RUN { \
    echo "DATABASES = {"; \
    echo "    'default': {"; \
    echo "        'ENGINE': os.environ.get('MYSQL_BACKEND', 'django.db.backends.mysql'),"; \
    echo "        'NAME': os.environ.get('MYSQL_DATABASE', 'openeats'),"; \
    echo "        'USER': os.environ.get('MYSQL_USER', 'root'),"; \
    echo "        'PASSWORD': os.environ.get('MYSQL_ROOT_PASSWORD', ''),"; \
    echo "        'HOST': os.environ.get('MYSQL_HOST', 'db'),"; \
    echo "        'PORT': os.environ.get('MYSQL_PORT', '3306'),"; \
    echo "        'TEST': {"; \
    echo "            'NAME': os.environ.get('MYSQL_TEST_DATABASE', 'test_openeats')"; \
    echo "        }"; \
    echo "    }"; \
    echo "}"; \
    echo "LOGGING = {"; \
    echo "    'version': 1,"; \
    echo "    'disable_existing_loggers': False,"; \
    echo "    'handlers': {"; \
    echo "        'console': {"; \
    echo "            'class': 'logging.StreamHandler',"; \
    echo "        },"; \
    echo "    },"; \
    echo "    'loggers': {"; \
    echo "        'django': {"; \
    echo "            'handlers': ['console'],"; \
    echo "            'level': os.getenv('DJANGO_LOG_LEVEL', 'INFO'),"; \
    echo "        },"; \
    echo "    },"; \
    echo "}"; \
  } >> /code/base/settings.py
RUN cp /startup/prod-entrypoint.sh /startup/prod-entrypoint.sh.new && { \
  head -n$(wc -l /startup/prod-entrypoint.sh | awk '{ print $1 - 1}') /startup/prod-entrypoint.sh; \
  echo -n "exec "; \
  tail -n1 /startup/prod-entrypoint.sh; \
  } > /startup/prod-entrypoint.sh.new && mv /startup/prod-entrypoint.sh.new /startup/prod-entrypoint.sh
RUN cp base/gunicorn_start.sh base/gunicorn_start_new.sh && { \
  head -n$(wc -l base/gunicorn_start.sh | awk '{ print $1 - 1}') base/gunicorn_start.sh; \
  tail -n1 base/gunicorn_start.sh | sed -e 's/$/ \\/'; \
  echo '  --access-logfile - \'; \
  echo '  --error-logfile - \'; \
  echo '  --capture-output \'; \
  echo '  $@'; \
  } > base/gunicorn_start_new.sh && mv base/gunicorn_start_new.sh base/gunicorn_start.sh
ENTRYPOINT ["/startup/prod-entrypoint.sh"]
