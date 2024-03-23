FROM python:3.10-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    tzdata \
    gdal-bin \
    libgdal-dev \
    python3-gdal \
    qgis \
    python3-qgis \
    curl \
    g++ \
    cmake \
    make \
    libcurl4-openssl-dev \
    libssl-dev \
    libtiff5-dev \
    libgeotiff-dev \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# Install PDAL
ENV PDAL_VERSION=2.6.3
RUN curl -sL https://github.com/PDAL/PDAL/archive/${PDAL_VERSION}.tar.gz | tar xz && \
    cd PDAL-${PDAL_VERSION} && \
    mkdir build && cd build && \
    cmake -DWITH_PYTHON=ON -DBUILD_PLUGIN_PYTHON=ON .. && \
    make && make install && \
    cd ../.. && rm -Rf PDAL-${PDAL_VERSION}

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}


# poetryのPATHを$PATHに追加
ENV PATH /root/.local/bin:$PATH

WORKDIR /work

COPY ["./work/pyproject.toml", "./work/poetry.lock", "/work/"]

RUN apt-get update \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && poetry config virtualenvs.create false \
    && poetry install

# Jupyter Labを起動する場合
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--port=9999"]