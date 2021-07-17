Para que você possa se conectar à base de dados, é preciso ter um cliente Oracle instalado. Você pode encontrar instruções sobre como fazer isso [neste link](https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html#install-oracle-client).

Para instalar as dependências:

```shell
$ pip install -r requirements.txt
```

Para "compilar" o programa:

```shell
$ make install
```

Para criar a base de dados (substitua o usuário e a senha):

```shell
$ bin/dbproj3 build --user G123456 --password G123456
```


Para ligar o servidor web (substitua o usuário e a senha):

```shell
$ bin/dbproj3 run --user G123456 --password G123456
```

Caso queira ver os argumentos possíveis, execute:

```shell
$ ./bin/dbproj3 --help
```