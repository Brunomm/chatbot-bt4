FROM ruby:2.3-slim
# Instala as nossas dependencias
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential libpq-dev

# Seta nosso path
ENV PATH_APP /chatbot

# Cria nosso diretório
RUN mkdir -p $PATH_APP

# Seta o nosso path como o diretório principal
WORKDIR $PATH_APP

# Add bundle entry point to handle bundle cache
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Bundle installs with binstubs to our custom /bundle/bin volume path.
# Let system use those stubs.
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Instala a gem bundler para o novo PATH do BUNDLE
RUN gem install bundler

# Copia o nosso Gemfile para dentro do container
ADD Gemfile ./

# Instala as Gems
RUN bundle install

# Copia nosso código para dentro do container
COPY . .

# Roda nosso servidor
# CMD rackup config.ru -o 0.0.0.0