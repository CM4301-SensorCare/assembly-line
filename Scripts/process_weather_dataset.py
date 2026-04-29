import datetime as dt
import math
import csv



with open("Datasets/FilteredDataset.csv", "r") as inp:

    csvin = csv.reader(inp)
    next(csvin) # skip header
    
    with open("Datasets/ConvertedDataset.csv", "w") as out:
        csvout = csv.writer(out)
        csvout.writerow(("start_time", "end_time", "value"))

        last_unix = None

        for timestamp, val in csvin:

            parsed: dt.datetime = dt.datetime.strptime(timestamp, "%Y-%m-%dT%H:%M:%S")
            new_time = int(parsed.timestamp())

            if last_unix is None:
                last_unix = new_time - 1
            
            csvout.writerow((last_unix, new_time, val))

            last_unix = new_time

print("Done!")
            

            
            
