def str_sequence(prefix):
    i = 0
    while True:
        yield f"{prefix}{i}"
        i += 1

