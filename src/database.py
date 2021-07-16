from typing import Optional, List, Any

import cx_Oracle
from utils import remove_comment


class Database:
    """ Wraps a cx-Oracle connection to a SQL database. """

    def __init__(self,
                 username: str,
                 password: str,
                 hostname: str = "grad.icmc.usp.br",
                 port: int = 15215,
                 sid: str = "orcl",
                 custom_client_path: Optional[str] = None) -> None:
        # Storing credentials:
        self._username = username
        self._password = password
        self._dsn_tns = cx_Oracle.makedsn(hostname, port, sid)

        # Init custom client:
        print()
        if custom_client_path is not None:
            print("Initializing oracle client library... ", end="")
            try:
                cx_Oracle.init_oracle_client(lib_dir=custom_client_path)
                print("done!")
            except cx_Oracle.ProgrammingError as e:
                print("\nClient library has already been initialized! Skipping.")

        # Connect to remote database:
        # (if an exception is raised, it will be thrown to the caller)
        self._db = cx_Oracle.connect(self._username,
                                     self._password,
                                     self._dsn_tns)
        print("Successfully connected to Oracle Database at: "
              f"{hostname}:{port}/{sid}")
        print("-" * 60 + "\n")

    def run(self, sql: str) -> List[Any]:
        """ Shortcut that instantiates a new cursor, executes a command with it,
        fetches and returns all the results and closes the cursor.
        """
        with self._db.cursor() as cursor:
            result = cursor.execute(sql)
            if result is not None:
                return result.fetchall()

    def cursor(self, *args, **kwargs) -> cx_Oracle.Cursor:
        """ Returns a new cursor.

        The cursor must be closed once it's no longer needed!
        """
        return self._db.cursor(*args, **kwargs)

    def drop_all(self):
        self.run("""
            BEGIN
               FOR cur_rec IN (SELECT object_name, object_type
                               FROM user_objects
                               WHERE object_type IN
                                         ('TABLE',
                                          'VIEW',
                                          'MATERIALIZED VIEW',
                                          'PACKAGE',
                                          'PROCEDURE',
                                          'FUNCTION',
                                          'SEQUENCE',
                                          'SYNONYM',
                                          'PACKAGE BODY'
                                         ))
               LOOP
                  BEGIN
                     IF cur_rec.object_type = 'TABLE'
                     THEN
                        EXECUTE IMMEDIATE 'DROP '
                                          || cur_rec.object_type
                                          || ' "'
                                          || cur_rec.object_name
                                          || '" CASCADE CONSTRAINTS';
                     ELSE
                        EXECUTE IMMEDIATE 'DROP '
                                          || cur_rec.object_type
                                          || ' "'
                                          || cur_rec.object_name
                                          || '"';
                     END IF;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        DBMS_OUTPUT.put_line ('FAILED: DROP '
                                              || cur_rec.object_type
                                              || ' "'
                                              || cur_rec.object_name
                                              || '"'
                                             );
                  END;
               END LOOP;
               FOR cur_rec IN (SELECT * 
                               FROM all_synonyms 
                               WHERE table_owner IN (SELECT USER FROM dual))
               LOOP
                  BEGIN
                     EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
                  END;
               END LOOP;
            END; 
        """)

    def run_script(self, filename, encoding="iso-8859-1"):
        """ Runs a SQL script. """
        with open(filename, encoding=encoding) as file:
            lines = [remove_comment(line) for line in file.readlines()]

            with self.cursor() as cursor:
                statement = ""
                for line in lines:
                    for char in line:
                        if char == ";":
                            try:
                                cursor.execute(statement)
                            except Exception as e:
                                raise RuntimeError(
                                    f"Failed to execute SQL: {statement}"
                                ) from e
                            statement = ""
                        else:
                            statement += char
