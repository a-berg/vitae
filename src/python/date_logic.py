from dataclasses import dataclass
from datetime import datetime, date
from dateutil.relativedelta import relativedelta

from typing import Literal

from .language_processing import Qtty, Langdict, concat_qtties


@dataclass
class DateInterval:
    start: date
    end: date

    def __post_init__(self):
        self.start = self._parsedate(self.start)
        self.end = self._parsedate(self.end)
        self.span = relativedelta(self.end, self.start)

    def _parsedate(self, s: str) -> date:
        if s == "now":
            return datetime.now().date()
        else:
            return datetime.strptime(s, "%Y-%m-%d").date()


@dataclass
class CVDateInterval:
    start: date
    end: date
    span: date
    language: Literal["en", "es"] = "es"

    def __post_init__(self):
        self._langdict = Langdict(self.language)
        self.start = self._date2str(self.start)
        self.end = self._date2str(self.end)
        self.span = concat_qtties(
            (Qtty(self.span.years) * self._langdict.year),
            (Qtty(self.span.months) * self._langdict.month),
        )

    @classmethod
    def from_interval(cls, dt, language: str = "es"):
        return cls(dt.start, dt.end, dt.span, language)

    def _date2str(self, date):
        if date == datetime.now().date():
            return str(self._langdict.now)
        else:
            return date.strftime("%Y")

    def __repr__(self):
        return "{} -- {} ({})".format(self.start, self.end, self.duration)
