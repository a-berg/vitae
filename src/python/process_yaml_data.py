from dataclasses import dataclass, field
from omegaconf import OmegaConf
from datetime import datetime, date
from dateutil.relativedelta import relativedelta

# import humanize


def parsedate(s: str) -> date:
    if s == "now":
        return datetime.now().date()
    else:
        return datetime.strptime(s, "%Y-%m-%d").date()


@dataclass
class DateInterval:
    start: date
    end: date

    def __post_init__(self):
        self.start = parsedate(self.start)
        self.end = parsedate(self.end)
        self.span = relativedelta(self.end, self.start)


class CVDateInterval:
    def __init__(self, I: DateInterval):
        self.start = self._date2str(I.start)
        self.end = self._date2str(I.end)
        self.span = humanize(I.span)

    def _date2str(self, date):
        if date == datetime.now().date():
            return "today"
        else:
            return date.strftime("%Y")

    def __repr__(self):
        return "{} -- {} ({})".format(self.start, self.end, self.duration)


def humanize(dt):
    yr = dt.years
    mo = dt.months

    def _inner(x: int, word: str):
        a = ""
        if x == 1:
            a = str(x) + " " + word
        elif x >= 2:
            a = str(x) + " " + word + "s"
        return a

    con = " & " if mo > 0 and yr > 0 else ""

    return _inner(yr, "year") + con + _inner(mo, "month")  # + "."


def main():
    data = OmegaConf.create(
        dict(
            personal=OmegaConf.load("./content/personal.yaml"),
            experience=OmegaConf.load("./content/en/experience.yaml"),
            education=OmegaConf.load("./content/en/education.yaml"),
            skills=OmegaConf.load("./content/en/skills.yaml"),
        )
    )

    for item in data.experience:
        dt = CVDateInterval(DateInterval(item.start, item.end))
        item["duration"] = dt.span
        item.start = dt.start
        item.end = dt.end

    with open("./src/cv.yaml", "w+") as f:
        f.write(OmegaConf.to_yaml(data))


if __name__ == "__main__":
    main()
