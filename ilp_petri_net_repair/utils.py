def normalize_string(string: str):
    string = string.lower()
    tokens = string.split(' ')
    string = '_'.join(t.strip() for t in tokens)
    if string[0] in '0123456789':
        string = '_' + string
    return string