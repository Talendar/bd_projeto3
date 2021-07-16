import argparse
from web import web
from database import Database


def _get_args():
    """ Parses the command line arguments and returns them. """
    parser = argparse.ArgumentParser(description=__doc__)

    # Subcommands:
    subparsers = parser.add_subparsers(dest="action")
    sub_run = subparsers.add_parser(
        "run",
        add_help=False,
        description="Runs the application.",
        help="Runs the application.",
    )
    sub_build = subparsers.add_parser(
        "build",
        add_help=False,
        description="Deletes all the database's tables and rebuild them.",
        help="Deletes all the database's tables and rebuild them.",
    )
    sub_print = subparsers.add_parser(
        "print",
        add_help=False,
        description="Prints all the names of all the tables currently in the database.",
        help="Prints all the names of all the tables currently in the database.",
    )

    # Arguments:
    for sub in [sub_run, sub_build, sub_print]:
        # Username:
        sub.add_argument(
            "--user", "-u",
            type=str,
            default=None,
            help="Username used to connect to the database.",
            required=True,
        )

        # Password:
        sub.add_argument(
            "--password", "-p",
            type=str,
            default=None,
            help="Password used to connect to the database.",
            required=True,
        )

        # Hostname:
        sub.add_argument(
            "--hostname", "-hn",
            type=str,
            default="grad.icmc.usp.br",
            help="Hostname of the database's server.",
        )

        # Port:
        sub.add_argument(
            "--port", "-t",
            type=int,
            default=15215,
            help="Port of the database's server.",
        )

        # Port:
        sub.add_argument(
            "--sid", "-s",
            type=str,
            default="orcl",
            help="Database's SID.",
        )

        # Custom client path:
        sub.add_argument(
            "--clientPath", "-c",
            type=str,
            default=None,
            help="Database's SID.",
        )

    return parser.parse_args()


def run(db):
    web.init(db)


def build(db):
    print("\nDropping all tables... ", end="")
    db.drop_all()
    print("done!")

    print("Rebuilding tables... ", end="")
    try:
        db.run_script("./sql/esquema.sql")
    except FileNotFoundError:
        db.run_script("../sql/esquema.sql")
    print("done!")


def print_tables(db):
    print(db.run("select table_name from all_tables"))


if __name__ == "__main__":
    args = _get_args()
    if None in [args.user, args.password]:
        raise ValueError("You must specify an username and a password!")

    db = Database(username=args.user,
                  password=args.password,
                  hostname=args.hostname,
                  port=args.port,
                  sid=args.sid,
                  custom_client_path=args.clientPath)

    if args.action == "run":
        run(db)
    elif args.action == "build":
        build(db)
    elif args.action == "print":
        print_tables(db)
    else:
        raise ValueError("Invalid action!")
