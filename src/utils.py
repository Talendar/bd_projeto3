def remove_comment(line):
    last_char = None
    for idx, char in enumerate(line):
        if f"{last_char}{char}" == "--":
            return line[:(idx - 1)]
        last_char = char
    return line
