def filter_paste(text):
    if text.endswith("\n"):
        return text[:-1]
    return text
