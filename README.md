Para que você possa se conectar à base de dados, é preciso ter um cliente Oracle instalado. Você pode encontrar instruções sobre como fazer isso [neste link](https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html#install-oracle-client).

Para instalar as dependências:

```shell
$ pip install -r requirements.txt
```

Para "compilar" o programa:

```shell
$ make install
```

Para ligar o servidor web:

```shell
$ bin/dbproj3 run --user G123456 --password G123456
```

Caso queira ver os argumentos possíveis, execute:

```shell
$ ./bin/dbproj3 --help
```