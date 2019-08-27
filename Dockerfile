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
  } >> /code/base/settings.py
RUN { \
  head -n$(wc -l base/gunicorn_start.sh | awk '{ print $1 - 1}') base/gunicorn_start.sh; \
  tail -n1 base/gunicorn_start.sh | sed -e 's/$/ \\/'; \
  echo '  --stdout_logfile=/dev/stdout \'; \
  echo '  --redirect_stderr=true'; \
  } >> base/gunicorn_start_new.sh && mv base/gunicorn_start_new.sh base/gunicorn_start.sh
ENTRYPOINT ["/startup/prod-entrypoint.sh"]
