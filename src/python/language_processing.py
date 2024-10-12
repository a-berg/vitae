from dataclasses import dataclass
from typing import Literal

from typing import Any


def concat_qtties(*args):
    return " & ".join(filter(bool, args))


@dataclass
class Qtty:
    amount: Any

    def __mul__(self, other):
        if self.amount == 0:
            return ""
        return str(self.amount) + " " + other.pluralform(self.amount)


@dataclass
class Word:
    base: str
    plural: str = "s"

    def __repr__(self):
        return self.base

    def pluralform(self, n):
        if n == 1:
            return self.base
        return self.base + self.plural


@dataclass
class Langdict:
    lang: Literal["en", "es"]

    def __post_init__(self):
        self.now = dict(en=Word("now", ""), es=Word("actualidad", "es"))[self.lang]
        self.year = dict(en=Word("year"), es=Word("año"))[self.lang]
        self.month = dict(en=Word("month"), es=Word("mes", "es"))[self.lang]
