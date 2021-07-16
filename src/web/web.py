from flask import Flask, request, render_template


def init(db, host="localhost", port=3000):
    app = Flask(__name__)

    @app.route("/")
    def index():
        return """
            <!DOCTYPE html>
            <html lang="pt-BR">
            <head>
                <meta charset="UTF-8">
                <title>Projeto 3 de BD</title>
            </head>
            <body>
                <h1>Hello world!</h1>
            </body>
            </html>
        """

    app.run(host=host, port=port)
