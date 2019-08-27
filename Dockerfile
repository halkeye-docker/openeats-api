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
    echo "        'OPTIONS': {"; \
    echo "            'charset': 'utf8mb4'"; \
    echo "        },"; \
    echo "        'TEST': {"; \
    echo "            'NAME': os.environ.get('MYSQL_TEST_DATABASE', 'test_openeats')"; \
    echo "        }"; \
    echo "    }"; \
    echo "}"; \
  } >> /code/base/settings.py
ENTRYPOINT ["/startup/prod-entrypoint.sh"]
