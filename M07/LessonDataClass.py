from dataclasses import dataclass, field

@dataclass
class MeteoriteFinding:
    name: str
    id: int
    nametype: str
    meteoriteclass: str
    mass: float = field(metadata={"units":"grams"})
    fall: str
    year: str
    latitude: float = field(metadata={"units":"decimal degrees"})
    longitude: float = field(metadata={"units":"decimal degrees"})
    
import csv

# import from the CSV into a list of meteorite findings
findings = list()
with open("Meteorite_Landings.csv","r",newline='',encoding="utf-8-sig") as csvfile:
    meteorite_reader = csv.DictReader(csvfile)
    for row in meteorite_reader:
        finding = MeteoriteFinding(row['name'],row['id'],row['nametype'],row['recclass'],row['mass (g)'],row['fall'],row['year'],row['reclat'],row['reclong'])
        findings.append(finding)
        
print(findings)