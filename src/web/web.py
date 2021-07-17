from flask import Flask, request, render_template
import os
from pathlib import Path


def simple_status_msg(content):
    return f"""
        <div style="
            display: flex;
            flex-direction: column;
            margin: 5% auto 0 auto;
            padding: 2em;
            width: 500px;
            border: #acacac solid 1px;
            border-radius: 10px;
            box-shadow: 5px 5px 5px #939393
        ">
            {content}
            <a href="/" style="align-self: center; font-size: 1.25em; margin-top: 1em;">
                Voltar
            </a>
        </div>
    """


def prettify_query_results(items, attrs_names):
    content = ""
    for item in items:
        content += "<ul>"
        for attr, name in zip(item, attrs_names):
            content += f"<li>{name}: {attr}</li>"
        content += "</ul>"
        content += '<div style="width: 150px; height: 2px; background-color: grey; margin-left: 30px;"></div>'
    return content


def init(db, host="localhost", port=3000):
    parent_path = Path(os.path.dirname(os.path.realpath(__file__))).parent.parent
    app = Flask(__name__, template_folder=str(parent_path / "assets"))

    @app.route("/")
    def index():
        return render_template("index.html")

    @app.route("/register_tourist", methods=["POST"])
    def register_tourist():
        data = request.form
        try:
            db.run(f"""
                INSERT INTO TURISTA(EMAIL,NOME,SENHA,PAIS)
                    VALUES ('{data['email']}', '{data['name']}',
                            '{data['password']}', '{data['country']}')
            """)
            content = "<h2>Turista cadastrado com sucesso!</h2>"
        except Exception as e:
            content = f"""
                <h2>Erro ao cadastrar turista!</h2>
                <p>Mensagem: {e}</p>
            """
        return simple_status_msg(content)

    @app.route("/register_service_provider", methods=["POST"])
    def register_service_provider():
        data = request.form
        try:
            db.run(f"""
                    INSERT INTO PRESTADORSERVICO(EMAIL,NOME,SENHA,PAIS)
                        VALUES ('{data['email']}', '{data['name']}',
                                '{data['password']}', '{data['country']}')
                """)
            content = "<h2>Prestador de serviço cadastrado com sucesso!</h2>"
        except Exception as e:
            content = f"""
                    <h2>Erro ao cadastrar prestador de serviço!</h2>
                    <p>Mensagem: {e}</p>
                """
        return simple_status_msg(content)

    @app.route("/register_country", methods=["POST"])
    def register_country():
        data = request.form
        try:
            db.run(f"""
                INSERT INTO PAIS(NOME,CONTINENTE,CAPITAL,LINGUA)
                    VALUES ('{data['name']}', '{data['continent']}',
                            '{data['capital']}', '{data['lang']}')
            """)
            content = "<h2>País cadastrado com sucesso!</h2>"
        except Exception as e:
            content = f"""
                <h2>Erro ao cadastrar país!</h2>
                <p>Mensagem: {e}</p>
            """
        return simple_status_msg(content)

    @app.route("/list_countries", methods=["POST", "GET"])
    def list_countries():
        try:
            results = db.run("SELECT * from PAIS")
            if len(results) == 0:
                content = "<h2>Não há países cadastrados!</h2>"
            else:
                content = "<h2>Países cadastrados:</h2>"
                content += prettify_query_results(results, ["Nome", "Continente", "Capital", "Língua"])
        except Exception as e:
            content = f"""
                    <h2>Erro na consulta!</h2>
                    <p>Mensagem: {e}</p>
                """
        return simple_status_msg(content)

    @app.route("/list_tourists", methods=["POST", "GET"])
    def list_tourists():
        try:
            results = db.run("SELECT * from TURISTA")
            if len(results) == 0:
                content = "<h2>Não há turistas cadastrados!</h2>"
            else:
                content = "<h2>Turistas cadastrados:</h2>"
                content += prettify_query_results(results, ["E-mail", "Nome","Senha", "País"])
        except Exception as e:
            content = f"""
                        <h2>Erro na consulta!</h2>
                        <p>Mensagem: {e}</p>
                    """
        return simple_status_msg(content)

    @app.route("/list_service_providers", methods=["POST", "GET"])
    def list_service_providers():
        try:
            results = db.run("SELECT * from prestadorservico")
            if len(results) == 0:
                content = "<h2>Não há prestador de serviço cadastrados!</h2>"
            else:
                content = "<h2>Prestadores de serviço cadastrados:</h2>"
                content += prettify_query_results(results, ["E-mail", "Nome", "Senha", "País"])
        except Exception as e:
            content = f"""
                           <h2>Erro na consulta!</h2>
                           <p>Mensagem: {e}</p>
                       """
        return simple_status_msg(content)

    app.run(host=host, port=port)
