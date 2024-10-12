from pathlib import Path
from omegaconf import OmegaConf


from .date_logic import DateInterval, CVDateInterval


def main():
    content = Path("./content")
    sections = ("experience", "education", "skills")
    language = "es"
    data = OmegaConf.create(
        dict(
            (s, OmegaConf.load((content / language / s).with_suffix(".yaml")))
            for s in sections
        )
    )
    data = OmegaConf.merge(OmegaConf.load(content / "personal.yaml"), data)

    for item in data.experience:
        dt = DateInterval(item.start, item.end)
        dt = CVDateInterval.from_interval(dt, language)
        item["duration"] = dt.span
        item.start = dt.start
        item.end = dt.end

    with open("./src/cv.yaml", "w+") as f:
        f.write(OmegaConf.to_yaml(data))


if __name__ == "__main__":
    main()
