from pathlib import Path
from subprocess import check_output
from json import loads
from sys import argv

DEFAULT = """
---
### Back

Scenario:
Given:
When:
Then:"""

START = """
---
### Back

"""

OUTPUT_DIR = Path("test/features")

GHERKIN_TEMPLATE = """Feature: {}

{}"""


def entry():
    id = None if len(argv) <= 1 else int(argv[1])
    main(id)


def main(id: int | None):
    output = check_output(
        "gh issue list -L5000 -l'User Story' --json 'title,number,body'", shell=True
    )
    data = loads(output)
    for elem in data:
        n = elem["number"]
        if id is not None and n != id:
            continue
        title = elem["title"]
        body = elem["body"]
        filename = f"{n}-{'-'.join(title.replace('-',' ').lower().split())}.feature"
        print("------------")
        print(filename)
        if DEFAULT in body:
            print("Not implemented")
            continue
        _, gherkin = body.split(START)
        gherkin = GHERKIN_TEMPLATE.format(title, gherkin)
        print(gherkin)
        (OUTPUT_DIR / filename).write_text(gherkin)


if __name__ == "__main__":
    entry()